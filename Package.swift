// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftOpenAIMCP",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "swiftopenai-mcp",
            targets: ["SwiftOpenAIMCP"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/modelcontextprotocol/swift-sdk.git", from: "0.9.0"),
        .package(url: "https://github.com/jamesrochabrun/SwiftOpenAI.git", from: "4.3.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0")
    ],
    targets: [
        .executableTarget(
            name: "SwiftOpenAIMCP",
            dependencies: [
                .product(name: "MCP", package: "swift-sdk"),
                .product(name: "SwiftOpenAI", package: "SwiftOpenAI"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        )
    ]
)
