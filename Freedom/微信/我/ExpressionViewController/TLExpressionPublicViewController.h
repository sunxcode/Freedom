//
//  TLExpressionPublicViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/4/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLViewController.h"
#import "TLExpressionProxy.h"

@interface TLExpressionPublicViewController : TLViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


{
    NSInteger kPageIndex;
}
- (void)registerCellForCollectionView:(UICollectionView *)collectionView;

- (void)loadDataWithLoadingView:(BOOL)showLoadingView;

- (void)loadMoreData;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) TLExpressionProxy *proxy;

@property (nonatomic, strong) UICollectionView *collectionView;

@end
