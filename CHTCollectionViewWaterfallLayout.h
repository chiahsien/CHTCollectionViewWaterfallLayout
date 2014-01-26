//
//  UICollectionViewWaterfallLayout.h
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTCollectionViewWaterfallLayout;

@protocol CHTCollectionViewWaterfallLayoutDelegate <NSObject>
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView
 heightForHeaderInSection:(NSUInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView
 heightForFooterInSection:(NSUInteger)section;
@end

@interface CHTCollectionViewWaterfallLayout : UICollectionViewLayout
@property (nonatomic, weak) IBOutlet id<CHTCollectionViewWaterfallLayoutDelegate> delegate;
@property (nonatomic, assign) NSUInteger columnCount; // How many columns
@property (nonatomic, assign) CGFloat itemWidth; // Width for every column
@property (nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to lay out content in a section
@property (nonatomic, assign) CGFloat verticalItemSpacing; // Spacing between items vertically
@property (nonatomic, assign) BOOL hideEmptySections; // Hiding headers and footers for emty sections
@end
