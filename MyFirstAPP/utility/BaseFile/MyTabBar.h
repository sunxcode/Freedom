//
//  MyTabBar.h
//  视图整合练习
//
//  Created by ISD1510 on 16/1/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyTabBar;
@protocol MyTabBarDelegate <UITabBarDelegate>
-(void)MyTabBarDidClickCenterButton:(MyTabBar*)tabBar;

@end
@interface MyTabBar : UITabBar
@property(nonatomic,weak)id<MyTabBarDelegate>delegate;
@end
