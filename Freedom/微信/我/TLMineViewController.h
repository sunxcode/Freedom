//  TLMineViewController.h
//  Freedom
// Created by Super
#import "WechatMenuViewController.h"
#import "TLUserHelper.h"
@interface TLMineInfoHelper : NSObject
- (NSMutableArray *)mineInfoDataByUserInfo:(TLUser *)userInfo;
@end
@interface TLMineViewController : WechatMenuViewController
@end
