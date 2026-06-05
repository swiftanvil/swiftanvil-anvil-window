import SwiftUI

/// A SwiftUI scene that creates a floating panel window.
///
/// ```swift
/// AnvilPanel("Inspector", id: "inspector") {
///     InspectorView()
/// }
/// .floating(true)
/// .resizable(false)
/// .defaultSize(width: 300, height: 400)
/// ```
public struct AnvilPanel<Content: View>: Scene {
    private let title: String
    private let id: String
    private let content: Content
    private let isFloating: Bool
    private let isResizable: Bool
    private let defaultWidth: CGFloat
    private let defaultHeight: CGFloat
    private let windowLevel: NSWindow.Level

    public init(
        _ title: String,
        id: String,
        floating: Bool = true,
        resizable: Bool = false,
        defaultWidth: CGFloat = 300,
        defaultHeight: CGFloat = 400,
        level: NSWindow.Level = .floating,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.id = id
        self.isFloating = floating
        self.isResizable = resizable
        self.defaultWidth = defaultWidth
        self.defaultHeight = defaultHeight
        self.windowLevel = level
        self.content = content()
    }

    public var body: some Scene {
        WindowGroup(id: id) {
            content
        }
        .defaultSize(width: defaultWidth, height: defaultHeight)
    }

    // MARK: - Modifiers

    /// Returns a copy with the floating flag set.
    public func floating(_ value: Bool) -> AnvilPanel {
        AnvilPanel(
            title,
            id: id,
            floating: value,
            resizable: isResizable,
            defaultWidth: defaultWidth,
            defaultHeight: defaultHeight,
            level: windowLevel,
            content: { content }
        )
    }

    /// Returns a copy with the resizable flag set.
    public func resizable(_ value: Bool) -> AnvilPanel {
        AnvilPanel(
            title,
            id: id,
            floating: isFloating,
            resizable: value,
            defaultWidth: defaultWidth,
            defaultHeight: defaultHeight,
            level: windowLevel,
            content: { content }
        )
    }

    /// Returns a copy with the default size set.
    public func defaultSize(width: CGFloat, height: CGFloat) -> AnvilPanel {
        AnvilPanel(
            title,
            id: id,
            floating: isFloating,
            resizable: isResizable,
            defaultWidth: width,
            defaultHeight: height,
            level: windowLevel,
            content: { content }
        )
    }

    /// Returns a copy with the window level set.
    public func level(_ value: NSWindow.Level) -> AnvilPanel {
        AnvilPanel(
            title,
            id: id,
            floating: isFloating,
            resizable: isResizable,
            defaultWidth: defaultWidth,
            defaultHeight: defaultHeight,
            level: value,
            content: { content }
        )
    }
}
