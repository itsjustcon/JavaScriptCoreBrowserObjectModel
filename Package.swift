// swift-tools-version:4.0
//
//  Package.swift
//  JavaScriptCoreBrowserObjectModel
//
//  Created by Connor Grady on 11/14/17.
//  Copyright © 2017 Connor Grady. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "JavaScriptCoreBrowserObjectModel",
    dependencies: [
        //.Package(url: "https://github.com/httpswift/swifter.git", majorVersion: 1),
    ],
    exclude: [ "Tests" ]
)

/*
let package = Package(
    name: "JavaScriptCoreBrowserObjectModel",
    products: [
        .library(name: "iOS", targets: ["iOS"]),
        .library(name: "macOS", targets: ["macOS"]),
        .library(name: "tvOS", targets: ["tvOS"]),
    ],
    targets: [
        // iOS
        .target(
            name: "iOS",
            dependencies: []),
        .testTarget(
            name: "iOS Tests",
            dependencies: [
                "iOS",
                .Package(url: "https://github.com/httpswift/swifter.git", majorVersion: 1),
            ]),
        // macOS
        .target(
            name: "macOS",
            dependencies: []),
        .testTarget(
            name: "macOS Tests",
            dependencies: [
                "macOS",
                .Package(url: "https://github.com/httpswift/swifter.git", majorVersion: 1),
            ]),
        // tvOS
        .target(
            name: "tvOS",
            dependencies: []),
        .testTarget(
            name: "tvOS Tests",
            dependencies: [
                "tvOS",
                .Package(url: "https://github.com/httpswift/swifter.git", majorVersion: 1),
            ]),
    ],
    swiftLanguageVersions: [4]
)
*/
