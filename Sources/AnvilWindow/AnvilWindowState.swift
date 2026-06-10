import Foundation
#if canImport(AppKit)
    import AppKit
#endif

/// A snapshot of window state suitable for persistence.
///
/// ```swift
/// let snapshot = await AnvilWindowState.shared.capture()
/// // ... later ...
/// await AnvilWindowState.shared.restore(from: snapshot)
/// ```
public struct WindowStateSnapshot: Codable, Sendable, Equatable {
    public var id: String
    public var frame: WindowFrame
    public var isVisible: Bool
    public var level: Int

    public init(id: String, frame: WindowFrame, isVisible: Bool, level: Int) {
        self.id = id
        self.frame = frame
        self.isVisible = isVisible
        self.level = level
    }
}

/// A CGRect-like frame that is Codable.
public struct WindowFrame: Codable, Sendable, Equatable {
    public var x: Double
    public var y: Double
    public var width: Double
    public var height: Double

    public init(x: Double, y: Double, width: Double, height: Double) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    #if canImport(AppKit)
        public init(_ rect: CGRect) {
            x = Double(rect.origin.x)
            y = Double(rect.origin.y)
            width = Double(rect.size.width)
            height = Double(rect.size.height)
        }

        public var cgRect: CGRect {
            CGRect(x: x, y: y, width: width, height: height)
        }
    #endif
}

/// Actor for capturing and restoring window state.
///
/// ```swift
/// let state = await AnvilWindowState.shared.capture()
/// await AnvilWindowState.shared.restore(from: state)
/// ```
public actor AnvilWindowState {
    public static let shared = AnvilWindowState()

    private var snapshots: [String: WindowStateSnapshot] = [:]

    public init() { }

    /// Captures the current state of a window by ID.
    ///
    /// Returns `nil` if no window with the given ID is found.
    public func capture(id: String) -> WindowStateSnapshot? {
        #if canImport(AppKit)
            guard
                let app = NSApp,
                let window = app.windows.first(where: { $0.identifier?.rawValue == id })
            else {
                return snapshots[id]
            }
            let snapshot = WindowStateSnapshot(
                id: id,
                frame: WindowFrame(window.frame),
                isVisible: window.isVisible,
                level: window.level.rawValue
            )
            snapshots[id] = snapshot
            return snapshot
        #else
            return snapshots[id]
        #endif
    }

    /// Captures all known windows.
    public func captureAll() -> [WindowStateSnapshot] {
        Array(snapshots.values)
    }

    /// Restores a window from a snapshot.
    ///
    /// If no window with the snapshot's ID exists, the snapshot is stored for later restoration.
    public func restore(from snapshot: WindowStateSnapshot) {
        snapshots[snapshot.id] = snapshot
        #if canImport(AppKit)
            guard
                let app = NSApp,
                let window = app.windows.first(where: { $0.identifier?.rawValue == snapshot.id })
            else { return }
            window.setFrame(snapshot.frame.cgRect, display: true)
            window.level = NSWindow.Level(rawValue: snapshot.level)
            if snapshot.isVisible {
                window.makeKeyAndOrderFront(nil as NSWindow?)
            } else {
                window.orderOut(nil as NSWindow?)
            }
        #endif
    }

    /// Removes a snapshot for the given window ID.
    public func clear(id: String) {
        snapshots.removeValue(forKey: id)
    }

    /// Removes all stored snapshots.
    public func clearAll() {
        snapshots.removeAll()
    }
}
