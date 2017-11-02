//
//  XFEmotionAttachment.m
//  
//
//  Created by Fay on 15/10/22.
//
//

#import "XFEmotionAttachment.h"
#import "XFEmotion.h"

@implementation XFEmotionAttachment
- (void)setEmotion:(XFEmotion *)emotion
{
   
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com