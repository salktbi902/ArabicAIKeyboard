// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "KeyboardKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "KeyboardKit",
            targets: ["KeyboardKit", "KeyboardKitDependencies"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/LicenseKit/LicenseKit.git",
            exact: "2.1.3"
        )
    ],
    targets: [
        .binaryTarget(
            name: "KeyboardKit",
            url: "https://github.com/KeyboardKit/KeyboardKit-Binaries/releases/download/10.2.1/KeyboardKit.zip",
            checksum: "eac03f3cbc62d1fdb59706bb193f97cf952c53e31821efc1a2b4c590714f4a62"
        ),
        .target(
            name: "KeyboardKitDependencies",
            dependencies: ["LicenseKit"],
            path: "Dependencies"
        )
    ]
)
