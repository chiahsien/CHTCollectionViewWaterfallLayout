// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CHTCollectionViewWaterfallLayout",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(name: "CHTCollectionViewWaterfallLayout", targets: ["CHTCollectionViewWaterfallLayout"]),
        .library(name: "CHTCollectionViewWaterfallLayoutObjC", targets: ["CHTCollectionViewWaterfallLayoutObjC"])
    ],
    targets: [
        .target(
            name: "CHTCollectionViewWaterfallLayout",
            path: "Source",
            sources: [
                "CHTCollectionViewWaterfallLayout.swift"
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ]
        ),
        .target(
            name: "CHTCollectionViewWaterfallLayoutObjC",
            path: "Source",
            sources: [
                "CHTCollectionViewWaterfallLayout.h",
                "CHTCollectionViewWaterfallLayout.m"
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ],
            publicHeadersPath: "."
        )
    ]
)
