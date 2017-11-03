//
//  TLUserHelper.m
//  TLChat
//
//  Created by 李伯坤 on 16/2/6.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLUserHelper.h"

static TLUserHelper *helper;

@implementation TLUserHelper

+ (TLUserHelper *) sharedHelper
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[TLUserHelper alloc] init];
    });
    return helper;
}

- (NSString *)userID
{
    return self.user.userID;
}

- (id) init
{
    if (self = [super init]) {
        self.user = [[TLUser alloc] init];
        self.user.userID = @"这是我的二维码：2829969299 \n没错，我爱周芳园。";//我的二维码数据
        self.user.avatarURL = @"https://p1.ssl.qhmsg.com/dm/110_110_100/t01fffa4efd00af1898.jpg";
        self.user.nikeName = @"薛超";
        self.user.username = @"2829969299";
        self.user.detailInfo.qqNumber = @"2829969299";
        self.user.detailInfo.email = @"2829969299@qq.com";
        self.user.detailInfo.location = @"上海市 浦东新区";
        self.user.detailInfo.sex = @"男";
        self.user.detailInfo.motto = @"失败与挫折相伴，成功与掌声共存!";
        self.user.detailInfo.momentsWallURL = @"https://p1.ssl.qhmsg.com/dm/110_110_100/t01fffa4efd00af1898.jpg";
    }
    return self;
}

@end
