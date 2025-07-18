//
//  is.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//


import Foundation

// The Hashable protocol is needed so we can use this struct in a Picker.
struct Language: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let code: String // The code Vision framework understands (e.g., "en-US")

    // A list of languages our app will support.
    // You can easily add more here later!
    static let availableLanguages: [Language] = [
        Language(name: "English", code: "en-US"),
        Language(name: "Chinese (Simplified)", code: "zh-Hans"),
        Language(name: "Japanese", code: "ja-JP"),
        Language(name: "Chinese (Traditional)", code: "zh-Hant"),
        Language(name: "French", code: "fr-FR"),
        Language(name: "German", code: "de-DE"),
        Language(name: "Korean", code: "ko-KR")
    ]
    
    // You can check for all supported languages by calling:
    // VNRecognizeTextRequest.supportedRecognitionLanguages(for: .accurate, revision: VNRecognizeTextRequestRevision3)
}