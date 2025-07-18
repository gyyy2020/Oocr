//
//  ContentView.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//


import SwiftUI
import Vision

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            if let selectedImage = appState.selectedImage {
                Image(nsImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                Divider()

                // Display a loading indicator OR the final text.
                // This makes the UI cleaner.
                ZStack {
                    if appState.isRecognizing {
                        ProgressView("Recognizing text...")
                            .padding()
                    } else {
                        ScrollView {
                            Text(appState.recognizedText)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                    }
                }
                .frame(maxHeight: .infinity)

            } else {
                Text("Select an image from the menu bar icon.")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(minWidth: 500, minHeight: 400)
        .onChange(of: appState.selectedImage) {
            // This now correctly handles the case where the view might appear
            // with an image already set.
            guard let newImage = appState.selectedImage else { return }
            performOCR(on: newImage)
        }
        // This is for when the view first appears.
        .onAppear {
            if let initialImage = appState.selectedImage {
                performOCR(on: initialImage)
            }
        }
    }

    // --- FUNCTION REVISED FOR RELIABILITY ---
    private func performOCR(on image: NSImage) {
        // 1. Set loading state and clear old text
        appState.isRecognizing = true
        appState.recognizedText = ""

        // 2. Use a more robust method to get a CGImage.
        // This avoids common issues with different image formats.
        guard let cgImage = createCGImage(from: image) else {
            DispatchQueue.main.async {
                appState.recognizedText = "Error: Could not convert the image. Please try a different image (e.g., a standard PNG or JPG)."
                appState.isRecognizing = false
            }
            return
        }

        // 3. Create the Vision request
        let request = VNRecognizeTextRequest { (request, error) in
            // Switch back to the main thread to update the UI
            DispatchQueue.main.async {
                appState.isRecognizing = false

                if let error = error {
                    appState.recognizedText = "OCR Error: \(error.localizedDescription)"
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                    appState.recognizedText = "No text was found in the image."
                    return
                }

                appState.recognizedText = observations.compactMap {
                    $0.topCandidates(1).first?.string
                }.joined(separator: "\n")
            }
        }

        // Configure the request for better accuracy
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        // Perform the request on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    appState.recognizedText = "Failed to perform Vision request: \(error.localizedDescription)"
                    appState.isRecognizing = false
                }
            }
        }
    }
    
    // --- NEW HELPER FUNCTION ---
    // This function reliably converts an NSImage to a CGImage.
    private func createCGImage(from nsImage: NSImage) -> CGImage? {
        var imageRect = CGRect(x: 0, y: 0, width: nsImage.size.width, height: nsImage.size.height)
        return nsImage.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
    }
}
