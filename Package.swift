// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FancySliders",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v15),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "FancySliders",
            targets: ["FancySliders"]
        )
    ],
    targets: [
        .target(
            name: "FancySliders",
            path: "Sources"
        ),
        .testTarget(
            name: "FancySlidersTests",
            dependencies: ["FancySliders"],
            path: "Tests",
            exclude: ["CheckCocoaPodsQualityIndexes.rb"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
