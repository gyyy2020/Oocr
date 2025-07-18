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
                        ScrollView {
                            Text(appState.recognizedText)
                                .padding()
                                .padding(.top, 35) // Make more room for the controls
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                        
                        // --- UPDATED CONTROL BAR ---
                        HStack {
                            // The new Language Picker
                            Picker("Language", selection: $appState.selectedLanguage) {
                                ForEach(Language.availableLanguages) { language in
                                    Text(language.name).tag(language)
                                }
                            }
                            .pickerStyle(.menu) // Renders as a dropdown
                            .frame(maxWidth: 200)

                            Spacer() // Pushes controls apart
                            
                            Button(action: copyTextToClipboard) {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            .disabled(appState.recognizedText.isEmpty)
                        }
                        .padding()
                    }
                }
                .frame(maxHeight: .infinity)

            } else {
                Text("Select an image from the menu bar icon.")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(minWidth: 500, minHeight: 400)
        // OCR on image change
        .onChange(of: appState.selectedImage) {
            guard let newImage = appState.selectedImage else { return }
            performOCR(on: newImage)
        }
        // --- NEW: Re-run OCR on language change ---
        .onChange(of: appState.selectedLanguage) {
            // If there's an image loaded, re-process it with the new language.
            guard let currentImage = appState.selectedImage else { return }
            performOCR(on: currentImage)
        }
        .onAppear {
            if let initialImage = appState.selectedImage {
                performOCR(on: initialImage)
            }
        }
    }
    
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
                appState.recognizedText = "Error: Could not convert the image."
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
        
        // --- CRUCIAL CHANGE: SET THE LANGUAGE ---
        // Tell Vision which language to use based on our app's state.
        request.recognitionLanguages = [appState.selectedLanguage.code]
        
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
