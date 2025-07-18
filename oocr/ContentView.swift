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

                ZStack(alignment: .top) {
                    if appState.isRecognizing {
                        ProgressView("Recognizing text...")
                            .padding()
                    } else {
                        // The ScrollView now contains both the text and the button
                        ScrollView {
                            Text(appState.recognizedText)
                                .padding()
                                .padding(.top, 25) // Add padding to not overlap with the button
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                        
                        // --- NEW: THE COPY BUTTON ---
                        HStack {
                            Spacer() // Pushes the button to the right
                            Button(action: copyTextToClipboard) {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            .padding(.trailing)
                            .padding(.top, 8)
                            // Disable the button if there is no text to copy
                            .disabled(appState.recognizedText.isEmpty)
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
            guard let newImage = appState.selectedImage else { return }
            performOCR(on: newImage)
        }
        .onAppear {
            if let initialImage = appState.selectedImage {
                performOCR(on: initialImage)
            }
        }
    }
    
    // --- NEW: FUNCTION FOR THE BUTTON ---
    private func copyTextToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(appState.recognizedText, forType: .string)
    }

    private func performOCR(on image: NSImage) {
        appState.isRecognizing = true
        appState.recognizedText = ""

        guard let cgImage = createCGImage(from: image) else {
            DispatchQueue.main.async {
                appState.recognizedText = "Error: Could not convert the image. Please try a different image (e.g., a standard PNG or JPG)."
                appState.isRecognizing = false
            }
            return
        }

        let request = VNRecognizeTextRequest { (request, error) in
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

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

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
    
    private func createCGImage(from nsImage: NSImage) -> CGImage? {
        var imageRect = CGRect(x: 0, y: 0, width: nsImage.size.width, height: nsImage.size.height)
        return nsImage.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
    }
}
