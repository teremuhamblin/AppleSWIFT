// swift-tools-version: 5.9
import PackageDescription

let sharedSwiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("StrictConcurrency")
]

let package = Package(
    name: "AppleSWIFT",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        // 1. SDK intégrable dans une app iOS / macOS / SwiftUI
        .library(
            name: "AppleSWIFT",
            targets: ["AppleSWIFT"]
        ),
        // 2. Logiciel de diagnostic en ligne de commande (Terminal macOS)
        .executable(
            name: "appleswift-diag",
            targets: ["AppleSWIFTCLI"]
        )
    ],
    dependencies: [
        // Zéro dépendance tierce : sécurité maximale & build ultra-rapide
    ],
    targets: [
        // Cœur du framework + Moteur de diagnostic matériel/système/réseau
        .target(
            name: "AppleSWIFT",
            path: "Sources/APP",
            swiftSettings: sharedSwiftSettings,
            linkerSettings: [
                .linkedFramework("Network"),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS, .visionOS])),
                .linkedFramework("IOKit", .when(platforms: [.macOS]))
            ]
        ),
        // Exécutable CLI de diagnostic
        .executableTarget(
            name: "AppleSWIFTCLI",
            dependencies: ["AppleSWIFT"],
            path: "Sources/CLI",
            swiftSettings: sharedSwiftSettings
        ),
        // Suite de tests unitaires
        .testTarget(
            name: "AppleSWIFTTests",
            dependencies: ["AppleSWIFT"],
            path: "Tests/APPTests",
            swiftSettings: sharedSwiftSettings
        )
    ]
)
