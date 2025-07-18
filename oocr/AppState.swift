//
//  will.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//


import SwiftUI

// This class will hold the shared state for our application.
class AppState: ObservableObject {
    // @Published will notify any listening views when the selected image changes.
    @Published var selectedImage: NSImage?
}