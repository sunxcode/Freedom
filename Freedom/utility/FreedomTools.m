//  FreedomTools.m
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "FreedomTools.h"
@implementation FreedomTools
+(FreedomTools *)sharedManager{
    static FreedomTools *shareUrl = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareUrl = [[self alloc]init];
    });
    return shareUrl;
}
+ (BOOL)isChinese:(NSString *)str {
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}
+ (void)show:(nullable NSString *)msg {
    UILabel *_msgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, -64, APPW, 64)];
    _msgLab.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    _msgLab.text = msg;
    _msgLab.textColor = [UIColor whiteColor];
    _msgLab.font = [UIFont boldSystemFontOfSize:18];
    _msgLab.textAlignment = NSTextAlignmentCenter;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_msgLab];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _msgLab.frame;
        frame.origin.y = 0;
        _msgLab.frame = frame;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_msgLab removeFromSuperview];
    });
}


@end
