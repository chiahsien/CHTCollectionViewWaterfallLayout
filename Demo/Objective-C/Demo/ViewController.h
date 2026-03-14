//
//  ViewController.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_feature(modules)
@import CHTCollectionViewWaterfallLayoutObjC;
#else
#import "CHTCollectionViewWaterfallLayout.h"
#endif

@interface ViewController : UIViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
