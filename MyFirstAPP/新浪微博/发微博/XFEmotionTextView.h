//
//  XFEmotionTextView.h
//  Weibo
//
//  Created by Fay on 15/10/20.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "XFTextView.h"
@class XFEmotion;
@interface XFEmotionTextView : XFTextView
-(void)insertEmotion:(XFEmotion *)emotion;
- (NSString *)fullText;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com