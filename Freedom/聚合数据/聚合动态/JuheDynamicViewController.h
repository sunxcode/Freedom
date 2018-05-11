//  JuheDynamicViewController.h
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface JuheDynamicViewController : BaseOCViewController{
    NSMutableArray *dataArray;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@end
