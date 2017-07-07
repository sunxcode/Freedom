
#import "CustomTabBar.h"
@interface CustomTabBar ()<UITabBarControllerDelegate>{
    NSMutableArray *buttons;
    NSMutableArray *lbls;
    NSInteger	currentSelectedIndex;
}
@end
@implementation CustomTabBar
static CustomTabBar *_instance=nil;
+(id)creatCustomTabBarWithDictionary:(NSArray *)dict{
    if(_instance==nil){
        _instance = [[self alloc]init];
        for (UITabBarItem *item in _instance.tabBar.items) {
            item.enabled=NO;
        }
        [_instance customTabBarWithDictionary:dict];
    }
    return _instance;
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

- (void)customTabBarWithDictionary:(NSArray*)tabs{
        for(UIView *view in self.tabBar.subviews){
            [view removeFromSuperview];
        }
        UIView *tabBarBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
        [self.tabBar addSubview:tabBarBackGroundView];
        UIView *lineV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, W(tabBarBackGroundView), 0.5)];
        lineV.backgroundColor=RGBACOLOR(150, 150, 150, 0.8);
        [tabBarBackGroundView addSubview:lineV];
        tabBarBackGroundView.backgroundColor = gradcolor;
         //创建按钮
        NSInteger viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
        buttons = [NSMutableArray arrayWithCapacity:viewCount];
        lbls = [NSMutableArray arrayWithCapacity:viewCount];
        double _width = kScreenWidth / viewCount;
        double _height = self.tabBar.frame.size.height;
        for (int i = 0; i < viewCount; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*_width,0, _width, _height);
            [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:tabs[i][1]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:tabs[i][2]] forState:UIControlStateSelected];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 14, 0)];
            [buttons addObject:btn];
            [tabBarBackGroundView  addSubview:btn];
            UILabel *lblt=[RHMethods labelWithFrame:CGRectMake(X(btn), 29, W(btn), 20) font:Font(11) color:RGBACOLOR(100, 100, 100, 1) text:tabs[i][0]];
            [lblt setTextAlignment:NSTextAlignmentCenter];
            [lbls addObject:lblt];
            [tabBarBackGroundView addSubview:lblt];
    }
     [self selectedTab:[buttons objectAtIndex:0]];
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UINavigationController *nav=(UINavigationController *)viewController;
    [nav popToRootViewControllerAnimated:NO];
}
- (void)selectedTab:(UIButton *)button{
    [SVProgressHUD dismiss];
    button.selected = YES;
    UILabel *lblttt=(UILabel *)[lbls objectAtIndex:button.tag];
    [lblttt setTextColor:redcolor];
    if (currentSelectedIndex != button.tag){
        UIButton *preBtn=[buttons objectAtIndex:currentSelectedIndex];
        preBtn.selected = NO;
        UILabel *lblttt=(UILabel *)[lbls objectAtIndex:currentSelectedIndex];
        [lblttt setTextColor:RGBACOLOR(100, 100, 100, 1)];
        //取消不要默认记忆效果
        [[self.viewControllers objectAtIndex:button.tag] popToRootViewControllerAnimated:NO];
    }else{
        //返回初始化页面
        [[self.viewControllers objectAtIndex:button.tag] popToRootViewControllerAnimated:NO];
    }
    currentSelectedIndex = button.tag;
    self.selectedIndex = currentSelectedIndex;
}
- (void)selectedTabIndex:(NSInteger)index{
    [self selectedTab:[buttons objectAtIndex:index]];
}
@end
