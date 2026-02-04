// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Massive",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Massive",
            targets: ["Massive"]
        ),
    ],
    dependencies: [
        .package(url: "https://git.w-hs.de/Simon.Schoepke/fetch.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin.git", from: "1.0.0"),
        .package(url: "https://github.com/tsolomko/SWCompression.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.16.0"),
    ],
    targets: [
        .target(
            name: "Massive",
            dependencies: [
                .product(name: "Fetch", package: "fetch"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "SWCompression", package: "SWCompression"),
                .product(name: "WebSocketKit", package: "websocket-kit"),
            ]
        ),
        .testTarget(
            name: "MassiveTests",
            dependencies: ["Massive"]
        ),
    ]
)
