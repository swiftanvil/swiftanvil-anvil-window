// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AnvilWindow",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "AnvilWindow", targets: ["AnvilWindow"])
    ],
    targets: [
        .target(
            name: "AnvilWindow"
        ),
        .testTarget(
            name: "AnvilWindowTests",
            dependencies: ["AnvilWindow"]
        )
    ],
    swiftLanguageModes: [.v6]
)
