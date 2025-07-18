# OCR App Implementation Log

## Function 1: Menu Bar Icon

- **Objective:** Create a menu bar icon with "Open Image" and "Quit" buttons.
- **Status:** ✅ **Verified.**

---

## Function 2: Open a Picture in a Window

- **Objective:** Allow the user to select an image file (jpg, png) and display it in a new window.
- **Files Modified/Created:**
    - `AppState.swift`: (New File) Created an `ObservableObject` to manage the currently selected `NSImage`.
    - `ContentView.swift`: (New File) Created a SwiftUI View to display the image from the `AppState`.
    - `OCRApp.swift`: (Modified) Instantiated `AppState`. Set up a `WindowGroup` **with a unique ID ("main-ocr-window")** for the `ContentView`. Passed the `AppState` as an `environmentObject`.
    - `MenuBar.swift`: (Modified) Implemented the `openImageFromFile` function. This function uses `NSOpenPanel` to let the user select a file. On success, it updates `appState.selectedImage` and calls **`openWindow(id: "main-ocr-window")`** to show the correct window.
- **Status:** **Waiting for verification.**