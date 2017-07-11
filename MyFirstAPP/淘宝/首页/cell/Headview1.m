//
//  Headview1.m
//  TaoBaoHomeDemo
//
//  Created by xun on 16/5/10.
//  Copyright © 2016年 xun. All rights reserved.
//

#import "Headview1.h"

@implementation Headview1 {
    __weak IBOutlet UIScrollView *scroll;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initFlash];
}

- (void)initFlash {
    scroll.contentSize = CGSizeMake(kScreenWidth *2, kScreenWidth/4);
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator   = NO;
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/4)];
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenWidth/4)];
    image1.image = [UIImage imageNamed:@"image2.jpg"];
    image2.image = [UIImage imageNamed:@"image4.jpg"];
    [scroll addSubview:image1];
    [scroll addSubview:image2];
}

@end
