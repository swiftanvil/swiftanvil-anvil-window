import SwiftUI

/// A transient HUD (heads-up display) window.
///
/// ```swift
/// AnvilHUD("Notification") {
///     Text("Saved!")
/// }
/// .autoDismiss(after: 2.0)
/// ```
public struct AnvilHUD<Content: View>: View {
    private let title: String
    private let content: Content
    private let autoDismissInterval: TimeInterval?

    public init(
        _ title: String,
        autoDismiss: TimeInterval? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        autoDismissInterval = autoDismiss
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 8) {
            content
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 8)
        .frame(minWidth: 120, minHeight: 60)
        .onAppear {
            if let interval = autoDismissInterval {
                DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                    dismiss()
                }
            }
        }
    }

    private func dismiss() {
        #if canImport(AppKit)
            NSApp.keyWindow?.close()
        #endif
    }

    // MARK: - Modifiers

    /// Returns a copy that auto-dismisses after the given interval.
    public func autoDismiss(after interval: TimeInterval) -> AnvilHUD {
        AnvilHUD(title, autoDismiss: interval, content: { content })
    }
}
