//
//  XFEmotionTabBar.h
//  Weibo
//
//  Created by Fay on 15/10/16.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XFEmotionTabBarButtonTypeRecent, // 最近
    XFEmotionTabBarButtonTypeDefault, // 默认
    XFEmotionTabBarButtonTypeEmoji, // emoji
    XFEmotionTabBarButtonTypeLxh, // 浪小花

} XFEmotionTabBarButtonType;

@class XFEmotionTabBar;
@protocol XFEmotionTabBarDelegate <NSObject>
@optional
- (void)emotionTabBar:(XFEmotionTabBar *)tabBar didSelectButton:(XFEmotionTabBarButtonType)buttonType;
@end

@interface XFEmotionTabBar : UIView
@property (nonatomic, weak) id<XFEmotionTabBarDelegate> delegate;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com