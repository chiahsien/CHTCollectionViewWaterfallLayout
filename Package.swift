// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CHTCollectionViewWaterfallLayout",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9)
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
            ]
        ),
        .target(
            name: "CHTCollectionViewWaterfallLayoutObjC",
            path: "Source",
            sources: [
                "CHTCollectionViewWaterfallLayout.h",
                "CHTCollectionViewWaterfallLayout.m"
            ],
            publicHeadersPath: "."
        )
    ],
    swiftLanguageVersions: [.v5]
)
