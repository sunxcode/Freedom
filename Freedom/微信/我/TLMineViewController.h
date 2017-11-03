//
//  TLMineViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/1/23.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLMenuViewController.h"
#import "TLUser.h"
@interface TLMineInfoHelper : NSObject

- (NSMutableArray *)mineInfoDataByUserInfo:(TLUser *)userInfo;

@end

@interface TLMineViewController : TLMenuViewController

@end
