//
//  MenuBar.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//


import SwiftUI
import UniformTypeIdentifiers
import Combine

struct MenuBar: Scene {
    @EnvironmentObject var appState: AppState
    @Environment(\.openWindow) var openWindow
    private let mainWindowID = "main-ocr-window"
    
    private let selectNewImagePublisher = NotificationCenter.default.publisher(for: .selectNewImage)

    var body: some Scene {
        MenuBarExtra("OCR App", systemImage: "text.viewfinder") {
            VStack {
                Button("Open Image") {
                    openImageFromFile()
                }
                Divider()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .onReceive(selectNewImagePublisher) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.openImageFromFile()
                }
            }
        }
    }
    
    private func openImageFromFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [UTType.jpeg, UTType.png, UTType.tiff]
        
        if panel.runModal() == .OK {
            if let url = panel.url, let image = NSImage(contentsOf: url) {
                // --- THIS IS THE FIX ---
                // Clear previous OCR results to ensure the process re-triggers
                // on the new window's .onAppear modifier.
                appState.recognizedText = ""
                
                // Now set the new image
                appState.selectedImage = image
                
                NSApp.setActivationPolicy(.regular)
                NSApp.activate(ignoringOtherApps: true)
                
                openWindow(id: mainWindowID)
            }
        }
    }
}
