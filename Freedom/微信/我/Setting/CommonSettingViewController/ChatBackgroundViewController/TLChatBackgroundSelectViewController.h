//
//  TLChatBackgroundSelectViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/4/2.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLChatBackgroundSelectViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (void)registerCellForCollectionView:(UICollectionView *)collectionView;


@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) UICollectionView *collectionView;

@end
