// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Massive",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(
            name: "Massive",
            targets: ["Massive"]
        ),
    ],
    dependencies: [
        .package(path: "../Fetch"),
    ],
    targets: [
        .target(
            name: "Massive",
            dependencies: ["Fetch"]
        ),
        .testTarget(
            name: "MassiveTests",
            dependencies: ["Massive"]
        ),
    ]
)
