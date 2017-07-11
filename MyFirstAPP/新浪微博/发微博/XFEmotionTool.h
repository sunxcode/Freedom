//
//  XFEmotionTool.h
//  
//
//  Created by Fay on 15/10/22.
//
//

#import <Foundation/Foundation.h>
@class XFEmotion;
@interface XFEmotionTool : NSObject
+ (void)addRecentEmotion:(XFEmotion *)emotion;
+ (NSArray *)recentEmotions;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com