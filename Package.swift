// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "LLRtmp",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "LLRtmp", type: .dynamic, targets: ["LLRtmp"])
    ],
    dependencies: [
        .package(url: "https://github.com/rampenke/Logboard.git", from: "2.2.1")
    ],
    targets: [
        .target(name: "SwiftPMSupport"),
        .target(name: "LLRtmp", dependencies: ["Logboard" , "SwiftPMSupport"],
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
