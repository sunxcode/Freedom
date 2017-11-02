//
//  JFLoginViewController.m
//  JFTudou
//
//  Created by 保修一站通 on 15/10/19.
//  Copyright © 2015年 JF. All rights reserved.
////  项目详解：
//  github:https://github.com/tubie/JFTudou
//  简书：http://www.jianshu.com/p/2156ec56c55b


#import "JFLoginViewController.h"
#import "JFTextFieldCell.h"
#import "JFLoginBtnCell.h"
@interface JFLoginViewController ()<UITableViewDataSource, UITableViewDelegate,JFLoginBtnCellDelegate>

@property (nonatomic, strong)UITableView *loginTableView;

@end

@implementation JFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;//用push方法推出时，Tabbar隐藏
    [self initNav];
    [self initView];
    
}
-(void)initView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.loginTableView = tableView;
    self.loginTableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:self.loginTableView];
    self.view.backgroundColor = RGBCOLOR(249, 249, 249);

}

-(void)initNav{
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"登陆";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:PcellLeft target:self action:@selector(leftBarButtonItemClick) width:35 height:35];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}
-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return  70;
    }else{
        return 180;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JFTextFieldCell *cell = [JFTextFieldCell cellWithTableView:tableView];
        return cell;
    }else{
        JFLoginBtnCell *cell = [JFLoginBtnCell cellWithTableView:tableView];
        cell.delegate  = self;
        return cell;
    }

}
-(void)loginBtnClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
