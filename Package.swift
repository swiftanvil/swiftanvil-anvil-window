// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AnvilWindow",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "AnvilWindow", targets: ["AnvilWindow"]),
    ],
    targets: [
        .target(
            name: "AnvilWindow",
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ]
        ),
        .testTarget(
            name: "AnvilWindowTests",
            dependencies: ["AnvilWindow"],
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ]
        ),
    ]
)
