//
//  oocrApp.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//

import SwiftUI

@main
struct oocrApp: App {
    @StateObject private var appState = AppState()
    
    // --- CHANGE IS HERE ---
    // We've added a unique identifier to our WindowGroup.
    private let mainWindowID = "main-ocr-window"

    var body: some Scene {
        // We now identify our WindowGroup with a specific ID.
        WindowGroup(id: mainWindowID) {
            ContentView()
                .environmentObject(appState)
        }
        
        MenuBar()
            .environmentObject(appState)
    }
}
