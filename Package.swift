// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "geo",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "geo", targets: ["Geo"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftyfinch/Fish", from: "0.1.3"),
        .package(url: "https://github.com/jpsim/Yams", from: "5.1.3"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1")
    ],
    targets: [
        .executableTarget(name: "Geo", dependencies: [
            "Fish",
            "Yams",
            "Rainbow"
        ])
    ]
)
