//
//  MenuBar.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//


import SwiftUI

struct MenuBar: Scene {
    var body: some Scene {
        MenuBarExtra("OCR App", systemImage: "text.viewfinder") {
            
            // "Open Image" button
            // The action for this button is not yet implemented.
            Button("Open Image") {
                print("Open Image button clicked")
            }
            
            // Separator for visual clarity
            Divider()
            
            // "Quit" button
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
