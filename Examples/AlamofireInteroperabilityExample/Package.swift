// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlamofireInteroperabilityExample",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "AlamofireInteroperabilityExample",
            targets: ["AlamofireInteroperabilityExample"]
        )
    ],
    dependencies: [
        // .package(url: "https://github.com/ibrahimcetin/RequestSpec.git", from: "0.1.0"),
        .package(path: "../../"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "AlamofireInteroperabilityExample",
            dependencies: ["Alamofire", "RequestSpec"]
        )

    ]
)
