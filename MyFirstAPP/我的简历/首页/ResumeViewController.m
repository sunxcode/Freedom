//
//  ResumeViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/18.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "ResumeViewController.h"
#import "ResumeDetailViewController.h"
@interface ResumeViewCell:BaseTableViewCell
@end
@implementation ResumeViewCell
-(void)initUI{

}
-(void)setDataWithDict:(NSDictionary *)dict{
    
}
@end
@interface ResumeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *refTableView;
    UILabel *label;
    BaseScrollView *ResumeHomeScrollV;
}
@end
@implementation ResumeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    NSArray *titles = @[@"我的成长史",@"我的作品",@"我的经历",@"微页1",@"微页2",@"微页3"];
    NSArray *controllers = @[@"ResumeDetailViewController",@"ResumeDetailViewController",@"ResumeDetailViewController",@"ResumeDetailViewController",@"ResumeDetailViewController",@"ResumeDetailViewController"];
    ResumeHomeScrollV = [BaseScrollView sharedContentTitleViewWithFrame:CGRectMake(0, 0, APPW, APPH-TabBarH) titles:titles controllers:controllers inView:self.view];
    NSArray *urls = @[MicroPage3,ResumeURL,WeChatApplet1,WeChatApplet2,MicroPage1,MicroPage2];
    ResumeHomeScrollV.selectBlock = ^(NSInteger index, NSDictionary *dict) {
        ResumeDetailViewController *con = ResumeHomeScrollV.contentScrollView.controllers[index];
        con.dataurl = urls[index];
    };
    [ResumeHomeScrollV selectThePage:0];
}



@end

