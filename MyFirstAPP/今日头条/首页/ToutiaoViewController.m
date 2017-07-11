//
//  ToutiaoViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/18.
//  Copyright © 2016年 薛超. All rights reserved.
#import "ToutiaoViewController.h"
static CGFloat const titleHeight = 40;
@interface ToutiaoViewController()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView * titleScrollView;//标题ScrollView
@property (nonatomic,weak) UIScrollView * contentScrollView;//内容scrollView
@property (nonatomic,weak) UIButton * selTitlebutton;//标题中的按钮
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSMutableArray *titles;
@end

@implementation ToutiaoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ToutiaoBackBar"] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles =[NSMutableArray arrayWithArray:@[@"这个",@"那个",@"好样的",@"么呢",@"打开",@"这个",@"那个",@"好样的",@"么呢"]];
    //设置头标题栏
    [self setTitleScrollView];
    //设置内容
    [self setupContentScrollView];
    //添加自控制器
    [self addChildViewController];
    //设置标题
    [self setTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * kScreenWidth, 0);
    //支持整页滑动
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    [self.titleScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}
#pragma mark - 设置头标题栏
-(void) setTitleScrollView{
    CGRect rect = CGRectMake(0, 0, kScreenWidth, titleHeight);
    UIScrollView * titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
//    [self.view addSubview:titleScrollView];
    
    [self.navigationController.navigationBar addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
}
#pragma mark - 设置内容
-(void) setupContentScrollView{
    CGRect rect = CGRectMake(0, YH(self.titleScrollView), kScreenWidth, kScreenHeight);
    UIScrollView * contentScrollView = [[UIScrollView alloc]initWithFrame:rect];
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
}
#pragma mark - 加入子控制器
-(void) addChildViewController{
    for(int i=0;i<self.titles.count;i++){
        UIViewController *con = [[UIViewController alloc]init];
        con.title = self.titles[i];
        [self addChildViewController:con];
    }
}
#pragma mark - 设置标题
-(void) setTitle{
    self.buttons = [NSMutableArray array];
    NSUInteger count = self.childViewControllers.count;
    CGFloat x = 0;
    CGFloat w = 50;
    CGFloat h = titleHeight;
    for (int i = 0; i<count; i++) {
        UIViewController * vc = self.childViewControllers[i];
        //设置标题的位置
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton * button = [[UIButton alloc]initWithFrame:rect];
        button.tag = i;
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        [self.buttons addObject:button];
        [self.titleScrollView addSubview:button];
        if(i == 0){
            [self click:button];
        }
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}
#pragma mark - 按钮点击时间改变contentScrollView的值
-(void) click:(UIButton *) button{
    NSUInteger i = button.tag;
    CGFloat x = i * kScreenWidth;
    //改变按钮
    [self setTitleBtn:button];
    //转到下一个viewController
    [self setOnchildViewController:i];
    //移动childViewController
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

#pragma  mark - 改变按钮
-(void) setTitleBtn:(UIButton *) button{
    [self.selTitlebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selTitlebutton.transform = CGAffineTransformIdentity;
    //文字变红
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //放大的效果,放大1.5倍
    button.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.selTitlebutton = button;
    [self setUpTitleCenter:button];
}
-(void) setOnchildViewController:(NSUInteger) i{
    CGFloat x = i * kScreenWidth;
    UIViewController * vc = self.childViewControllers[i];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, kScreenWidth, kScreenHeight - YH(self.titleScrollView));
    [self.contentScrollView addSubview:vc.view];
}
//实现一个移动后标题居中
-(void) setUpTitleCenter:(UIButton *) button{
    //判断ScrollView的contentoffset的值
    CGFloat offset = button.center.x - kScreenWidth * 0.5 ;
    //在当前的左边
    if(offset < 0){
        offset = 0;
    }
    CGFloat maxOffset = self.titleScrollView.contentSize.width - kScreenWidth;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}
#pragma mark - 利用协议解决滑动contentViewController
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger i = self.contentScrollView.contentOffset.x / kScreenWidth;
    [self setTitleBtn:self.buttons[i]];
    [self setOnchildViewController:i];
}
#pragma mark - 实现字体颜色大小的渐变
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    //定义一个两个变量控制左右按钮的渐变
    NSInteger left = offset/kScreenWidth;
    NSInteger right = 1 + left;
    UIButton * leftButton = self.buttons[left];
    UIButton * rightButton = nil;
    if (right < self.buttons.count) {
        rightButton = self.buttons[right];
    }
    //切换左右按钮
    CGFloat scaleR = offset/kScreenWidth - left;
    CGFloat scaleL = 1 - scaleR;
    //左右按钮的缩放比例
    CGFloat tranScale = 1.2 - 1 ;
    //宽和高的缩放(渐变)
    leftButton.transform = CGAffineTransformMakeScale(scaleL * tranScale + 1, scaleL * tranScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * tranScale + 1, scaleR * tranScale + 1);
    //颜色的渐变
//    UIColor * rightColor = [UIColor colorWithRed:scaleR green:250 blue:250 alpha:1];
    UIColor * leftColor = [UIColor colorWithRed:230 green:230 blue:230 alpha:1];
    //重新设置颜色
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
//    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    
}
@end
