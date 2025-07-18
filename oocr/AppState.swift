//
//  will.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//

import SwiftUI

// Add this extension at the top level of the file
extension Notification.Name {
    static let selectNewImage = Notification.Name("selectNewImageNotification")
}

class AppState: ObservableObject {
    @Published var selectedImage: NSImage?
    @Published var recognizedText: String = ""
    @Published var isRecognizing: Bool = false
    
    // --- NEW PROPERTY ---
    // Default to the first language in our list (English).
    @Published var selectedLanguage: Language = Language.availableLanguages[0]
}
