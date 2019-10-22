// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Blinkenlights",
    products: [
        .executable(
            name: "Blinkenlights",
            targets: ["Blinkenlights"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.8.0")
    ],
    targets: [
        .target(
            name: "Blinkenlights",
            dependencies: ["NIO"]),
        .testTarget(
            name: "BlinkenlightsTests",
            dependencies: ["Blinkenlights"]),
    ]
)
