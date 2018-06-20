//  TLCommonSettingViewController.h
//  Freedom
// Created by Super
#import "WechatSettingViewController.h"
@interface TLCommonSettingHelper : NSObject
@property (nonatomic, strong) NSMutableArray *commonSettingData;
+ (NSMutableArray *)chatBackgroundSettingData;
@end
@interface TLCommonSettingViewController : WechatSettingViewController
@end
