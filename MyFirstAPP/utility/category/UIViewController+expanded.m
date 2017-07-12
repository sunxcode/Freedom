//
//  UIViewController+expanded.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/19.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "UIViewController+expanded.h"

@implementation UIViewController (expanded)
- (void)backToLastViewController{
    if ([self isEqual:[[UIApplication sharedApplication].delegate window].rootViewController]) return;
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:^{
        }];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
