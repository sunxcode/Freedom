//
//  XFEmotionTabBarButton.m
//  
//
//  Created by Fay on 15/10/17.
//
//

#import "XFEmotionTabBarButton.h"

@implementation XFEmotionTabBarButton

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        // 设置字体
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    
    }
    return self;
}

//重写highlight方法，取消掉高亮状态
-(void)setHighlighted:(BOOL)highlighted {
    

    
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com