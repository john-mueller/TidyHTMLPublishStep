// swift-tools-version:5.5

// TidyHTMLPublishStep
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

import PackageDescription

let package = Package(
    name: "TidyHTMLPublishStep",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "TidyHTMLPublishStep", targets: ["TidyHTMLPublishStep"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Publish.git", from: "0.1.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.0.0"),
    ],
    targets: [
        .target(name: "TidyHTMLPublishStep", dependencies: ["Publish", "SwiftSoup"]),
        .testTarget(name: "TidyHTMLPublishStepTests", dependencies: ["TidyHTMLPublishStep"]),
    ]
)
