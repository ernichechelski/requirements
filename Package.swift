// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Requirements",
    platforms: [
         .macOS(.v10_13),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "4.1.1"),
        .package(url: "https://github.com/eneko/MarkdownGenerator", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Requirements",
            dependencies: ["Files", "MarkdownGenerator"]),
        .testTarget(
            name: "RequirementsTests",
            dependencies: ["Requirements"]),
    ]
)
