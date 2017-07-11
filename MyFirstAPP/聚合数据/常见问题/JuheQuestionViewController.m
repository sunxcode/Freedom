//
//  JuheQuestionViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/9/5.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "JuheQuestionViewController.h"
#import "JuheDetailQuestion.h"
@interface JuheQuestionViewController()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *JuheQuestiontableView;
}
@end
@implementation JuheQuestionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
}

#pragma mark 搭建UI界面
-(void)buildUI{
    self.view.backgroundColor = [UIColor whiteColor];
    //设置右上角按钮
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addstore_icon_add@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = more;
    //设置左上角按钮
//    UIBarButtonItem *map = [[UIBarButtonItem alloc]initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(mapAction)];
//    self.navigationItem.leftBarButtonItem = map;
    //创建搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"输入问题关键字";
    self.navigationItem.titleView = searchBar;
    JuheQuestiontableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    //增加顶部额外的滚动区域
    JuheQuestiontableView.contentInset = UIEdgeInsetsMake( 8, 0, 0, 0);
    [self.view addSubviews:JuheQuestiontableView,nil];
}

-(void)moreAction{
    DLog(@"更多");
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"JuheQuestion";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text =@"";
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[[JuheDetailQuestion alloc]init] animated:YES];
}


@end
