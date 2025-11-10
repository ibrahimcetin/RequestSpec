// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "URLSessionInteroperabilityExample",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .visionOS(.v1), .watchOS(.v6)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "URLSessionInteroperabilityExample",
            targets: ["URLSessionInteroperabilityExample"]
        )
    ],
    dependencies: [
        // .package(url: "https://github.com/ibrahimcetin/RequestSpec.git", from: "0.1.0"),
        .package(path: "../../")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "URLSessionInteroperabilityExample",
            dependencies: [
                .product(name: "RequestSpec", package: "RequestSpec")
            ]
        )
    ]
)
