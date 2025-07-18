//
//  will.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var selectedImage: NSImage?
    
    // ---- NEW PROPERTIES ----
    // This will hold the text found by the OCR process.
    @Published var recognizedText: String = ""
    // This will be true while the OCR is in progress.
    @Published var isRecognizing: Bool = false
}
