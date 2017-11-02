//
//  EnergyNewsDetailViewController.m
//  Created by 薛超 on 16/9/5.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "EnergyNewsDetailViewController.h"

@implementation EnergyNewsDetailViewController{
    UIWebView *web;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://weibo.com/tv/v/ErdijBWkT?ref=feedsdk&type=ug"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [web loadRequest:request];
    [self.view addSubview:web];
}
@end
