//
//  UICollectionViewWaterfallLayout.m
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import "CHTCollectionViewWaterfallLayout.h"

@interface CHTCollectionViewWaterfallLayout ()
@property (nonatomic, strong) NSMutableArray *sectionItemCount;
@property (nonatomic, strong) NSMutableArray *columnHeights; // height for each column
@property (nonatomic, strong) NSMutableArray *sectionItemAttributes; // attributes for each item
@property (nonatomic, strong) NSMutableArray *itemAttributes; // attributes for each item
@property (nonatomic, strong) NSMutableArray *headersAttributes;
@property (nonatomic, strong) NSMutableArray *footersAttributes;
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
  
  [_sectionItemAttributes removeAllObjects];
  _sectionItemAttributes = nil;
}

#pragma mark - Methods to Override
- (void)prepareLayout {
  [super prepareLayout];
  
  NSInteger idx = 0;
  if ([self.collectionView numberOfSections] == 0) {
    return ;
  }
  
  NSAssert(_columnCount > 0, @"columnCount for UICollectionViewWaterfallLayout should be greater than 0.");
  
  NSUInteger numberOfSections = [self.collectionView numberOfSections];
  
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
  
  _sectionItemCount = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
  
  _headersAttributes = nil;
  if ([self.delegate respondsToSelector:@selector(collectionView:heightForHeaderInSection:)]) {
    _headersAttributes = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
  }
  
  _unionRects = [NSMutableArray array];
  
  _footersAttributes = nil;
  if ([self.delegate respondsToSelector:@selector(collectionView:heightForFooterInSection:)]) {
    _footersAttributes = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
  }
  
  _columnHeights = [NSMutableArray arrayWithCapacity:_columnCount];
  
  _itemAttributes = [[NSMutableArray alloc] init];
  
  for (idx = 0; idx < _columnCount; idx++) {
    [_columnHeights addObject:@(0)];
  }
  
  CGFloat sectionStart = _sectionInset.top;
  for (NSUInteger section = 0; section < numberOfSections; ++section) {
    NSUInteger itemCount = [self.collectionView numberOfItemsInSection:section];
    [_sectionItemCount addObject:@(itemCount)];
    _interItemSpacingX = interItemSpacingX;
    _interItemSpacingY = interItemSpacingY;
    
    if (itemCount == 0 && self.hideEmptySections) {
      if ([self.delegate respondsToSelector:@selector(collectionView:heightForHeaderInSection:)]) {
        UICollectionViewLayoutAttributes *headerAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                       withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        headerAttributes.frame = CGRectMake(_sectionInset.left, sectionStart, width, 0);
        headerAttributes.alpha = 0;
        [_headersAttributes addObject:headerAttributes];
      }
      
      [_sectionItemAttributes addObject:@[]];
      
      if ([self.delegate respondsToSelector:@selector(collectionView:heightForFooterInSection:)]) {
        UICollectionViewLayoutAttributes *footerAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                       withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        footerAttributes.frame = CGRectMake(_sectionInset.left, sectionStart, width, 0);
        footerAttributes.alpha = 0;
        [_footersAttributes addObject:footerAttributes];
      }
      
      continue;
    }
    
    UICollectionViewLayoutAttributes *headerAttributes;
    if ([self.delegate respondsToSelector:@selector(collectionView:heightForHeaderInSection:)]) {
      CGFloat headerHeight = [self.delegate collectionView:self.collectionView
                                  heightForHeaderInSection:section];
      
      headerAttributes =
      [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                     withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
      headerAttributes.frame = CGRectMake(_sectionInset.left, sectionStart, width, headerHeight);
      [_headersAttributes addObject:headerAttributes];
    }
    for (idx = 0; idx < _columnCount; idx++) {
      _columnHeights[idx] = @(MAX(sectionStart, CGRectGetMaxY(headerAttributes.frame) + interItemSpacingY));
    }
    
    NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    // Item will be put into shortest column.
    for (idx = 0; idx < itemCount; idx++) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
      CGFloat itemHeight = [self.delegate collectionView:self.collectionView
                                                  layout:self
                                heightForItemAtIndexPath:indexPath];
      NSUInteger columnIndex = [self shortestColumnIndex];
      CGFloat xOffset = _sectionInset.left + (_itemWidth + interItemSpacingX) * columnIndex;
      CGFloat yOffset = [(_columnHeights[columnIndex]) floatValue];
      
      UICollectionViewLayoutAttributes *attributes =
      [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
      attributes.frame = CGRectMake(xOffset, yOffset, self.itemWidth, itemHeight);
      [itemAttributes addObject:attributes];
      _columnHeights[columnIndex] = @(yOffset + itemHeight + interItemSpacingY);
      
      [_itemAttributes addObject:attributes];
    }
    
    [_sectionItemAttributes addObject:itemAttributes];
    
    NSUInteger columnIndex = [self longestColumnIndex];
    CGFloat yOffset = [self.columnHeights[columnIndex] floatValue];
    sectionStart = yOffset;
    
    if ([self.delegate respondsToSelector:@selector(collectionView:heightForFooterInSection:)]) {
      CGFloat footerHeight = [self.delegate collectionView:self.collectionView
                                  heightForFooterInSection:section];
      UICollectionViewLayoutAttributes *footerAttributes =
      [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                     withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
      footerAttributes.frame = CGRectMake(_sectionInset.left, yOffset, width, footerHeight);
      sectionStart += footerHeight;
      
      [_footersAttributes addObject:footerAttributes];
    }
    sectionStart += _sectionInset.bottom;
  }
  
  idx = 0;
  while (idx < [_itemAttributes count]) {
    CGRect rect1 = ((UICollectionViewLayoutAttributes *)_itemAttributes[idx]).frame;
    idx = MIN(idx + unionSize, [_itemAttributes count]) - 1;
    CGRect rect2 = ((UICollectionViewLayoutAttributes *)_itemAttributes[idx]).frame;
    [_unionRects addObject:[NSValue valueWithCGRect:CGRectUnion(rect1, rect2)]];
    idx++;
  }
}

- (CGSize)collectionViewContentSize {
  NSUInteger numberOfSections = [self.collectionView numberOfSections];
  if (numberOfSections == 0) {
    return CGSizeZero;
  }
  
  CGSize contentSize = self.collectionView.frame.size;
  NSUInteger columnIndex = [self longestColumnIndex];
  CGFloat height = [self.columnHeights[columnIndex] floatValue];
  contentSize.height = height - self.interItemSpacingY + self.sectionInset.bottom;
  
  if (self.footersAttributes) {
    contentSize.height = CGRectGetMaxY(((UICollectionViewLayoutAttributes *)self.footersAttributes[numberOfSections - 1]).frame);
  }
  
  return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
  NSUInteger numberOfSections = [self.sectionItemAttributes count];
  if (path.item != NSNotFound && path.section >= 0 && path.section < numberOfSections && path.item >= 0 && path.item < [self.sectionItemAttributes[numberOfSections - 1] count]) {
    return (self.sectionItemAttributes)[path.section][path.item];
  }
  return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    return _headersAttributes[indexPath.section];
  } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
    return _footersAttributes[indexPath.section];
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
  
  NSUInteger numberOfSections = [self.collectionView numberOfSections];
  
  if (_headersAttributes) {
    for (i = 0; i < numberOfSections; ++i) {
      if (CGRectIntersectsRect(rect, [_headersAttributes[i] frame])) {
        [attrs addObject:_headersAttributes[i]];
      }
    }
  }
  
  if (_footersAttributes) {
    for (i = 0; i < numberOfSections; ++i) {
      if (CGRectIntersectsRect(rect, [_footersAttributes[i] frame])) {
        [attrs addObject:_footersAttributes[i]];
      }
    }
  }
  
  return [attrs copy];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return NO;
}

#pragma mark - Private Methods

// Find the shortest column.
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

// Find the longest column.
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
