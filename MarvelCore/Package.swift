// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let packageDependancies: [Package.Dependency] = [
    .package(
        url: "https://github.com/pointfreeco/swift-composable-architecture",
        from: "1.17.1"
    ),
    .package(
        url: "https://github.com/pointfreeco/swift-snapshot-testing",
        from: "1.16.0"
    ),
    .package(url: "https://github.com/onevcat/Kingfisher", from: "8.1.1"),
    .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.2.2"),
    .package(path: "../ArkanaKeys/HorizonKeys"),
]

private let products: [Product] = [
    .library(
        name: "Heros",
        targets: ["Heros"]
    ),
    .library(
        name: "HorizonComponent",
        targets: ["HorizonComponent"]
    ),
    .library(
        name: "HorizonNetwork",
        targets: ["HorizonNetwork"]
    ),
]

private let swiftLintPlugin: [Target.PluginUsage]? = [
    .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
]

private let horizonComponent: Target.Dependency = "HorizonComponent"
private let NETWORK: Target.Dependency = "HorizonNetwork"
private let kingFisher: Target.Dependency = .product(
    name: "Kingfisher",
    package: "Kingfisher"
)
private let TCADependancy: Target.Dependency = .product(
    name: "ComposableArchitecture",
    package: "swift-composable-architecture"
)

private let keys: Target.Dependency = .product(
    name: "HorizonKeys",
    package: "HorizonKeys"
)

let package = Package(
    name: "MarvelCore",
    platforms: [.iOS(.v17)],
    products: products,
    dependencies: packageDependancies,
    targets: [
        .target(
            name: "Heros",
            dependencies: [
                TCADependancy,
                horizonComponent,
                NETWORK,
            ],
            resources: [],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ],
            plugins: swiftLintPlugin,
        ),
        .target(
            name: "HorizonNetwork",
            dependencies: [
                keys
            ],
            resources: [],
            plugins: swiftLintPlugin
        ),
        .target(
            name: "HorizonComponent",
            dependencies: [
                kingFisher,
            ],
            resources: [
                .copy("Resources/Icons/Images.xcassets"),
                .copy("Resources/Colors/Colors.xcassets"),
            ],
            plugins: swiftLintPlugin,
        ),
        .testTarget(
            name: "MarvelSnapshotTests",
            dependencies: [
                "Heros",
                horizonComponent,
                .product(
                    name: "SnapshotTesting",
                    package: "swift-snapshot-testing"
                ),
            ],
            plugins: swiftLintPlugin,
        ),
        .testTarget(
            name: "MarvelCoreTests",
            dependencies: [
                "Heros",
                TCADependancy,
            ],
//            plugins: swiftLintPlugin,
        ),
    ],
    swiftLanguageModes: [.version("6.0")]
)
