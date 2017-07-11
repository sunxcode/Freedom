//
//  DZHomeController.m
//  Shop
//
//  Created by dengwei on 15/12/1.
//  Copyright (c) 2015年 dengw. All rights reserved.
//

#import "DZHomeController.h"
#import "UIImage+DZ.h"

@interface DZHomeController ()

@end

@implementation DZHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
    
}

#pragma mark 搭建UI界面
-(void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置右上角按钮
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithRenderingOriginalName:@"addstore_icon_add@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = more;
    //设置左上角按钮
    UIBarButtonItem *map = [[UIBarButtonItem alloc]initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(mapAction)];
    self.navigationItem.leftBarButtonItem = map;
    //创建搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"输入商户名、地点";
    self.navigationItem.titleView = searchBar;
    
    //增加顶部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake( kTableBorderWidth, 0, 0, 0);
}

-(void)moreAction
{
    DLog(@"更多");
    
}

#pragma mark 选择地点
-(void)mapAction{
    DLog(@"定位");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}



@end
