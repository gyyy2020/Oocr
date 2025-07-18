//
//  will.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//

import SwiftUI

// --- NEW ENUM ---
// This defines our layout options in a type-safe way.
// CaseIterable lets us easily loop through all cases for the Picker.
enum LayoutDirection: String, CaseIterable, Identifiable {
    case vertical = "Bottom"
    case horizontal = "Right"
    
    var id: Self { self }
}

extension Notification.Name {
    static let selectNewImage = Notification.Name("selectNewImageNotification")
}

class AppState: ObservableObject {
    @Published var selectedImage: NSImage?
    @Published var recognizedText: String = ""
    @Published var isRecognizing: Bool = false
    @Published var selectedLanguage: Language = Language.availableLanguages[0]
    
    // --- NEW PROPERTY ---
    // The default layout will be vertical (text at the bottom).
    @Published var selectedLayout: LayoutDirection = .vertical
}
