//
//  ToutiaoMeViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/25.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "ToutiaoMeViewController.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
