// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "HaishinKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "HaishinKit", type: .dynamic, targets: ["HaishinKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/rampenke/Logboard.git", from: "2.2.1")
    ],
    targets: [
        .target(name: "HaishinKit", dependencies: ["Logboard"],
                path: "Sources",
                sources: [
                    "Codec",
                    "Extension",
                    "FLV",
                    "HTTP",
                    "ISO",
                    "Media",
                    "Net",
                    "PiP",
                    "RTMP",
                    "Util",
                    "Platforms"
                ])
    ]
)
