//  ToutiaoMeViewController.m
//  Created by Super on 16/8/25.
//  Copyright © 2016年 Super. All rights reserved.
#import "ToutiaoMeViewController.h"
#import <XCategory/UILabel+expanded.h>
@interface ToutiaoMeViewController ()
@end
@implementation ToutiaoMeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance]setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:[self creatTableHeadView]];
}
-(UIView*)creatTableHeadView{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 200)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 120)];
    for(int i=0;i<3;i++){
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50+120*i, 20, 50, 50)];
        button.layer.cornerRadius = 25;
        button.clipsToBounds = YES;
        [button setImage:[UIImage imageNamed:PuserLogo] forState:UIControlStateNormal];
        [view addSubview:button];
    }
    view.backgroundColor = RGBCOLOR(10, 10, 10);
    UILabel *label = [UILabel labelWithFrame:CGRectMake(10, H(view)-30, APPW-20, 20) font:fontnomal color:whitecolor text:@"登录推荐更精准" textAlignment:NSTextAlignmentCenter];
    [view addSubview:label];
    [head addSubview:view];
    NSArray *titles = @[@"收藏",@"历史",@"夜间"];
    for(int i=0;i<3;i++){
        UIButton *buton = [[UIButton alloc]initWithFrame:CGRectMake(i*APPW/3, YH(view), APPW/3, 60)];
        [buton setImage:[UIImage imageNamed:Pwechart] forState:UIControlStateNormal];
        [buton setTitle:titles[i] forState:UIControlStateNormal];
        [buton setImageEdgeInsets:UIEdgeInsetsMake(5, 45, 20, 45)];
        [buton setTitleEdgeInsets:UIEdgeInsetsMake(35, -APPW/3+10, 0, 0)];
        [buton setTitleColor:blacktextcolor forState:UIControlStateNormal];
        buton.titleLabel.font = fontnomal;
        buton.backgroundColor = whitecolor;
        [head addSubview:buton];
    }
    return head;
}
@end
