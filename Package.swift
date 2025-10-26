// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SCLAlertView-Objective-C",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "SCLAlertView-Objective-C",
            type: .dynamic,
            targets: ["SCLAlertView-Objective-C"]
        )
    ],
    targets: [
        .target(
            name: "SCLAlertView-Objective-C",
            path: "SCLAlertView",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
            ]
        )
    ]
)
