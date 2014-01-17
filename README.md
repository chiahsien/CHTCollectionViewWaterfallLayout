CHTCollectionViewWaterfallLayout
===============================

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
Read the demo codes for detail information.

#### Step 1
There are five properties for you to set up.

``` objc
@property (nonatomic, weak) id<CHICollectionViewDelegateWaterfallLayout> delegate;
@property (nonatomic, assign) NSUInteger columnCount; // How many columns
@property (nonatomic, assign) CGFloat itemWidth; // Width for every column
@property (nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to lay out content in a section
@property (nonatomic, assign) CGFloat verticalItemSpacing; // Spacing between items vertically
```

It's your responsibility to set up `delegate`, `columnCount`, and `itemWidth`, they are required. But `sectionInset` and `verticalItemSpacing` are optional.

#### Step 2
And you also need to implement one method in your delegate for the `CHTCollectionViewDelegateWaterfallLayout` protocol.

``` objc
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
```

#### Step 3 (Optional)
If you need to support iOS 4.x/5.x and you have installed [PSTCollectionView], then you **NEED** to modify some codes.

Quoted from [PSTCollectionView] README file:
> **If you want to have PSTCollectionView on iOS4.3/5.x and UICollectionView on iOS6, use PSUICollectionView (basically add PS on any UICollectionView* class to get auto-support for older iOS versions)**
> If you always want to use PSTCollectionView, use PSTCollectionView as class names. (replace the UI with PST)

*That's all! Easy, right?*

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
