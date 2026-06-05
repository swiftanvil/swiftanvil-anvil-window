# AnvilWindow

macOS window management helpers: floating panels, HUD windows, and state restoration.

## Features

- **AnvilPanel**: SwiftUI `Scene` wrapper for floating `NSPanel`
- **AnvilHUD**: Transient HUD window with auto-dismiss
- **AnvilWindowState**: Save and restore window frames and visibility
- **AnvilWindowController**: Show, hide, and close windows programmatically

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swiftanvil/swiftanvil-anvil-window.git", from: "1.0.0"),
]
```

## Usage

### Floating Panel

```swift
import SwiftUI
import AnvilWindow

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }

        AnvilPanel("Inspector", id: "inspector") {
            InspectorView()
        }
        .floating(true)
        .resizable(false)
        .defaultSize(width: 300, height: 400)
    }
}
```

### HUD Window

```swift
AnvilHUD("Notification") {
    Text("Saved!")
}
.autoDismiss(after: 2.0)
```

### Window State

```swift
let snapshot = await AnvilWindowState.shared.capture(id: "inspector")
await AnvilWindowState.shared.restore(from: snapshot)
```

### Programmatic Control

```swift
await AnvilWindowController.shared.showWindow(id: "inspector")
await AnvilWindowController.shared.hideWindow(id: "inspector")
let exists = await AnvilWindowController.shared.windowExists(id: "inspector")
```

## Platforms

- macOS 15+

## License

MIT
