//
//  XFDropdownView.h
//  Weibo
//
//  Created by Fay on 15/9/17.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFDropdownView;
@protocol XFDropdownViewDelegate <NSObject>

@optional
- (void)dropdownMenuDidDismiss:(XFDropdownView *)menu;
- (void)dropdownMenuDidShow:(XFDropdownView *)menu;
@end

@interface XFDropdownView : UIView

+(instancetype)menu;
/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@property (nonatomic,weak) id <XFDropdownViewDelegate> delegate;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com