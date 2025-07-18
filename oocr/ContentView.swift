//
//  ContentView.swift
//  oocr
//
//  Created by Atlantic on 7/18/25.
//


import SwiftUI

struct ContentView: View {
    // Access the shared app state from the environment.
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            // Display the image if one has been selected.
            if let selectedImage = appState.selectedImage {
                Image(nsImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                // Show a placeholder message if no image is loaded.
                Text("Select an image from the menu bar icon.")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}
