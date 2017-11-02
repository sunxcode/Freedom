//
//  XFStatusPhotoView.m
//  Weibo
//
//  Created by Fay on 15/10/4.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFStatusPhotoView.h"
#import "XFPhoto.h"
#import "UIImageView+WebCache.h"

@interface XFStatusPhotoView()
@property (nonatomic, weak) UIImageView *gifView;
@end

@implementation XFStatusPhotoView

- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        // 内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容都剪掉
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhoto:(XFPhoto *)photo
{
    _photo = photo;
    // 设置图片
    NSString *s = [photo valueForKey:@"thumbnail_pic"];
    [self sd_setImageWithURL:[NSURL URLWithString:s] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    self.gifView.hidden = ![s.lowercaseString hasSuffix:@"gif"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.frameX = self.frameWidth - self.gifView.frameWidth;
    self.gifView.frameY = self.frameHeight - self.gifView.frameHeight;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com