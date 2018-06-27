//  FreedomTools.h
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface FreedomTools : NSObject
+(FreedomTools *)sharedManager;
/// 正则判断字符串是否是中文
+ (BOOL)isChinese:(NSString *)str;
+ (void)show:(NSString *)msg;
@end
