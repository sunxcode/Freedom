//  JuheDataTabBarController.m
//  Created by Super on 16/8/19.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "JuheDataTabBarController.h"
@interface BaseTabBar()
@property(nonatomic,weak)UIButton *centerButton;
@end
@implementation BaseTabBar
//告知系统动态处理delegate
@dynamic delegate;
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        UIButton *centerbutton=[[UIButton alloc]init];
        [centerbutton setImage:[UIImage imageNamed:@"juhetab3"] forState:UIControlStateNormal];
        centerbutton.frame=CGRectMake(0, 0, centerbutton.currentImage.size.width, centerbutton.currentImage.size.height);
        centerbutton.frame = CGRectMake(0, 0, APPW/5,50);
        centerbutton.layer.cornerRadius = 25;
        centerbutton.clipsToBounds = YES;
        centerbutton.backgroundColor = [UIColor redColor];
        [self addSubview:centerbutton];
        self.centerButton=centerbutton;
        //为centerButton添加时间
        [centerbutton addTarget:self action:@selector(centerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }return self;
}
-(void)centerButtonClick{
    if([self.delegate respondsToSelector:@selector(MyTabBarDidClickCenterButton:)]){
        [self.delegate MyTabBarDidClickCenterButton:self];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //1.设置中间按钮的位置
    self.centerButton.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5-12);
    //计算每个UITabBarButton的宽
    CGFloat tabbarButtonW = self.bounds.size.width/5;
    CGFloat buttonIndex = 0;
    //2.设置系统根据子vc创建的4个UITabBarButton的位置
    for (UIView *child in self.subviews) {
        //根据字符串做类名，找到该类型的类型信息
        Class class = NSClassFromString(@"UITabBarButton");
        //判断当前遍历到的子视图是否是class类型
        if ([child isKindOfClass:class]) {
            //先拿出button原有的frame
            CGRect frame = child.frame;
            //改子视图的宽
            frame.size.width = tabbarButtonW;
            //改子视图的x
            frame.origin.x = buttonIndex*tabbarButtonW;
            //再把改完的frame赋会给button
            child.frame = frame;
            buttonIndex++;
            if (buttonIndex==3) {
//                buttonIndex++;
                child.hidden = YES;
            }
        }
    }
}
@end
@interface JuheDataTabBarController ()<BaseTabBarDelegate>
@property (nonatomic, strong) NSMutableArray *items;
@end
@implementation JuheDataTabBarController
- (NSMutableArray *)items{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }return _items;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //通过设置文本属性来设置字体颜色
    for(UIViewController *s in self.childViewControllers){
        NSMutableDictionary *attM = [NSMutableDictionary dictionary];
        [attM setObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
        [s.tabBarItem setTitleTextAttributes:attM forState:UIControlStateSelected];
        s.tabBarItem.image = [s.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        s.tabBarItem.selectedImage = [s.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //获取UITabbarItem的样品实例
    UITabBarItem *barItem = [UITabBarItem appearance];
    //保存正常状态下的文本属性
    NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
    normalAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    normalAttributes[NSForegroundColorAttributeName] = [UIColor grayColor];
    [barItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    //保存选中状态下的文本属性
    NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
    selectedAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:26/255.0 green:178/255.0 blue:10/255.0  alpha:1.0];
    [barItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    //2.替换系统自带的tabbar
    BaseTabBar *tabbar = [[BaseTabBar alloc]init];
    tabbar.delegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
}
-(void)MyTabBarDidClickCenterButton:(BaseTabBar *)tabBar{
    NSLog(@"中间的按钮被点击了");
    self.selectedIndex = 2;
}
@end
