UIWaterfallLayout
=================

iOS 6 introduced a new feature called [UICollectionView](http://developer.apple.com/library/ios/#documentation/uikit/reference/UICollectionView_class/Reference/Reference.html). **UIWaterfallLayout** is a subclass of [UICollectionViewLayout](http://developer.apple.com/library/ios/#documentation/uikit/reference/UICollectionViewLayout_class/Reference/Reference.html).

This layout is inspired by [Pinterest](http://pinterest.com/). It also is compatible with [PSTUICollectionView](https://github.com/steipete/PSTCollectionView).

Prerequisite
------------
* ARC
* iOS 6+, or
* iOS 5 and below, with [PSTUICollectionView](https://github.com/steipete/PSTCollectionView).

How to Use
----------
#### Step 1
There are four properties for you to set up.

    @property (nonatomic, weak) id<UICollecitonViewDelegateWaterfallLayout> delegate;
    @property (nonatomic, assign) NSUInteger columnCount; // How many columns
    @property (nonatomic, assign) CGFloat itemWidth; // Width for every column
    @property (nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to lay out content in a section

It's your responsibility to set up `delegate`, `columnCount`, and `itemWidth`, they are required. But `sectionInset` is optional.

#### Step 2
And you also need to implement a method for the `UICollecitonViewDelegateWaterfallLayout` protocol.

    - (CGFloat)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
     heightForItemAtIndexPath:(NSIndexPath *)indexPath;

Then you are done! Easy, right?

Screen Shots
------------
![2 columns](https://raw.github.com/chiahsien/UICollectionViewWaterfallLayout/master/Screenshots/2-columns.png)
![3 columns](https://raw.github.com/chiahsien/UICollectionViewWaterfallLayout/master/Screenshots/3-columns.png)

Known Issue
-----------
None, so far.