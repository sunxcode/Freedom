//  BaseTabBarController.m
//  Freedom
//  Created by Super on 16/9/20.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "BaseTabBarController.h"
@interface BaseTabBarController ()
@end
@implementation BaseTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    for(UIViewController *s in self.childViewControllers){
        [self setupChildController:s image:s.tabBarItem.image SHImage:s.tabBarItem.selectedImage title:s.title];
    }
}
-(void)setupChildController:(UIViewController*)vc image:(UIImage*)image SHImage:(UIImage*)shImage title:(NSString*)title{
//    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [shImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *attM = [NSMutableDictionary dictionary];
    [attM setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [vc.tabBarItem setTitleTextAttributes:attM forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
}
@end
