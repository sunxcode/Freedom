//
//  BooksTabBarController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/19.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BooksTabBarController.h"
#import "NewSliderViewController.h"
#import "BooksViewController.h"
#import "WXViewController.h"
#import "E_ScrollViewController.h"
@interface BooksTabBarController()
@property (strong, nonatomic) NewSliderViewController *side;
@end
@implementation BooksTabBarController
-(void)viewDidLoad{
    BooksViewController *bookshelf = [[BooksViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:bookshelf];
    WXViewController *left = [[WXViewController alloc]init];
    UINavigationController *na2 = [[UINavigationController alloc]initWithRootViewController:left];
    E_ScrollViewController *right = [[E_ScrollViewController alloc]init];
    UINavigationController *na3 = [[UINavigationController alloc]initWithRootViewController:right];
    self.side = [[NewSliderViewController alloc]initWithLeftViewController:na2 CenterViewController:na RigthViewController:na3];
    self.side.leftWidth = 0.8 * [UIScreen mainScreen].bounds.size.width;
    self.side.rightWidth = [UIScreen mainScreen].bounds.size.width;

    [self addChildViewController:_side];
}
@end
