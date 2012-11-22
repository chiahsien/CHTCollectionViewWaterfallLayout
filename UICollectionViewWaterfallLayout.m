//
//  UICollectionViewWaterfallLayout.m
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import "UICollectionViewWaterfallLayout.h"

@interface UICollectionViewWaterfallLayout()
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, strong) NSMutableArray *columnHeights; // height for each column
@property (nonatomic, strong) NSMutableArray *itemPositions; // position for each item
@end

@implementation UICollectionViewWaterfallLayout

#pragma mark - Init
- (void)commonInit
{
    _columnCount = 2;
    _itemWidth = 140.0f;
    _sectionInset = UIEdgeInsetsZero;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Life cycle
- (void)dealloc
{
    [_columnHeights removeAllObjects];
    _columnHeights = nil;

    [_itemPositions removeAllObjects];
    _itemPositions = nil;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];

    _itemCount = [[self collectionView] numberOfItemsInSection:0];

    NSAssert(_columnCount > 1, @"columnCount for UICollectionViewWaterfallLayout should be greater than 1.");
    CGFloat width = self.collectionView.frame.size.width - _sectionInset.left - _sectionInset.right;
    _interitemSpacing = floorf((width - _columnCount * _itemWidth) / (_columnCount - 1));

    _itemPositions = [NSMutableArray arrayWithCapacity:_itemCount];
    _columnHeights = [NSMutableArray arrayWithCapacity:_columnCount];
    for (NSInteger idx = 0; idx < _columnCount; idx++) {
        [_columnHeights addObject:@(_sectionInset.top)];
    }

    // Item will be put into shortest column.
    for (NSInteger idx = 0; idx < _itemCount; idx++) {
        CGFloat itemHeight = [self.delegate collectionView:self.collectionView
                                                    layout:self
                                  heightForItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        NSUInteger columnIndex = [self shortestColumnIndex];
        CGFloat xOffset = _sectionInset.left + (_itemWidth + _interitemSpacing) * columnIndex;
        CGFloat yOffset = [(_columnHeights[columnIndex]) floatValue];
        CGPoint itemCenter = CGPointMake(floorf(xOffset + _itemWidth/2), floorf((yOffset + itemHeight/2)));

        [_itemPositions addObject:[NSValue valueWithCGPoint:itemCenter]];
        _columnHeights[columnIndex] = @(yOffset + itemHeight + _interitemSpacing);
    }
}

- (CGSize)collectionViewContentSize
{
    if (self.itemCount == 0) {
        return CGSizeZero;
    }

    CGSize contentSize = self.collectionView.frame.size;
    NSUInteger columnIndex = [self longestColumnIndex];
    CGFloat height = [self.columnHeights[columnIndex] floatValue];
    contentSize.height = height - self.interitemSpacing + self.sectionInset.bottom;
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes *attributes =
    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    CGFloat itemHeight = [self.delegate collectionView:self.collectionView
                                                layout:self
                              heightForItemAtIndexPath:path];
    attributes.size = CGSizeMake(self.itemWidth, itemHeight);
    attributes.center = [self.itemPositions[path.item] CGPointValue];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSInteger i = 0; i < self.itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

#pragma mark - Private Methods
// Find out shortest column.
- (NSUInteger)shortestColumnIndex
{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;

    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];

    return index;
}

// Find out longest column.
- (NSUInteger)longestColumnIndex
{
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;

    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];

    return index;
}

@end
