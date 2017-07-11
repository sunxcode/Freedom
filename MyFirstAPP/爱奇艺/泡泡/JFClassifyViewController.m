//
//  JFClassifyViewController.m
//  JFTuDou
//
//  Created by 保修一站通 on 15/10/9.
//  Copyright © 2015年 JF. All rights reserved.
////  项目详解：
//  github:https://github.com/tubie/JFTudou
//  简书：http://www.jianshu.com/p/2156ec56c55b


#import "JFClassifyViewController.h"
#import "JFClassifyCell.h"
#import "JFClassifyModel.h"
#import "JFWebViewController.h"
@interface JFClassifyViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataSource;
      NSString *urlStr;
}
@property (nonatomic, strong)UITableView *classifyTableView;

@end

@implementation JFClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    urlStr = [[GetUrlString sharedManager]urlWithclassifyData];
     _dataSource = [[NSMutableArray alloc] init];
    [self initView];
    [self setUpRefresh];
}

#pragma mark - 设置普通模式下啦刷新
-(void)setUpRefresh{
    self.classifyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [self.classifyTableView.mj_header beginRefreshing];
}


-(void)initData{
   
  
    
    [NetWork sendGetUrl:urlStr withParams:nil success:^(id responseBody) {
        [self.classifyTableView.mj_header endRefreshing];
        [_dataSource removeAllObjects];
        NSMutableArray *array = [responseBody objectForKey:@"results"];
        for (int i = 0; i < array.count; i++) {
            JFClassifyModel *classM = [JFClassifyModel mj_objectWithKeyValues:array[i]];
            [_dataSource addObject:classM];
        }
        [self.classifyTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)initView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight  -64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.classifyTableView =  tableView;
    [self.view addSubview:self.classifyTableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource) {
        return _dataSource.count;
    }else{
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JFClassifyCell *cell = [JFClassifyCell cellWithTableView:tableView];
    if (_dataSource) {
        cell.classifyModel = [_dataSource objectAtIndex:indexPath.row];

    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JFWebViewController *webVC = [[JFWebViewController alloc]init];
    webVC.urlStr = [[GetUrlString sharedManager]urlWithJianShuData];
    [self.navigationController pushViewController:webVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
