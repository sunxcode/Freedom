//
//  XwelcomView.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/6/13.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "XwelcomView.h"

@interface XwelcomView(){
    
    UIScrollView *bgView;
}

@end


@implementation XwelcomView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self loadHeadData];
    }return self;
}

-(void)loadHeadData{
    bgView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [bgView setShowsHorizontalScrollIndicator:NO];
    [bgView setPagingEnabled:YES];
    [self addSubview:bgView];
    for (int i=0; i<4; i++) {
        UIImageView *imageV=[RHMethods imageviewWithFrame:CGRectMake(i*W(bgView), 0, W(bgView), H(bgView)) defaultimage:[NSString stringWithFormat:@"gfbyindao%d",i+1]];
        imageV.contentMode=UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds=YES;
        [bgView addSubview:imageV];
        if (i==3) {
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
            [imageV setUserInteractionEnabled:YES];
            [imageV addGestureRecognizer:tap];
        }
    }
    [bgView setContentSize:CGSizeMake(W(bgView) * 4, H(bgView))];
}

- (void)show{
    [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
    self.hidden = NO;
    self.alpha = 1.0f;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                             self.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                         }];
}

- (void)hidden{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

@end
