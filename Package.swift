// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppleSWIFT",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "AppleSWIFT",
            targets: ["AppleSWIFT"]
        )
    ],
    targets: [
        .target(
            name: "AppleSWIFT",
            path: "Sources/APP"
        ),
        .testTarget(
            name: "AppleSWIFTTests",
            dependencies: ["AppleSWIFT"],
            path: "Tests/APPTests"
        )
    ]
)
