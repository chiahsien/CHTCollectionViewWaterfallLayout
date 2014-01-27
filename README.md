CHTCollectionViewWaterfallLayout
===============================

[![Version](https://cocoapod-badges.herokuapp.com/v/CHTCollectionViewWaterfallLayout/badge.png)](http://cocoadocs.org/docsets/CHTCollectionViewWaterfallLayout)
[![Platform](https://cocoapod-badges.herokuapp.com/p/CHTCollectionViewWaterfallLayout/badge.png)](http://cocoadocs.org/docsets/CHTCollectionViewWaterfallLayout)

iOS 6 introduced a new feature called [UICollectionView]. **CHTCollectionViewWaterfallLayout** is a subclass of [UICollectionViewLayout].
This layout is inspired by [Pinterest]. It also is compatible with [PSTCollectionView].

Screen Shots
------------
![2 columns](https://raw.github.com/chiahsien/UICollectionViewWaterfallLayout/master/Screenshots/2-columns.png)
![3 columns](https://raw.github.com/chiahsien/UICollectionViewWaterfallLayout/master/Screenshots/3-columns.png)

Prerequisite
------------
* ARC
* Xcode 4.4+, which supports literals syntax.
* iOS 6+, or
* iOS 4.x/5.x, with [PSTCollectionView].

How to Use
----------
Read the demo codes and `CHTCollectionViewWaterfallLayout.h` header file for more information.

#### Step 1
There are some properties for you to set up.

``` objc
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGFloat verticalItemSpacically
```

It's your responsibility to set up `columnCount` and `itemWidth`, they are required. Others are optional.

#### Step 2
And your collectionView's delegate (which often is your view controller) must conforms to `CHTCollectionViewDelegateWaterfallLayout` protocol and implements the required method:

``` objc
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
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


[UICollectionView]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UICollectionView_class/Reference/Reference.html
[UICollectionViewLayout]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UICollectionViewLayout_class/Reference/Reference.html
[Pinterest]: http://pinterest.com/
[PSTCollectionView]: https://github.com/steipete/PSTCollectionView
