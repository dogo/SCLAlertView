// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SCLAlertViewObjC",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "SCLAlertViewObjC",
            type: .dynamic,
            targets: ["SCLAlertViewObjC"]
        )
    ],
    targets: [
        .target(
            name: "SCLAlertViewObjC",
            path: "SCLAlertView",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
            ]
        )
    ]
)
