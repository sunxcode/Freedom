//
//  NSString+DZ.m
//  Shop
//
//  Created by dengwei on 15/11/28.
//  Copyright (c) 2015年 dengw. All rights reserved.
//

#import "NSString+DZ.h"

@implementation NSString (DZ)

-(NSString *)fileAppend:(NSString *)append
{
    //1.1获得文件扩展名
    NSString *ext = [self pathExtension];
    //1.2删除最后面的扩展名
    NSString *imageName = [self stringByDeletingPathExtension];
    
    //1.3拼接append
    imageName = [imageName stringByAppendingString:append];
    
    //1.4拼接扩展名
    imageName = [imageName stringByAppendingPathExtension:ext];
    
    return imageName;
}

+(NSString *)stringWithDouble:(double)value decimalsCount:(int)decimalsCount
{
    if (decimalsCount < 0) {
        return nil;
    }
    
    //生成格式字符串
    NSString *fmt = [NSString stringWithFormat:@"%%.%df", decimalsCount];
    
    //生成保留decimalsCount位小数的字符串
    NSString *str = [NSString stringWithFormat:fmt, value];
    
    //没有小数，直接返回
    if ([str rangeOfString:@"."].length == 0) {
        return str;
    }
    
    //从最后面往前找，不断删除最后面的0和最后一个“.”
    int index = str.length - 1;
    unichar currentChar = [str characterAtIndex:index];
    for (; currentChar == '0' || currentChar == '.'; index--, currentChar = [str characterAtIndex:index]) {
        //裁减到“.”直接返回
        if (currentChar == '.') {
            return [str substringToIndex:index];
        }
    }
    
    str = [str substringToIndex:index + 1];
    
    return str;
}


@end
