//
//  TaobaoViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/18.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "TaobaoViewController.h"
#import "TaobaoHomeViewController.h"
@implementation TaobaoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController pushViewController:[[TaobaoHomeViewController alloc]init] animated:YES];
}


@end
