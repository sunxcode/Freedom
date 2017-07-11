//
//  IqiyiNavigationController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/9/2.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "IqiyiNavigationController.h"

@implementation IqiyiNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;//不是半透明
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, Font(16), NSFontAttributeName, nil]];
    self.navigationBar.barTintColor = IqiyinavigationBarColor;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
        self.edgesForExtendedLayout = UIRectEdgeNone;//视图控制器，四条边不指定
        self.extendedLayoutIncludesOpaqueBars = NO;//不透明的操作栏
        self.modalPresentationCapturesStatusBarAppearance = NO;
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@""] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    }
}

@end
