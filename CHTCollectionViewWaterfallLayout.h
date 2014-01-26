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
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForHeaderInSection:(NSInteger)section;
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
