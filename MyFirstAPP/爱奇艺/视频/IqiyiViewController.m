//
//  IqiyiViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/18.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "IqiyiViewController.h"
#import "JFHomeModel.h"
#import "JFBoxesModel.h"
#import "JFBannerModel.h"
#import "JFImageScrollCell.h"
#import "JFHomeBoxCell.h"
#import "JFHomeVideoBoxCell.h"
#import "JFImageCardView.h"
#import "JFVideosModel.h"
#import "JFVideoDetailViewController.h"
#import "JFSearchHistoryViewController.h"
#import "JFWatchRecordViewController.h"
@interface IqiyiViewController ()<UITableViewDataSource, UITableViewDelegate,JFHomeBoxCellDelegate>{
    NSMutableArray *_dataSource;
    NSMutableArray *_boxesSource;
    NSMutableArray *_bannerSource;
    NSMutableArray *_headImageArray;
}

@property (nonatomic, strong)UITableView *homeTableView;

@end

@implementation IqiyiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNav];
    [self initView];
    [self setUpRefresh];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
-(void)setUpRefresh{
    self.homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [self.homeTableView.mj_header beginRefreshing];
}
#pragma mark - 初始化导航栏
-(void)initNav{
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qylogo_p@3x" target:nil action:nil width:65 height:24];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    UIBarButtonItem *rightUploadBarButtonItem = [UIBarButtonItem initWithNormalImage:Pwcamera target:nil action:nil width:22 height:22];
    
    UIBarButtonItem *rightHistoryBarButtonItem = [UIBarButtonItem initWithNormalImage:Pwhistory target:self action:@selector(rightHistoryBarButtonItemClick) width:22 height:22];
    
    UIBarButtonItem *rightSearchBarButtonItem = [UIBarButtonItem initWithNormalImage:Pwsearch target:self action:@selector(rightSearchBarButtonItemClick) width:22 height:22];
    
    
    self.navigationItem.rightBarButtonItems = @[rightSearchBarButtonItem,rightUploadBarButtonItem, rightHistoryBarButtonItem];
    
    
}
/*搜索*/
-(void)rightSearchBarButtonItemClick{
    JFSearchHistoryViewController *searchHistoryVC = [[JFSearchHistoryViewController alloc]init];
    [self.navigationController pushViewController:searchHistoryVC animated:YES];
    
}
-(void)rightHistoryBarButtonItemClick{
    JFWatchRecordViewController *watchRecordVC = [[JFWatchRecordViewController alloc]init];
    [self.navigationController pushViewController:watchRecordVC animated:YES];
    
}

#pragma mark - 初始化数据
-(void)initData{
    _dataSource = [[NSMutableArray alloc] init];
    _boxesSource = [[NSMutableArray alloc] init];
    _bannerSource = [[NSMutableArray alloc] init];
    _headImageArray = [[NSMutableArray alloc] init];
    
    NSString *urlStr =  [[GetUrlString sharedManager]urlWithHomeData];
    [NetEngine sendGetUrl:urlStr withParams:nil success:^(id responseBody) {
        [self.homeTableView.mj_header endRefreshing];
        [_headImageArray removeAllObjects];
        JFHomeModel *homeModel = [JFHomeModel mj_objectWithKeyValues:responseBody];
        NSMutableArray *boxesArray = [[NSMutableArray alloc] init];
        NSMutableArray *bannerArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < homeModel.boxes.count; i ++) {
            JFBoxesModel *boxesModel = [JFBoxesModel mj_objectWithKeyValues:homeModel.boxes[i]];
            boxesModel.height = [self getHeight:boxesModel];
            [boxesArray addObject:boxesModel];
        }
        for (int j = 0; j < homeModel.banner.count; j++) {
            JFBannerModel *bannerModel =[JFBannerModel mj_objectWithKeyValues:homeModel.banner[j]];
            [bannerArray addObject:bannerModel];
            [_headImageArray addObject:bannerModel.small_img];
        }
        
        _boxesSource = boxesArray;
        _bannerSource = bannerArray;
        [self.homeTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
#pragma amrk - 初始化视图
-(void)initView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH  -64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.homeTableView =  tableView;
    [self.view addSubview:self.homeTableView];
    
}
-(float)getHeight:(JFBoxesModel *)boxes{
    float height = 0;
    height = height + 40;
    if ([boxes.display_type intValue] == 1) {
        height = height + 2*150;
        return height+5;
    }else if([boxes.display_type intValue] == 2){
        height = height + 2*230;
        return height+5;
    }else{
        return height+5;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 180;
    }else{
        CGFloat height = ((JFBoxesModel *)_boxesSource[indexPath.row-1]).height;
        return height;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_bannerSource.count>0){
        return _boxesSource.count+1;
    }else{
        return 0;
    }
    
}
/*
 主界面的cell类型要根据土豆返回来的display_type ＝ 1 返回两列 display_type ＝ 2三列 类型进行判断处理
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JFImageScrollCell *cell = [JFImageScrollCell cellWithTableView:tableView frame:CGRectMake(0, 0, APPW, 180)];
        if (_headImageArray.count>0) {
            [cell setImageArray:_headImageArray];
        }
        return cell;
    }else{
        JFBoxesModel *box = _boxesSource[indexPath.row-1];
        if ([box.display_type intValue] == 1) {
            JFHomeBoxCell *cell = [JFHomeBoxCell cellWithTableView:tableView];
            [cell setBoxes:_boxesSource[indexPath.row-1]];
            cell.delegate = self;
            return cell;
        }
        else if([box.display_type intValue] == 2){
            JFHomeVideoBoxCell *cell = [JFHomeVideoBoxCell cellWithTableView:tableView];
            [cell setBoxes:box];
            return cell;
        }
        else{
            return nil;
        }
        
    }
    
}

#pragma mark - JFHomeBoxCellDelegate
-(void)didSelectHomeBox:(JFVideosModel *)video{
    
    JFVideoDetailViewController *videoDetailVC = [[JFVideoDetailViewController alloc]init];
    videoDetailVC.iid = video.iid;
    [self.navigationController pushViewController:videoDetailVC animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
