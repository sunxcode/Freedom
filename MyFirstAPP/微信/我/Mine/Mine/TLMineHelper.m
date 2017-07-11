//
//  TLMineHelper.m
//  TLChat
//
//  Created by 李伯坤 on 16/2/6.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLMineHelper.h"
#import "TLMenuItem.h"

@implementation TLMineHelper

- (id) init
{
    if (self = [super init]) {
        self.mineMenuData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}


- (void) p_initTestData
{
    TLMenuItem *item0 = TLCreateMenuItem(nil, nil);
    TLMenuItem *item1 = TLCreateMenuItem(@"MoreMyAlbum", @"相册");
    TLMenuItem *item2 = TLCreateMenuItem(@"MoreMyFavorites", @"收藏");
    TLMenuItem *item3 = TLCreateMenuItem(@"MoreMyBankCard", @"钱包");
    TLMenuItem *item4 = TLCreateMenuItem(@"MyCardPackageIcon@2x", @"优惠券");
    TLMenuItem *item5 = TLCreateMenuItem(@"MoreExpressionShops@2x", @"表情");
    TLMenuItem *item6 = TLCreateMenuItem(@"MoreSetting@2x", @"设置");
    [self.mineMenuData addObjectsFromArray:@[@[item0], @[item1, item2, item3, item4], @[item5], @[item6]]];
}

@end
