//
//  BaseTabBarController.h
//  Freedom
//
//  Created by 薛超 on 16/9/20.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseTabBar;
@protocol BaseTabBarDelegate <UITabBarDelegate>
-(void)MyTabBarDidClickCenterButton:(BaseTabBar*)tabBar;

@end
@interface BaseTabBar : UITabBar
@property(nonatomic,weak)id<BaseTabBarDelegate>delegate;
@end
@interface BaseTabBarController : UITabBarController

@end
