//
//  TaobaoTools.h
//  Created by 薛超 on 16/8/25.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaobaoTools : NSObject
+ (NSDate *_Nullable)strToDate:(NSString *)str;
+ (NSString *)getMinuteSecondWithSecond:(NSTimeInterval)time;
+ (UIImage *)imageWithOriginalName:(NSString *)imageName;
+ (UIImage *)imageWithStretchableName:(NSString *)imageName;
/// 正则判断字符串是否是中文
+ (BOOL)isChinese:(NSString *)str;
+ (void)show:(nullable NSString *)msg;
@end
