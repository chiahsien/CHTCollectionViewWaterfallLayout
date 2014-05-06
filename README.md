CHTCollectionViewWaterfallLayout
===============================

[![Version](https://cocoapod-badges.herokuapp.com/v/CHTCollectionViewWaterfallLayout/badge.png)](http://cocoadocs.org/docsets/CHTCollectionViewWaterfallLayout)
[![Platform](https://cocoapod-badges.herokuapp.com/p/CHTCollectionViewWaterfallLayout/badge.png)](http://cocoadocs.org/docsets/CHTCollectionViewWaterfallLayout)
[![Build Status](https://travis-ci.org/chiahsien/CHTCollectionViewWaterfallLayout.svg?branch=develop)](https://travis-ci.org/chiahsien/CHTCollectionViewWaterfallLayout)

**CHTCollectionViewWaterfallLayout** is a subclass of [UICollectionViewLayout], and it trys to imitate [UICollectionViewFlowLayout]'s usage as much as possible.

This layout is inspired by [Pinterest]. It also is compatible with [PSTCollectionView].

Screen Shots
------------
![2 columns](https://raw.github.com/chiahsien/UICollectionViewWaterfallLayout/master/Screenshots/2-columns.png)

Features
--------
* Easy to use, it trys to imitate [UICollectionViewFlowLayout]'s usage as much as possible.
* Highly customizable.
* Outstanding performance, try 10,000+ items and see the smoothness for yourself.
* Support header and footer views.

Prerequisite
------------
* ARC
* Xcode 4.4+, which supports literals syntax.
* iOS 6+, or
* iOS 4.x/5.x, with [PSTCollectionView].

How to install
--------------
* [CocoaPods]  
  Add `pod 'CHTCollectionViewWaterfallLayout'` to your podfile.
* Manual  
  Copy `CHTCollectionViewWaterfallLayout.h/m` to your project.

How to Use
----------
Read the demo codes and `CHTCollectionViewWaterfallLayout.h` header file for more information.

#### Step 1
Below lists the properties for you to customize the layout. Although they have default values, I strongly recommand you to set up at least the `columnCount` property to suit your needs.

``` objc
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) CGFloat minimumColumnSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
```

#### Step 2
Your collection view's delegate (which often is your view controller) must conforms to `CHTCollectionViewDelegateWaterfallLayout` protocol and implements the required method, all you need to do is return the original size of the item:

``` objc
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
```

#### Step 3 (Optional)
If you need to support iOS 4.x/5.x and you have installed [PSTCollectionView], then you **NEED** to modify some codes.

Quoted from [PSTCollectionView] README file:
> **If you want to have PSTCollectionView on iOS4.3/5.x and UICollectionView on iOS6, use PSUICollectionView (basically add PS on any UICollectionView* class to get auto-support for older iOS versions)**
> If you always want to use PSTCollectionView, use PSTCollectionView as class names. (replace the UI with PST)

Limitation
----------
* Only vertical scrolling is supported.
* No decoration view.

License
-------
CHTCollectionViewWaterfallLayout is available under the MIT license. See the LICENSE file for more info.

Changelog
---------
Refer to the [Releases page](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout/releases).

[UICollectionViewLayout]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UICollectionViewLayout_class/Reference/Reference.html
[UICollectionViewFlowLayout]: https://developer.apple.com/library/ios/documentation/uikit/reference/UICollectionViewFlowLayout_class/Reference/Reference.html
[Pinterest]: http://pinterest.com/
[PSTCollectionView]: https://github.com/steipete/PSTCollectionView
[CocoaPods]: http://cocoapods.org/

