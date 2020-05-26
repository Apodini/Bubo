// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bubo",
    platforms: [
        .macOS(.v10_13),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/mtynior/ColorizeSwift.git", from: "1.5.0"),
        .package(url: "https://github.com/davecom/SwiftGraph.git", from: "3.0.0"),
        .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", from: "0.50200.0"),
        .package(name: "IndexStoreDB", url: "https://github.com/apple/indexstore-db.git", .branch("swift-5.2-branch"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Bubo",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ShellOut", package: "ShellOut"),
                .product(name: "ColorizeSwift", package: "ColorizeSwift"),
                .product(name: "SwiftGraph", package: "SwiftGraph"),
                .product(name: "SwiftSyntax", package: "SwiftSyntax"),
                .product(name: "IndexStoreDB", package: "IndexStoreDB")
        ]),
        .testTarget(
            name: "BuboTests",
            dependencies: ["Bubo"]),
    ]
)
