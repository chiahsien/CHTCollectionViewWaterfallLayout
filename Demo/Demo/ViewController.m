//
//  ViewController.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "ViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

#define CELL_WIDTH 140
#define CELL_COUNT 50
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *cellHeights;
@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    self.cellWidth = CELL_WIDTH;        // Default if not setting runtime attribute
  }
  return self;
}

#pragma mark - Accessors
- (UICollectionView *)collectionView {
  if (!_collectionView) {
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];

    layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
    layout.delegate = self;

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:HEADER_IDENTIFIER];
    [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
               withReuseIdentifier:FOOTER_IDENTIFIER];
  }
  return _collectionView;
}

- (NSMutableArray *)cellHeights {
  if (!_cellHeights) {
    _cellHeights = [NSMutableArray arrayWithCapacity:CELL_COUNT];
    for (NSInteger i = 0; i < CELL_COUNT; i++) {
      _cellHeights[i] = @(arc4random() % 100 * 2 + 100);
    }
  }
  return _cellHeights;
}

#pragma mark - Life Cycle
- (void)dealloc {
  [_collectionView removeFromSuperview];
  _collectionView = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view addSubview:self.collectionView];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self updateLayout];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
  [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                          duration:duration];
  [self updateLayout];
}

- (void)updateLayout {
  CHTCollectionViewWaterfallLayout *layout =
  (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
  layout.columnCount = self.collectionView.bounds.size.width / self.cellWidth;
  layout.itemWidth = self.cellWidth;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return CELL_COUNT;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  CHTCollectionViewWaterfallCell *cell =
  (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                              forIndexPath:indexPath];
  cell.displayString = [NSString stringWithFormat:@"%d", indexPath.row];
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  UICollectionReusableView *reusableView = nil;

  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                      withReuseIdentifier:HEADER_IDENTIFIER
                                                             forIndexPath:indexPath];
  } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
    reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                      withReuseIdentifier:FOOTER_IDENTIFIER
                                                             forIndexPath:indexPath];
  }

  return reusableView;
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.cellHeights[indexPath.item] floatValue];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
  heightForHeaderInLayout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout {
  return 50;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
  heightForFooterInLayout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout {
  return 30;
}

@end
