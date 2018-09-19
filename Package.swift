// swift-tools-version:4.2

import PackageDescription


let package = Package(
    name: "PetriKit",
    products: [
      .library(name: "PetriKit", type: .static, targets: ["PetriKit"]),
    ],
    targets: [
      .target(name: "PetriKit"),
      .testTarget(name: "PetriKitTests"),
    ]
  )
