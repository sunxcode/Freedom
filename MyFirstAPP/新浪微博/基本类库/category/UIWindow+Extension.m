//
//  UIWindow+Extension.m
//  Weibo
//
//  Created by Fay on 15/9/21.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "SinaTabBarController.h"
#import "XFNewFeatureController.h"

@implementation UIWindow (Extension)
-(void)switchRootViewController {
    
    // 切换窗口的根控制器
    NSString *key = @"version";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
        return;
//        [self.rootViewController presentViewController:[[SinaTabBarController alloc] init] animated:YES completion:^{         
//        }];
    } else { // 这次打开的版本和上一次不一样，显示新特性
        [self.rootViewController presentViewController:[[XFNewFeatureController alloc] init] animated:YES completion:^{  
        }];
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com