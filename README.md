UICollectionViewWaterfallLayout
===============================

iOS 6 introduced a new feature called [UICollectionView](http://developer.apple.com/library/ios/#documentation/uikit/reference/UICollectionView_class/Reference/Reference.html). **UICollectionViewWaterfallLayout** is a subclass of [UICollectionViewLayout](http://developer.apple.com/library/ios/#documentation/uikit/reference/UICollectionViewLayout_class/Reference/Reference.html).

This layout is inspired by [Pinterest](http://pinterest.com/). It also is compatible with [PSTUICollectionView][1].

Screen Shots
------------
![2 columns](https://raw.github.com/chiahsien/UICollectionViewWaterfallLayout/master/Screenshots/2-columns.png)
![3 columns](https://raw.github.com/chiahsien/UICollectionViewWaterfallLayout/master/Screenshots/3-columns.png)

Prerequisite
------------
* ARC
* Xcode 4.4+, which supports literals syntax.
* iOS 6+, or
* iOS 4.x/5.x, with [PSTUICollectionView][1].

How to Use
----------
Read the demo codes for detail information.

#### Step 1
There are four properties for you to set up.

```objc
@property (nonatomic, weak) id<UICollectionViewDelegateWaterfallLayout> delegate;
@property (nonatomic, assign) NSUInteger columnCount; // How many columns
@property (nonatomic, assign) CGFloat itemWidth; // Width for every column
@property (nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to lay out content in a section
```

It's your responsibility to set up `delegate`, `columnCount`, and `itemWidth`, they are required. But `sectionInset` is optional.

#### Step 2
And you also need to implement one method in your delegate for the `UICollectionViewDelegateWaterfallLayout` protocol.

```objc
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
```

#### Step 3 (Optional)
If you need to support iOS 4.x/5.x and you have installed [PSTUICollectionView][1], then you **NEED** to modify some codes.

Quoted from [PSTUICollectionView][1] README file:
> **If you want to have PSTCollectionView on iOS4.3/5.x and UICollectionView on iOS6, use PSUICollectionView (basically add PS on any UICollectionView* class to get auto-support for older iOS versions)**
> If you always want to use PSTCollectionView, use PSTCollectionView as class names. (replace the UI with PST)

*That's all! Easy, right?*

Limitation
----------
* Only one section is supported.
* Only vertical scrolling is supported.
* No supplementary view and decoration view.

License
-------
UICollectionViewWaterfallLayout is available under the MIT license. See the LICENSE file for more info.

Known Issue
-----------
None, so far.

[1]: https://github.com/steipete/PSTCollectionView