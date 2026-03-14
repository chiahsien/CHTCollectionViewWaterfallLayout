CHTCollectionViewWaterfallLayout
================================

[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/CHTCollectionViewWaterfallLayout.svg)](https://cocoapods.org/pods/CHTCollectionViewWaterfallLayout)
[![Platform](https://img.shields.io/cocoapods/p/CHTCollectionViewWaterfallLayout.svg)](https://cocoapods.org/pods/CHTCollectionViewWaterfallLayout)
[![Build Status](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout/workflows/CHTCollectionViewWaterfallLayout%20CI/badge.svg?branch=develop)](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout/actions)

**CHTCollectionViewWaterfallLayout** is a subclass of [UICollectionViewLayout], and it tries to imitate [UICollectionViewFlowLayout]'s usage as much as possible.

This layout is inspired by [Pinterest].

Screenshots
-----------
![2 columns](Screenshots/2-columns.png)

Features
--------
* Easy to use, it tries to imitate [UICollectionViewFlowLayout]'s usage as much as possible.
* Highly customizable.
* Outstanding performance, try 10,000+ items and see the smoothness for yourself.
* Support header and footer views.
* Different column counts in different sections.

<a href="https://www.buymeacoffee.com/chiahsien"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=chiahsien&button_colour=5F7FFF&font_colour=ffffff&font_family=Comic&outline_colour=000000&coffee_colour=FFDD00" /></a>

Requirements
------------
* iOS 13+ / tvOS 13+
* Swift 5.0+ or Objective-C

How to Install
--------------

### [Swift Package Manager] (Recommended)

Add it to the `dependencies` value of your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/chiahsien/CHTCollectionViewWaterfallLayout.git", from: "1.0.0")
]
```

Two library products are available:
- `CHTCollectionViewWaterfallLayout` — Swift implementation
- `CHTCollectionViewWaterfallLayoutObjC` — Objective-C implementation

### [CocoaPods]

> **Note:** CocoaPods is [no longer actively maintained](https://blog.cocoapods.org/CocoaPods-Specs-Repo/). We recommend migrating to [Swift Package Manager] for future updates.

Add the following to your Podfile:

```ruby
pod 'CHTCollectionViewWaterfallLayout'           # Swift (default)
pod 'CHTCollectionViewWaterfallLayout/ObjC'      # Objective-C
```

### Manual

Copy `CHTCollectionViewWaterfallLayout.swift` (Swift) or `CHTCollectionViewWaterfallLayout.h/.m` (Objective-C) to your project.

Migrating to v1.0.0
--------------------

v1.0.0 includes a full rewrite of the Swift implementation. The Objective-C implementation is unchanged. If you are using the Swift version, please review the following breaking changes.

### Deployment Target

The minimum deployment target is now **iOS 13 / tvOS 13** (was iOS 9 / tvOS 9). Projects targeting earlier versions cannot adopt this release.

### Swift Toolchain

`swift-tools-version` is now **5.9** (was 5.0). Xcode 15+ is required to resolve this package via SPM.

### Supplementary View Element Kind

Headers and footers are now created with custom element kind strings (`CHTCollectionElementKindSectionHeader` / `CHTCollectionElementKindSectionFooter`) to match the Objective-C implementation. In 0.9.x these constants were marked `@available(*, unavailable)` and redirected to `UICollectionView.elementKindSectionHeader/Footer`.

If you register supplementary views, update the element kind:

```swift
// Before (0.9.x)
collectionView.register(HeaderView.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: "Header")

// After (1.0.0)
collectionView.register(HeaderView.self,
                        forSupplementaryViewOfKind: CHTCollectionElementKindSectionHeader,
                        withReuseIdentifier: "Header")
```

> `layoutAttributesForSupplementaryView(ofKind:at:)` accepts both variants, so layout queries work either way. But `layoutAttributesForElements(in:)` returns attributes with the `CHT`-prefixed kind, so any code filtering by `representedElementKind` must match accordingly.

### Return Type Change

`layoutAttributesForSupplementaryView(ofKind:at:)` now returns `UICollectionViewLayoutAttributes?` (optional) instead of a non-optional value. It returns `nil` for unknown element kinds instead of an empty attributes object.

### Removed Public `delegate` Property

The `delegate` computed property is now `private`. Access the delegate through `collectionView.delegate` instead.

### Removed Migration Shims

The following `@available(*, unavailable, renamed:)` declarations from 0.9.x have been removed. If your code still references the old names, rename them:

| Removed                                               | Replacement                                            |
|-------------------------------------------------------|--------------------------------------------------------|
| `sizeForItemAtIndexPath:`                             | `sizeForItemAt:`                                       |
| `heightForHeaderInSection:`                           | `heightForHeaderIn:`                                   |
| `heightForFooterInSection:`                           | `heightForFooterIn:`                                   |
| `insetForSectionAtIndex:`                             | `insetsFor:`                                           |
| `minimumInteritemSpacingForSectionAtIndex:`           | `minimumInteritemSpacingFor:`                          |
| `columnCountForSection:`                              | `columnCountFor:`                                      |
| `CHTCollectionViewWaterfallLayoutItemRenderDirection` | `CHTCollectionViewWaterfallLayout.ItemRenderDirection` |

### New Properties and Delegate Methods

The following are additive (non-breaking) but worth noting:

* **Properties**: `headerInset`, `footerInset`, `minimumContentHeight`
* **Delegate methods**: `insetsForHeaderIn:`, `insetsForFooterIn:`, `minimumColumnSpacingFor:`

All have sensible defaults and do not require adoption.

How to Use
----------

Both Swift and Objective-C demo projects are included in the `Demo/` directory. Read the demo code and the source headers for more information.

### Step 1: Configure the Layout

Below are the properties available for customizing the layout. Although they have default values, it is strongly recommended to set at least `columnCount` to suit your needs.

The `itemRenderDirection` property controls the order in which items are rendered in subsequent rows: left-to-right, right-to-left, or shortest column first.

#### Swift

```swift
let layout = CHTCollectionViewWaterfallLayout()
layout.columnCount = 2
layout.minimumColumnSpacing = 10
layout.minimumInteritemSpacing = 10
layout.headerHeight = 0
layout.footerHeight = 0
layout.headerInset = .zero
layout.footerInset = .zero
layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
layout.itemRenderDirection = .shortestFirst
layout.minimumContentHeight = 0
```

#### Objective-C

```objc
CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
layout.columnCount = 2;
layout.minimumColumnSpacing = 10;
layout.minimumInteritemSpacing = 10;
layout.headerHeight = 0;
layout.footerHeight = 0;
layout.headerInset = UIEdgeInsetsZero;
layout.footerInset = UIEdgeInsetsZero;
layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
layout.itemRenderDirection = CHTCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst;
layout.minimumContentHeight = 0;
```

### Step 2: Implement the Delegate

Your collection view's delegate (typically your view controller) must conform to `CHTCollectionViewDelegateWaterfallLayout` and implement the required method. Return the original size of each item:

#### Swift

```swift
func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
  return CGSize(width: imageWidth, height: imageHeight)
}
```

#### Objective-C

```objc
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(imageWidth, imageHeight);
}
```

Limitations
-----------
* Only vertical scrolling is supported.
* No decoration view.

Who Is Using It
---------------
Please let me know if your app is using this library. I'm glad to put your app on the list :-)

* [F3PiX](https://apps.apple.com/us/app/samenwerken-f3pix/id897714553)
  F3PiX is a series of apps which gives you a concise, curated collection of pictures by professional (Dutch) photographers according to a specific theme. You can use the pictures freely for your own work.
* [GroupMe for iOS](https://apps.apple.com/us/app/groupme/id392796698)
  GroupMe - A Home for All the Groups in Your Life.
* [Flickr](https://apps.apple.com/us/app/id328407587)
  Access and organize your photos from anywhere.
* [Tumblr](https://www.tumblr.com/policy/en/ios-credits)
  Post whatever you want to your Tumblr. Follow other people who are doing the same. You'll probably never be bored again.
* [Funliday](https://apps.apple.com/us/app/funlidays-lu-you-gui-hua/id905768387)
  The best trip planning app in the world!
* [Imgur](https://apps.apple.com/us/app/imgur-funny-gifs-memes-images/id639881495)
  Funny GIFs, Memes, and Images!
* [DealPad](https://apps.apple.com/us/app/dealpad-bargains-freebies/id949294107)
  DealPad gives you access to the UK's hottest Deals, Voucher Codes and Freebies in the palm of your hand.
* [Teespring Shopping](https://apps.apple.com/app/apple-store/id1144693237)
  Browse and purchase shirts, mugs, totes and more!

License
-------
CHTCollectionViewWaterfallLayout is available under the MIT license. See the LICENSE file for more info.

Changelog
---------
Refer to the [Releases page](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout/releases).

[UICollectionViewLayout]: https://developer.apple.com/documentation/uikit/uicollectionviewlayout
[UICollectionViewFlowLayout]: https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout
[Pinterest]: https://pinterest.com/
[CocoaPods]: https://cocoapods.org/
[Swift Package Manager]: https://swift.org/package-manager/
