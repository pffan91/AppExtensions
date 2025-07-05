// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppExtensions",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "AppExtensions",
            targets: ["AppExtensions"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AppExtensions",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "AppExtensionsTests",
            dependencies: ["AppExtensions"]
        ),
    ]
)