//  XFProfileViewController.m
//  Freedom
//  Created by Super on 15/9/13.
#import "SinaProfileViewController.h"
#import "SinaSettingViewController.h"
@interface SinaProfileViewController ()
@property (nonatomic,assign,getter=isLogin) NSString *login;
@end
@implementation SinaProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //校验是否登录：未登录，需要显示登录注册
    [self setupNavgationItem];
    // 初始化模型数据
    [self setupGroups];
}
- (NSString *)isLogin{
    if (_login==nil) {
        //需要判断当前是否登录
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *loginFlag = [defaults objectForKey:@"loginFlag"];
        if (loginFlag == nil) {
            _login = @"false";
        }else{
            _login = @"true";
        }
        
    }
    return _login;
}
/*初始化模型数据*/
- (void)setupGroups{
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    [self setupGroup4];
}
- (void)setupGroup0{
    // 1.创建组
    SinaCommonGroup *group = [SinaCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    SinaCommonArrowItem *newFriend = [SinaCommonArrowItem itemWithTitle:@"新的好友" icon:@"new_friend"];
    newFriend.badgeValue = @"5";
    SinaCommonArrowItem *renwu = [SinaCommonArrowItem itemWithTitle:@"新手任务" icon:@"new_friend"];
    renwu.badgeValue = @"5";
    
    group.items = @[newFriend,renwu];
}
- (void)setupGroup1{
    // 1.创建组
    SinaCommonGroup *group = [SinaCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    SinaCommonArrowItem *album = [SinaCommonArrowItem itemWithTitle:@"我的相册" icon:@"u_album_g"];
    album.subtitle = @"(100)";
    
    
    SinaCommonArrowItem *like = [SinaCommonArrowItem itemWithTitle:@"我的赞" icon:@"like"];
    like.subtitle = @"(36)";
    like.badgeValue = @"10";
    
    group.items = @[album, like];
}
- (void)setupGroup2{
    // 1.创建组
    SinaCommonGroup *group = [SinaCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    SinaCommonArrowItem *newFriend = [SinaCommonArrowItem itemWithTitle:@"微博支付" icon:@"new_friend"];
    SinaCommonArrowItem *renwu = [SinaCommonArrowItem itemWithTitle:@"微博运动" icon:@"new_friend"];
    group.items = @[newFriend,renwu];
}
- (void)setupGroup3{
    // 1.创建组
    SinaCommonGroup *group = [SinaCommonGroup group];
    [self.groups addObject:group];
    // 2.设置组的所有行数据
    SinaCommonArrowItem *newFriend = [SinaCommonArrowItem itemWithTitle:@"草稿箱" icon:@"new_friend"];
    
    group.items = @[newFriend];
}
- (void)setupGroup4{
    // 1.创建组
    SinaCommonGroup *group = [SinaCommonGroup group];
    [self.groups addObject:group];
    // 2.设置组的所有行数据
    SinaCommonArrowItem *collect = [SinaCommonArrowItem itemWithTitle:@"更多" icon:@"collect"];
    collect.subtitle = @"(10)";
    collect.badgeValue = @"1";
    group.items = @[collect];
}
/*设置当前控制器的导航显示item*/
- (void)setupNavgationItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加好友" style:UIBarButtonItemStyleDone target:self action:@selector(addFreinds)];
}
-(void)setting{
    SinaSettingViewController *setting = [[SinaSettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
    
}
- (void)addFreinds{
    DLog(@"添加朋友");
}
@end
