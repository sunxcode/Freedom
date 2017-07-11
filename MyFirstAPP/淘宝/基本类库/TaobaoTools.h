//
//  TaobaoTools.h
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/25.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaobaoTools : NSObject
/**
 *  字符串转Date
 *
 *  @param str 'yyyy-MM-dd HH:mm:ss'
 *
 *  @return NSDate
 */
+ (NSDate *)strToDate:(NSString *)str;
/**
 *  <#Description#>
 *
 *  @param time <#time description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getMinuteSecondWithSecond:(NSTimeInterval)time;
/**
 *  <#Description#>
 *
 *  @param imageName <#imageName description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithOriginalName:(NSString *)imageName;
/**
 *  <#Description#>
 *
 *  @param imageName <#imageName description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithStretchableName:(NSString *)imageName;
/**
 *  正则判断字符串是否是中文
 *
 *  @param str
 *  @return BOOL
 */
+ (BOOL)isChinese:(NSString *)str;

+ (void)show:(nullable NSString *)msg;
@end
