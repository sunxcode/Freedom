//
//  WechartTabBarController.h
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/19.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WechartTabBarController : BaseTabBarController
+ (WechartTabBarController *) sharedRootViewController;

/**
 *  获取tabbarController的第Index个VC（不是navController）
 *
 *  @return navController的rootVC
 */
- (id)childViewControllerAtIndex:(NSUInteger)index;
@end
