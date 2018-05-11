//  JuheDataTabBarController.h
//  Created by Super on 16/8/19.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "BaseTabBarController.h"
@class BaseTabBar;
@protocol BaseTabBarDelegate <UITabBarDelegate>
-(void)MyTabBarDidClickCenterButton:(BaseTabBar*)tabBar;
@end
@interface BaseTabBar : UITabBar
@property(nonatomic,weak)id<BaseTabBarDelegate>delegate;
@end
@interface JuheDataTabBarController : BaseTabBarController
@end
