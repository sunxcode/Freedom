
//  Weibo
//
//  Created by Fay on 15/10/3.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFStatusPhotosView : UIView
@property(nonatomic,strong) NSArray *photos;
/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(int)count;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com