//
//  MenuBar.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//


import SwiftUI
import UniformTypeIdentifiers

struct MenuBar: Scene {
    @EnvironmentObject var appState: AppState
    @Environment(\.openWindow) var openWindow
    
    // --- CHANGE IS HERE ---
    // The ID must match the one defined in OCRApp.swift
    private let mainWindowID = "main-ocr-window"

    var body: some Scene {
        MenuBarExtra("OCR App", systemImage: "text.viewfinder") {
            
            Button("Open Image") {
                openImageFromFile()
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
    
    private func openImageFromFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [UTType.jpeg, UTType.png]
        
        if panel.runModal() == .OK {
            if let url = panel.url, let image = NSImage(contentsOf: url) {
                appState.selectedImage = image
                
                // --- CHANGE IS HERE ---
                // We now specify which window to open by its ID.
                openWindow(id: mainWindowID)
            }
        }
    }
}
