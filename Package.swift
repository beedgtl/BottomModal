// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BottomModal",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "BottomModal",
      targets: ["BottomModal"]
    )
  ],
  dependencies: [
    .package(
      name: "PanModal",
      url: "https://github.com/baevra/PanModal",
      .exact("1.2.8")
    )
  ],
  targets: [
    .target(
      name: "BottomModal",
      dependencies: [
        "PanModal"
      ]
    ),
    .testTarget(
      name: "BottomModalTests",
      dependencies: ["BottomModal"]
    )
  ]
)
