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
        .package(url: "https://git.w-hs.de/Simon.Schoepke/fetch.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "Massive",
            dependencies: [
                .product(name: "Fetch", package: "fetch"),
                .product(name: "Crypto", package: "swift-crypto"),
            ]
        ),
        .executableTarget(
            name: "MassiveDemo",
            dependencies: ["Massive"]
        ),
        .testTarget(
            name: "MassiveTests",
            dependencies: ["Massive"]
        ),
    ]
)
