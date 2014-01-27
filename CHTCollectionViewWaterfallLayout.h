//
//  UICollectionViewWaterfallLayout.h
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Constants

extern NSString *const CHTCollectionElementKindSectionHeader;
extern NSString *const CHTCollectionElementKindSectionFooter;

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

@class CHTCollectionViewWaterfallLayout;

@protocol CHTCollectionViewDelegateWaterfallLayout <UICollectionViewDelegate>
@required
/**
 *  Asks the delegate for the height of the specified item’s cell.
 *
 *  @param collectionView
 *    The collection view object displaying the waterfall layout.
 *  @param collectionViewLayout
 *    The layout object requesting the information.
 *  @param indexPath
 *    The index path of the item.
 *
 *  @return
 *    The height of the specified item. Must be greater than 0.
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/**
 *  Asks the delegate for the height of the header view in the specified section.
 *
 *  @param collectionView
 *    The collection view object displaying the waterfall layout.
 *  @param collectionViewLayout
 *    The layout object requesting the information.
 *  @param section
 *    The index of the section whose header size is being requested.
 *
 *  @return
 *    The height of the header. If you return 0, no header is added.
 *
 *  @discussion
 *    If you do not implement this method, the waterfall layout uses the value in its headerHeight property to set the size of the header.
 *
 *  @see
 *    headerHeight
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForHeaderInSection:(NSInteger)section;

/**
 *  Asks the delegate for the height of the footer view in the specified section.
 *
 *  @param collectionView
 *    The collection view object displaying the waterfall layout.
 *  @param collectionViewLayout
 *    The layout object requesting the information.
 *  @param section
 *    The index of the section whose header size is being requested.
 *
 *  @return
 *    The height of the footer. If you return 0, no footer is added.
 *
 *  @discussion
 *    If you do not implement this method, the waterfall layout uses the value in its footerHeight property to set the size of the header.
 *
 *  @see
 *    footerHeight
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForFooterInSection:(NSInteger)section;
@end

#pragma mark - CHTCollectionViewWaterfallLayout

@interface CHTCollectionViewWaterfallLayout : UICollectionViewLayout
/**
 *  @brief How many columns for this layout.
 *  @discussion Default: 2
 */
@property (nonatomic, assign) NSInteger columnCount;

/**
 *  @brief Width for each item.
 *  @discussion Default: 140
 */
@property (nonatomic, assign) CGFloat itemWidth;

/**
 *  @brief Height for section header
 *  @discussion
 *    If your collectionView's delegate doesn't implement `collectionView:layout:heightForHeaderInSection:`,
 *    then this value will be used.
 *    Default: 0
 */
@property (nonatomic, assign) CGFloat headerHeight;

/**
 *  @brief Height for section footer
 *  @discussion
 *    If your collectionView's delegate doesn't implement `collectionView:layout:heightForFooterInSection:`,
 *    then this value will be used.
 *    Default: 0
 */
@property (nonatomic, assign) CGFloat footerHeight;

/**
 *  @brief The margins that are used to lay out content in each section.
 *  @discussion Default: UIEdgeInsetsZero
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/**
 *  @brief Spacing between items vertically.
 *  @discussion It will be calculated automatically if you don't assign a value.
 */
@property (nonatomic, assign) CGFloat verticalItemSpacing;
@end
