// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RuViewKit",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "RuViewKit", targets: ["RuViewKit"]),
    ],
    targets: [
        .target(
            name: "RuViewKit",
            path: "Sources/RuViewKit"
        ),
        .testTarget(
            name: "RuViewKitTests",
            dependencies: ["RuViewKit"],
            path: "Tests/RuViewKitTests"
        ),
    ]
)
