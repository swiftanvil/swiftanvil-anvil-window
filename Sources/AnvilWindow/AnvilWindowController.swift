import Foundation
#if canImport(AppKit)
import AppKit
#endif

/// Programmatic window management helper.
///
/// ```swift
/// AnvilWindowController.shared.showWindow(id: "inspector")
/// AnvilWindowController.shared.hideWindow(id: "inspector")
/// let exists = await AnvilWindowController.shared.windowExists(id: "inspector")
/// ```
public actor AnvilWindowController {
    public static let shared = AnvilWindowController()

    private var trackedWindows: Set<String> = []

    public init() {}

    /// Shows the window with the given ID (brings it to front).
    public func showWindow(id: String) {
        trackedWindows.insert(id)
        #if canImport(AppKit)
        if let app = NSApp,
           let window = app.windows.first(where: { $0.identifier?.rawValue == id }) {
            window.makeKeyAndOrderFront(nil as NSWindow?)
        }
        #endif
    }

    /// Hides the window with the given ID.
    public func hideWindow(id: String) {
        #if canImport(AppKit)
        if let app = NSApp,
           let window = app.windows.first(where: { $0.identifier?.rawValue == id }) {
            window.orderOut(nil as NSWindow?)
        }
        #endif
    }

    /// Closes the window with the given ID.
    public func closeWindow(id: String) {
        trackedWindows.remove(id)
        #if canImport(AppKit)
        if let app = NSApp,
           let window = app.windows.first(where: { $0.identifier?.rawValue == id }) {
            window.performClose(nil)
        }
        #endif
    }

    /// Returns `true` if a window with the given ID exists.
    public func windowExists(id: String) -> Bool {
        #if canImport(AppKit)
        guard let app = NSApp else { return trackedWindows.contains(id) }
        return app.windows.contains(where: { $0.identifier?.rawValue == id })
        #else
        trackedWindows.contains(id)
        #endif
    }

    /// Returns the frame of the window with the given ID, if it exists.
    public func windowFrame(id: String) -> WindowFrame? {
        #if canImport(AppKit)
        guard let app = NSApp,
              let window = app.windows.first(where: { $0.identifier?.rawValue == id }) else { return nil }
        return WindowFrame(window.frame)
        #else
        return nil
        #endif
    }

    /// All window IDs currently being tracked.
    public var trackedWindowIDs: [String] {
        Array(trackedWindows)
    }
}
