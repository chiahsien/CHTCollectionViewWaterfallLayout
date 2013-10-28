//
//  UICollectionViewWaterfallLayout.h
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTCollectionViewWaterfallLayout;
@protocol CHTCollectionViewDelegateWaterfallLayout <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView
  heightForHeaderInLayout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout;
- (CGFloat)collectionView:(UICollectionView *)collectionView
  heightForFooterInLayout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout;
@end

@interface CHTCollectionViewWaterfallLayout : UICollectionViewLayout
@property (nonatomic, weak) IBOutlet id<CHTCollectionViewDelegateWaterfallLayout> delegate;
@property (nonatomic, assign) NSUInteger columnCount; // How many columns
@property (nonatomic, assign) CGFloat itemWidth; // Width for every column
@property (nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to lay out content in a section
@end
