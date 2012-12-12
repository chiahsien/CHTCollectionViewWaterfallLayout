//
//  ViewController.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "ViewController.h"
#import "UICollectionViewWaterfallCell.h"

#define CELL_WIDTH 129
#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"

@interface ViewController()
@property (nonatomic, strong) NSMutableArray *cellHeights;
@end

@implementation ViewController

#pragma mark - Accessors
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
        layout.itemWidth = CELL_WIDTH;
        layout.columnCount = self.view.bounds.size.width / CELL_WIDTH;
        layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
        layout.delegate = self;

        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[UICollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

- (NSMutableArray *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray arrayWithCapacity:CELL_COUNT];
        for (NSInteger i = 0; i < CELL_COUNT; i++) {
            _cellHeights[i] = @(arc4random()%100*2+100);
        }
    }
    return _cellHeights;
}

#pragma mark - Life Cycle
- (void)dealloc
{
    [_collectionView removeFromSuperview];
    _collectionView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UICollectionViewWaterfallLayout *layout =
    (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = self.collectionView.bounds.size.width / CELL_WIDTH;
    layout.itemWidth = CELL_WIDTH;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return CELL_COUNT;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewWaterfallCell *cell =
    (UICollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                               forIndexPath:indexPath];

    cell.displayString = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellHeights[indexPath.item] floatValue];
}

@end
