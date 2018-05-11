//
//  WechatBaseViewController.m
//  Freedom
//
//  Created by htf on 2018/5/11.
//  Copyright © 2018年 薛超. All rights reserved.
#import "WechatBaseViewController.h"
@implementation UIViewController (JZExtension)
- (void)setHidesNavigationBarWhenPushed:(BOOL)hidesNavigationBarWhenPushed {
    objc_setAssociatedObject(self, @selector(hidesNavigationBarWhenPushed), @(hidesNavigationBarWhenPushed), OBJC_ASSOCIATION_ASSIGN);
}
- (void)setNavigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden {
    CGFloat alpha = navigationBarBackgroundHidden ? 0 : 1-self.navigationController._navigationBarBackgroundReverseAlpha;
    [[self.navigationController.navigationBar valueForKey:@"_backgroundView"] setAlpha:alpha];
    objc_setAssociatedObject(self, @selector(isNavigationBarBackgroundHidden), @(navigationBarBackgroundHidden), OBJC_ASSOCIATION_ASSIGN);
}
- (void)setNavigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
        [self setNavigationBarBackgroundHidden:navigationBarBackgroundHidden];
    }];
}
- (BOOL)hidesNavigationBarWhenPushed {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (BOOL)isNavigationBarBackgroundHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end


@interface WechatBaseViewController ()
@end
@implementation WechatBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
@end
