//
//  UICollectionViewWaterfallLayout.m
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import "CHTCollectionViewWaterfallLayout.h"

@interface CHTCollectionViewWaterfallLayout ()
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSMutableArray *columnHeights; // height for each column
@property (nonatomic, strong) NSMutableArray *itemAttributes; // attributes for each item
@property (nonatomic, strong) UICollectionViewLayoutAttributes *headerAttributes;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *footerAttributes;
@property (nonatomic, strong) NSMutableArray *unionRects;
@property (nonatomic, assign) CGFloat interItemSpacingX;
@property (nonatomic, assign) CGFloat interItemSpacingY;
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

- (void)setVerticalItemSpacing:(CGFloat)verticalItemSpacing
{
  if (_verticalItemSpacing != verticalItemSpacing) {
    _verticalItemSpacing = verticalItemSpacing;
    [self invalidateLayout];
  }
}

- (CGFloat)interItemSpacingY
{
  if (_interItemSpacingY == 0.0f) {
    return _verticalItemSpacing;
  }
  return _interItemSpacingY;
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

  NSAssert(_columnCount > 0, @"columnCount for UICollectionViewWaterfallLayout should be greater than 0.");

  CGFloat width = self.collectionView.frame.size.width - _sectionInset.left - _sectionInset.right;
  CGFloat interItemSpacingX = 0.0f;
  CGFloat interItemSpacingY = 0.0f;
  if (_columnCount > 1) {
    interItemSpacingX = floorf((width - _columnCount * _itemWidth) / (_columnCount - 1));
  }
  if (_verticalItemSpacing > 0.0f) {
    interItemSpacingY = _verticalItemSpacing;
  }
  else {
    interItemSpacingY = interItemSpacingX;
  }
  _interItemSpacingX = interItemSpacingX;
  _interItemSpacingY = interItemSpacingY;

  _headerAttributes = nil;
  if ([self.delegate respondsToSelector:@selector(collectionView:heightForHeaderInLayout:)]) {
    CGFloat headerHeight = [self.delegate collectionView:self.collectionView
                                 heightForHeaderInLayout:self];

    _headerAttributes =
    [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                   withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    _headerAttributes.frame = CGRectMake(_sectionInset.left, 0, width, headerHeight);
  }

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
    CGFloat xOffset = _sectionInset.left + (_itemWidth + interItemSpacingX) * columnIndex;
    CGFloat yOffset = [(_columnHeights[columnIndex]) floatValue];

    UICollectionViewLayoutAttributes *attributes =
    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(xOffset, yOffset, self.itemWidth, itemHeight);
    [_itemAttributes addObject:attributes];
    _columnHeights[columnIndex] = @(yOffset + itemHeight + interItemSpacingY);
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
    CGFloat yOffset = [self.columnHeights[columnIndex] floatValue] - interItemSpacingY + _sectionInset.bottom;
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
  contentSize.height = height - self.interItemSpacingY + self.sectionInset.bottom;

  if (self.footerAttributes) {
    contentSize.height = CGRectGetMaxY(self.footerAttributes.frame);
  }

  return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
  if (path.item != NSNotFound && path.item >= 0 && path.item < self.itemAttributes.count) {
    return (self.itemAttributes)[path.item];
  }
  return nil;
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
