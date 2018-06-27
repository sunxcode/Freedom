//  XFProfileViewController.m
//  Freedom
//  Created by Super on 15/9/13.
#import "SinaMeViewController.h"
@interface SinaMeViewController ()
@property (nonatomic,assign,getter=isLogin) NSString *login;
@end
@implementation SinaMeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //校验是否登录：未登录，需要显示登录注册
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加好友" style:UIBarButtonItemStyleDone target:nil action:nil];
    // 初始化模型数据
}
@end
