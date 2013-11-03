//
//  UICollectionViewWaterfallLayout.m
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import "CHTCollectionViewWaterfallLayout.h"

@interface CHTCollectionViewWaterfallLayout ()
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, strong) NSMutableArray *columnHeights; // height for each column
@property (nonatomic, strong) NSMutableArray *itemAttributes; // attributes for each item
@property (nonatomic, strong) UICollectionViewLayoutAttributes *headerAttributes;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *footerAttributes;
@property (nonatomic, strong) NSMutableArray *unionRects;
@end

@implementation CHTCollectionViewWaterfallLayout

const int unionSize = 20;

#pragma mark - Accessors
- (void)setColumnCount:(NSUInteger)columnCount {
  if (_columnCount != columnCount) {
    _columnCount = columnCount;
    [self invalidateLayout];
  }
}

- (void)setItemWidth:(CGFloat)itemWidth {
  if (_itemWidth != itemWidth) {
    _itemWidth = itemWidth;
    [self invalidateLayout];
  }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
  if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
    _sectionInset = sectionInset;
    [self invalidateLayout];
  }
}

#pragma mark - Init
- (void)commonInit {
  _columnCount = 2;
  _itemWidth = 140.0f;
  _sectionInset = UIEdgeInsetsZero;
}

- (id)init {
  self = [super init];
  if (self) {
    [self commonInit];
  }
  return self;
}

#pragma mark - Life cycle
- (void)dealloc {
  [_columnHeights removeAllObjects];
  _columnHeights = nil;

  [_itemAttributes removeAllObjects];
  _itemAttributes = nil;
}

#pragma mark - Methods to Override
- (void)prepareLayout {
  [super prepareLayout];

  NSInteger idx = 0;
  _itemCount = [self.collectionView numberOfItemsInSection:0];

  NSAssert(_columnCount > 1, @"columnCount for UICollectionViewWaterfallLayout should be greater than 1.");
  CGFloat width = self.collectionView.frame.size.width - _sectionInset.left - _sectionInset.right;

  _headerAttributes = nil;
  if ([self.delegate respondsToSelector:@selector(collectionView:heightForHeaderInLayout:)]) {
    CGFloat headerHeight = [self.delegate collectionView:self.collectionView
                                 heightForHeaderInLayout:self];

    _headerAttributes =
    [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                   withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    _headerAttributes.frame = CGRectMake(_sectionInset.left, 0, width, headerHeight);
  }

  _interitemSpacing = floorf((width - _columnCount * _itemWidth) / (_columnCount - 1));

  _itemAttributes = [NSMutableArray arrayWithCapacity:_itemCount];
  _columnHeights = [NSMutableArray arrayWithCapacity:_columnCount];
  for (idx = 0; idx < _columnCount; idx++) {
    [_columnHeights addObject:@(_sectionInset.top + CGRectGetMaxY(_headerAttributes.frame))];
  }

  // Item will be put into shortest column.
  for (idx = 0; idx < _itemCount; idx++) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
    CGFloat itemHeight = [self.delegate collectionView:self.collectionView
                                                layout:self
                              heightForItemAtIndexPath:indexPath];
    NSUInteger columnIndex = [self shortestColumnIndex];
    CGFloat xOffset = _sectionInset.left + (_itemWidth + _interitemSpacing) * columnIndex;
    CGFloat yOffset = [(_columnHeights[columnIndex]) floatValue];

    UICollectionViewLayoutAttributes *attributes =
    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(xOffset, yOffset, self.itemWidth, itemHeight);
    [_itemAttributes addObject:attributes];
    _columnHeights[columnIndex] = @(yOffset + itemHeight + _interitemSpacing);
  }

  idx = 0;
  _unionRects = [NSMutableArray array];
  while (idx < _itemCount) {
    CGRect rect1 = ((UICollectionViewLayoutAttributes *)_itemAttributes[idx]).frame;
    idx = MIN(idx + unionSize, _itemCount) - 1;
    CGRect rect2 = ((UICollectionViewLayoutAttributes *)_itemAttributes[idx]).frame;
    [_unionRects addObject:[NSValue valueWithCGRect:CGRectUnion(rect1, rect2)]];
    idx++;
  }

  _footerAttributes = nil;
  if ([self.delegate respondsToSelector:@selector(collectionView:heightForFooterInLayout:)]) {
    CGFloat footerHeight = [self.delegate collectionView:self.collectionView
                                 heightForFooterInLayout:self];
    _footerAttributes =
    [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                   withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    NSUInteger columnIndex = [self longestColumnIndex];
    CGFloat yOffset = [self.columnHeights[columnIndex] floatValue] - _interitemSpacing + _sectionInset.bottom;
    _footerAttributes.frame = CGRectMake(_sectionInset.left, yOffset, width, footerHeight);
  }
}

- (CGSize)collectionViewContentSize {
  if (self.itemCount == 0) {
    return CGSizeZero;
  }

  CGSize contentSize = self.collectionView.frame.size;
  NSUInteger columnIndex = [self longestColumnIndex];
  CGFloat height = [self.columnHeights[columnIndex] floatValue];
  contentSize.height = height - self.interitemSpacing + self.sectionInset.bottom;

  if (self.footerAttributes) {
    contentSize.height = CGRectGetMaxY(self.footerAttributes.frame);
  }

  return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
  return (self.itemAttributes)[path.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    return _headerAttributes;
  } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
    return _footerAttributes;
  }
  return nil;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSInteger i;
  NSInteger begin = 0, end = self.unionRects.count;
  NSMutableArray *attrs = [NSMutableArray array];

  for (i = 0; i < self.unionRects.count; i++) {
    if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
      begin = i * unionSize;
      break;
    }
  }
  for (i = self.unionRects.count - 1; i >= 0; i--) {
    if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
      end = MIN((i + 1) * unionSize, self.itemAttributes.count);
      break;
    }
  }
  for (i = begin; i < end; i++) {
    UICollectionViewLayoutAttributes *attr = self.itemAttributes[i];
    if (CGRectIntersectsRect(rect, attr.frame)) {
      [attrs addObject:attr];
    }
  }

  if (_headerAttributes && CGRectIntersectsRect(rect, [_headerAttributes frame])) {
    [attrs addObject:_headerAttributes];
  }

  if (_footerAttributes && CGRectIntersectsRect(rect, [_footerAttributes frame])) {
    [attrs addObject:_footerAttributes];
  }

  return [attrs copy];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return NO;
}

#pragma mark - Private Methods

// Find out shortest column.
- (NSUInteger)shortestColumnIndex {
  __block NSUInteger index = 0;
  __block CGFloat shortestHeight = MAXFLOAT;

  [self.columnHeights enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
    CGFloat height = [obj floatValue];
    if (height < shortestHeight) {
      shortestHeight = height;
      index = idx;
    }
  }];

  return index;
}

// Find out longest column.
- (NSUInteger)longestColumnIndex {
  __block NSUInteger index = 0;
  __block CGFloat longestHeight = 0;

  [self.columnHeights enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
    CGFloat height = [obj floatValue];
    if (height > longestHeight) {
      longestHeight = height;
      index = idx;
    }
  }];

  return index;
}

@end
