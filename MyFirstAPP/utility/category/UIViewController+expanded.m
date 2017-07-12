//
//  UIViewController+expanded.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/19.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "UIViewController+expanded.h"

@implementation UIViewController (expanded)
- (void)backToLastViewController{
    if ([self isEqual:[[UIApplication sharedApplication].delegate window].rootViewController]) return;
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:^{
        }];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier{
    DLog(@"代理通知发现点击了控制器%@", identifier);
    NSArray *theNewItems = @[@"Kugou",@"JuheData",@"Iqiyi",@"Taobao",@"Sina",@"Alipay",@"Resume",@"MyDatabase",@"MicroEnergy",@"Wechart",@"Dianping",@"Toutiao",@"Books",@"Freedom",@"PersonalApply"];
    int a = [identifier intValue];
    [radialMenu didTapCenterView:nil];
    NSString *controlName = theNewItems[a];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if([controlName isEqualToString:@"Sina"]){
        NSString *s =[NSString stringWithFormat:@"%@TabBarController",controlName];
        UIViewController *con = [[NSClassFromString(s) alloc]init];
        CATransition *animation = [CATransition animation];
        animation.duration = 1;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:con animated:NO completion:^{
        }];
        return;
    }
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:controlName bundle:nil];
    UIViewController *con = [StoryBoard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@TabBarController",controlName]];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    [self.view.window.layer addAnimation:animation forKey:nil];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    win.rootViewController = con;
    [win makeKeyAndVisible];
}
#pragma mark 摇一摇
/** 开始摇一摇 */
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSArray *theNewItems = @[@{@"icon":@"kugouIcon",@"title":@"酷狗",@"control":@"Kugou"},@{@"icon":@"juheIcon",@"title":@"聚合数据",@"control":@"JuheData"},@{@"icon":@"aiqiyiIcon",@"title":@"爱奇艺",@"control":@"Iqiyi"},@{@"icon":@"taobaoIcon",@"title":@"淘宝",@"control":@"Taobao"},@{@"icon":@"weiboIcon",@"title":@"新浪微博",@"control":@"Sina"},@{@"icon":@"zhifubaoIcon",@"title":@"支付宝",@"control":@"Alipay"},@{@"icon":@"jianliIcon",@"title":@"我的简历",@"control":@"Resume"},@{@"icon":@"database",@"title":@"我的数据库",@"control":@"MyDatabase"},@{@"icon":@"shengyibaoIcon",@"title":@"微能量",@"control":@"MicroEnergy"},@{@"icon":@"weixinIcon",@"title":@"微信",@"control":@"Wechart"},@{@"icon":@"dianpingIcon",@"title":@"大众点评",@"control":@"Dianping"},@{@"icon":@"toutiaoIcon",@"title":@"今日头条",@"control":@"Toutiao"},@{@"icon":@"books",@"title":@"书籍收藏",@"control":@"Books"},@{@"icon":@"ziyouzhuyi",@"title":@"个性特色自由主义",@"control":@"Freedom"},@{@"icon":@"yingyongIcon",@"title":@"个人应用",@"control":@"PersonalApply"}];
    CKRadialMenu *theMenu = [[CKRadialMenu alloc] initWithFrame:CGRectMake(APPW/2-25, APPH/2-25, 50, 50)];
    for(int i = 0;i<theNewItems.count;i++){
        UIImageView *a = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        a.image = [UIImage imageNamed:[theNewItems[i] valueForKey:@"icon"]];
        [theMenu addPopoutView:a withIndentifier:[NSString stringWithFormat:@"%d",i]];
    }
    [theMenu enableDevelopmentMode];
    theMenu.distanceBetweenPopouts = 2*180/theNewItems.count;
    theMenu.delegate = self;
    [self.view addSubview:theMenu];
    theMenu.center = self.view.center;
    UIWindow *win = [[UIApplication sharedApplication]keyWindow];
    [win addSubview:theMenu];
    [win bringSubviewToFront:theMenu];
    
}

@end
