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
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(50, 15, 60, 60)];
    icon.layer.cornerRadius = H(icon)/2.0;icon.layer.masksToBounds = YES;
    UILabel *name = [Utility labelWithFrame:CGRectMake(XW(icon)+30, 20, 100, 20) font:fontTitle color:blacktextcolor text:@"薛超  👑VIP"];
    UILabel *phone = [Utility labelWithFrame:CGRectMake(X(name), YH(name)+10, 200, 20) font:fontTitle color:blacktextcolor text:@"18721064516"];
    [headerView addSubviews:icon,name,phone,nil];
    [icon imageWithURL:[[Utility Share] userLogo] useProgress:NO useActivity:NO];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 50)];
    UIButton *quit = [Utility buttonWithFrame:CGRectMake(APPW/2-50, 10, 100, 30) title:@"退      出" image:nil bgimage:nil];
    quit.backgroundColor = redcolor;[v addSubview:quit];
    NSArray *titles = @[@"我的投资",@"我的钱袋",@"我的预约",@"交易大厅",@"我的收藏",@"我的购物车",@"我的订单",@"收货地址"];
    NSArray *icons = @[@"juheintopublic",@"juheintopublic",@"juheintopublic",@"juheintopublic",@"juheintopublic",@"juheintopublic",@"juheintopublic",@"juheintopublic"];
    BaseScrollView *banItemSV = [BaseScrollView sharedBaseItemWithFrame:CGRectMake(0, 100, APPW, 160) icons:icons titles:titles size:CGSizeMake(APPW/4.0, 80) round:NO];
    [headerView addSubview:banItemSV];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:
         @{@"name":@"IP地址",@"pic":@"juheintopublic"},@{@"name":@"手机号码归属地",@"pic":@"juhelookhistory"},@{@"name":@"身份证查询",@"pic":@"juheaboutus"},@{@"name":@"常用快递",@"pic":@"juhechart"},
         @{@"name":@"餐饮美食",@"pic":@"juhechart"},@{@"name":@"菜谱大全",@"pic":@"juhechart"},@{@"name":@"彩票开奖结果",@"pic":@"juhechart"},@{@"name":@"邮编查询",@"pic":@"juhechart"},
         @{@"name":@"律师查询",@"pic":@"juhechart"},@{@"name":@"笑话大全",@"pic":@"juhechart"},@{@"name":@"小说大全",@"pic":@"juhechart"},@{@"name":@"恋爱物语",@"pic":@"juhechart"},
         @{@"name":@"商品比价",@"pic":@"juhechart"},@{@"name":@"新闻",@"pic":@"juhechart"},@{@"name":@"微信精选",@"pic":@"juhechart"},@{@"name":@"经典日至",@"pic":@"juhechart"},
         @{@"name":@"天气查询",@"pic":@"juhechart"},@{@"name":@"手机话费",@"pic":@"juhechart"},@{@"name":@"个人缴费",@"pic":@"juhechart"},@{@"name":@"移动出行",@"pic":@"juhechart"},
         @{@"name":@"足球赛事",@"pic":@"juhechart"},@{@"name":@"新闻资讯",@"pic":@"juhechart"},@{@"name":@"视频播放",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"}, nil];
    [self fillTheTableDataWithHeadV:headerView footV:v canMove:NO canEdit:NO headH:0 footH:0 rowH:60 sectionN:1 rowN:5 cellName:@"JuheUserViewCell"];
    [self.view addSubview:self.tableView];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

@end
