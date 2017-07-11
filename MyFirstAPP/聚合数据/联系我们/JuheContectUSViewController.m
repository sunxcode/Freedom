//
//  JuheContectUSViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/9/5.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "JuheContectUSViewController.h"
#import "JuhePublicViewController.h"
#import "JuheMessageViewController.h"
#import "JuheAboutUSViewController.h"
#import "JuheChartViewController.h"
@implementation JuheContectUSViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIButton *publicNumber = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, kScreenWidth-60, 90)];
    [publicNumber setImage:[UIImage imageNamed:@""] imageHL:[UIImage imageNamed:@""]];
    [publicNumber setTitle:@"" forState:UIControlStateNormal];
    [publicNumber setTitleColor:blacktextcolor forState:UIControlStateNormal];
    [publicNumber addTarget:self action:@selector(publicNumber) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *message = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, kScreenWidth-60, 90)];
    [message setImage:[UIImage imageNamed:@""] imageHL:[UIImage imageNamed:@""]];
    [message setTitle:@"" forState:UIControlStateNormal];
    [message setTitleColor:blacktextcolor forState:UIControlStateNormal];
    [message addTarget:self action:@selector(message) forControlEvents:UIControlEventTouchUpInside];

    UIButton *aboutUS = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, kScreenWidth-60, 90)];
    [aboutUS setImage:[UIImage imageNamed:@""] imageHL:[UIImage imageNamed:@""]];
    [aboutUS setTitle:@"" forState:UIControlStateNormal];
    [aboutUS setTitleColor:blacktextcolor forState:UIControlStateNormal];
    [aboutUS addTarget:self action:@selector(aboutUS) forControlEvents:UIControlEventTouchUpInside];

    UIButton *chart = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, kScreenWidth-60, 90)];
    [chart setImage:[UIImage imageNamed:@""] imageHL:[UIImage imageNamed:@""]];
    [chart setTitle:@"" forState:UIControlStateNormal];
    [chart setTitleColor:blacktextcolor forState:UIControlStateNormal];
    [chart addTarget:self action:@selector(chart) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)publicNumber{
    [self.navigationController pushViewController:[[JuhePublicViewController alloc]init] animated:YES];
}
-(void)message{
    [self.navigationController pushViewController:[[JuheMessageViewController alloc]init] animated:YES];
}
-(void)aboutUS{
    [self.navigationController pushViewController:[[JuheAboutUSViewController alloc]init] animated:YES];
    
}
-(void)chart{
    [self.navigationController pushViewController:[[JuheChartViewController alloc]init] animated:YES];
    
}
@end
