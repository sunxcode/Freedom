//
//  JuheUserViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/9/5.
//  Copyright © 2016年 薛超. All rights reserved.
//
#import "JuheUserViewController.h"
@interface JuheUserViewCell:BaseTableViewCell
@end
@implementation JuheUserViewCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(10, 10, 40, 40);
    self.title.frame = CGRectMake(XW(self.icon)+10, 20, 200, 20);
    self.line.frame = CGRectMake(10, 59, APPW-20, 1);
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:dict[@"pic"]];
    self.title.text = dict[@"name"];
}
@end

@implementation JuheUserViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"个人中心"];
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH)];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 260)];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 60, 60)];
    icon.layer.cornerRadius = H(icon)/2.0;icon.layer.masksToBounds = YES;
    UILabel *name = [Utility labelWithFrame:CGRectMake(XW(icon)+10, 10,300, 20) font:fontTitle color:blacktextcolor text:@"用户名：18326891683  👑已认证"];
    UILabel *openid = [Utility labelWithFrame:CGRectMake(X(name), YH(name), 400, 20) font:fontTitle color:blacktextcolor text:@"OpenId:JH12bd23ef316e3d8a9dfe7402ef8bc453"];
    UILabel *email = [Utility labelWithFrame:CGRectMake(X(name), YH(openid), 300, 20) font:fontTitle color:blacktextcolor text:@"绑定邮箱:1069106050@qq.com"];
    UILabel *phone = [Utility labelWithFrame:CGRectMake(X(name), YH(email), 300, 20) font:fontTitle color:blacktextcolor text:@"手机号码:18721064516"];
    [headerView addSubviews:icon,name,openid,email,phone,nil];
    [icon imageWithURL:[[Utility Share] userLogo] useProgress:NO useActivity:NO];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 50)];
    UIButton *quit = [Utility buttonWithFrame:CGRectMake(APPW/2-50, 10, 100, 30) title:@"退      出" image:nil bgimage:nil];
    [quit setTitleColor:whitecolor forState:UIControlStateNormal];
    quit.backgroundColor = redcolor;[v addSubview:quit];
    NSArray *titles = @[@"我的聚合",@"我的数据",@"我的收藏",@"我的余额",@"聚合币",@"优惠券",@"发票管理",@"其他信息"];
    NSArray *icons = @[@"juheintopublic",@"juheintopublic",@"juheintopublic",@"juheintopublic",@"juheintopublic",@"juheintopublic",@"juheintopublic",@"juheintopublic"];
    BaseScrollView *banItemSV = [BaseScrollView sharedBaseItemWithFrame:CGRectMake(0, 100, APPW, 160) icons:icons titles:titles size:CGSizeMake(APPW/4.0, 80) round:NO];
    [headerView addSubview:banItemSV];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:
         @{@"name":@"我的充值记录",@"pic":@"juheintopublic"},@{@"name":@"我的消费记录",@"pic":@"juhelookhistory"},@{@"name":@"账户信息",@"pic":@"juheaboutus"},@{@"name":@"密码修改",@"pic":@"juhechart"},
         @{@"name":@"实名认证",@"pic":@"juhechart"}, nil];
    [self fillTheTableDataWithHeadV:headerView footV:v canMove:NO canEdit:NO headH:0 footH:0 rowH:60 sectionN:1 rowN:5 cellName:@"JuheUserViewCell"];
    [self.view addSubview:self.tableView];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

@end
