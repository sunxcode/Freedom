//
//  NSString+DZ.h
//  Shop
//
//  Created by dengwei on 15/11/28.
//  Copyright (c) 2015年 dengw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DZ)

/**
 *  拼接文件名
 *
 */
-(NSString *)fileAppend:(NSString *)append;

/**
 *  生成一个保留decimalsCount位小数的字符串（裁减多余的0）
 *
 *  @param value         需要转成字符串的数
 *  @param decimalsCount 需要保留小数的位数
 *
 *  @return 保留decimalsCount位小数的字符串
 */
+(NSString *)stringWithDouble:(double)value decimalsCount:(int)decimalsCount;

@end
