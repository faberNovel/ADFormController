// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "ADFormController",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ADFormController",
            targets: ["ADFormController"]
        )
    ],
    dependencies: [
        .package(url: "git@github.com:faberNovel/ADKeyboardManager.git", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "ADFormController",
            dependencies: [
                .product(name: "ADKeyboardManager", package: "ADKeyboardManager"),
            ],
            path: "Modules/ADFormController/Classes"
        )
    ]
)
