//
//  TaobaoMiniVideoViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 17/1/11.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import "TaobaoMiniVideoViewController.h"

@interface TaobaoMiniVideoViewController (){
    UITableView *ttview;
}

@end

@implementation TaobaoMiniVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = redcolor;
    ttview = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, APPW, 400)];
    ttview.backgroundColor = gradcolor;
    ttview.delegate = self;
    ttview.dataSource = self;
    [self.view addSubview:ttview];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"nametextlable";
    cell.detailTextLabel.text = @"这就是详情介绍的具体的信息";
    
    
    return cell;
}

@end
