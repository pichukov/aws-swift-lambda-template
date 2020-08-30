// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aws-swift-lambda-template",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
      .executable(name: "aws-swift-lambda-template", targets: ["aws-swift-lambda-template"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .upToNextMajor(from:"0.2.0")),
        .package(url: "https://github.com/swift-aws/aws-sdk-swift.git", from: "5.0.0-alpha.4"),
        .package(url: "https://github.com/pichukov/aws-swift-dynamodb-crud-service.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "aws-swift-lambda-template",
            dependencies: [
                .product(name: "DynamoDBService", package: "aws-swift-dynamodb-crud-service"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift"),
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime")
            ]
        ),
        .testTarget(
            name: "aws-swift-lambda-templateTests",
            dependencies: ["aws-swift-lambda-template"]),
    ]
)
