//

//  Freedom
//
//  Created by 薛超 on 16/8/19.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "UIViewController+add.h"
#import "User.h"
@implementation UIViewController (add)
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
    NSArray *theNewItems = [User getControllerData];
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
