
//  Weibo
//
//  Created by Fay on 15/9/17.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFTabBar;
@protocol XFTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(XFTabBar *)tabBar;
@end

@interface XFTabBar : UITabBar

@property(nonatomic,weak)id <XFTabBarDelegate> delegate;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com