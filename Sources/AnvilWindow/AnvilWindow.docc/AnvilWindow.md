# ``AnvilWindow``

macOS window management helpers: floating panels, HUD windows, and state restoration.

## Overview

```swift
AnvilPanel("Inspector", id: "inspector") {
    InspectorView()
}
.floating(true)
.resizable(false)
.defaultSize(width: 300, height: 400)
```

## Topics

### Scenes

- ``AnvilPanel``
- ``AnvilHUD``

### State Management

- ``AnvilWindowState``
- ``WindowStateSnapshot``
- ``WindowFrame``

### Programmatic Control

- ``AnvilWindowController``
