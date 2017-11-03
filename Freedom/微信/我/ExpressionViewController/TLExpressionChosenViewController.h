//
//  TLExpressionChosenViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/4/4.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLTableViewController.h"
#import "TLExpressionHelper.h"
#import "TLExpressionProxy.h"
#import "TLExpressionCell.h"

#define         HEIGHT_BANNERCELL       140.0f
#define         HEGIHT_EXPCELL          80.0f
@protocol TLExpressionBannerCellDelegate <NSObject>

- (void)expressionBannerCellDidSelectBanner:(id)item;

@end

@interface TLExpressionBannerCell : TLTableViewCell

@property (nonatomic, assign) id<TLExpressionBannerCellDelegate>delegate;

@property (nonatomic, strong) NSArray *data;

@end
@interface TLExpressionChosenViewController : TLTableViewController<TLExpressionCellDelegate, TLExpressionBannerCellDelegate>{
    NSInteger kPageIndex;
}
- (void)registerCellsForTableView:(UITableView *)tableView;

- (void)loadDataWithLoadingView:(BOOL)showLoadingView;

- (void)loadMoreData;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSArray *bannerData;

@property (nonatomic, strong) TLExpressionProxy *proxy;


@end
