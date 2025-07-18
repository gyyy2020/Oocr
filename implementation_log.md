# OCR App Implementation Log

## Function 1: Menu Bar Icon

- **Objective:** Create a menu bar icon with "Open Image" and "Quit" buttons.
- **Files Modified:**
    - `OCRApp.swift`: Changed the main `App` scene to use `MenuBarExtra` instead of a default window.
    - `MenuBar.swift`: (New File) Created to define the content and behavior of the menu bar icon.
- **Implementation Details:**
    - Used `MenuBarExtra` to create the menu bar item.
    - The icon is set to `text.viewfinder`, a system symbol provided by Apple.
    - Added a "Open Image" button. For now, it only prints a message to the console.
    - Added a "Quit" button that terminates the application using `NSApplication.shared.terminate(nil)`.
- **Status:** **Waiting for verification.**