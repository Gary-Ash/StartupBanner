// swift-tools-version: 6.2
/*****************************************************************************************
 * Package.swift
 *
 * Swift Package Manager manifest for the startup-banner terminal utility
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import PackageDescription

let package = Package(
    name: "startup-banner",
    platforms: [
        .macOS(.v14),
    ],
    targets: [
        .target(
            name: "StartupBannerLib",
            path: "Sources/startup-banner",
            exclude: ["main.swift"],
            linkerSettings: [
                .linkedFramework("IOKit"),
            ]
        ),
        .executableTarget(
            name: "startup-banner",
            dependencies: ["StartupBannerLib"],
            path: "Sources/startup-banner-cli",
            linkerSettings: [
                .linkedFramework("IOKit"),
            ]
        ),
        .testTarget(
            name: "startup-bannerTests",
            dependencies: ["StartupBannerLib"]
        ),
    ]
)
