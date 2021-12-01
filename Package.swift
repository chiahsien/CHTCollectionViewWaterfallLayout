// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CHTCollectionViewWaterfallLayout",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9)
    ],
    products: [
        .library(name: "CHTCollectionViewWaterfallLayout", targets: ["CHTCollectionViewWaterfallLayout"]),
        .library(name: "CHTCollectionViewWaterfallLayoutObjC", targets: ["CHTCollectionViewWaterfallLayoutObjC"])
    ],
    targets: [
        .target(
            name: "CHTCollectionViewWaterfallLayout",
            path: "SwiftSources"
        ),
        .target(
            name: "CHTCollectionViewWaterfallLayoutObjC",
            path: ".",
            sources: [
                "CHTCollectionViewWaterfallLayout.h",
                "CHTCollectionViewWaterfallLayout.m"
            ],
            publicHeadersPath: "."
        )
    ],
    swiftLanguageVersions: [.v5]
)
