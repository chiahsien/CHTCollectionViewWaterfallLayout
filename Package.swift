// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CHTCollectionViewWaterfallLayout",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9)
    ],
    products: [
        .library(name: "CHTCollectionViewWaterfallLayout", targets: ["CHTCollectionViewWaterfallLayout"])
    ],
    targets: [
        .target(
            name: "CHTCollectionViewWaterfallLayout",
            path: "SwiftSources"
        )
    ],
    swiftLanguageVersions: [.v5]
)
