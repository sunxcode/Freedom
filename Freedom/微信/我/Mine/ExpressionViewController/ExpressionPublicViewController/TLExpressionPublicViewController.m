//
//  TLExpressionPublicViewController.m
//  TLChat
//
//  Created by 李伯坤 on 16/4/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLExpressionPublicViewController.h"
#import "TLExpressionSearchViewController.h"
#import "TLSearchController.h"
#import "MJRefresh.h"
#import "TLExpressionDetailViewController.h"
#import "TLExpressionPublicCell.h"

#define         EDGE                20.0
#define         SPACE_CELL          EDGE
#define         WIDTH_CELL          ((WIDTH_SCREEN - EDGE * 2 - SPACE_CELL * 2.0) / 3.0)
#define         HEIGHT_CELL         (WIDTH_CELL + 20)
#import "TLExpressionHelper.h"
#import "MJRefresh.h"

@interface TLExpressionPublicViewController () <UISearchBarDelegate>

@property (nonatomic, strong) TLSearchController *searchController;
@property (nonatomic, strong) TLExpressionSearchViewController *searchVC;

@end

@implementation TLExpressionPublicViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view addSubview:self.collectionView];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
//    [self.collectionView setTableHeaderView:self.searchController.searchBar];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [self.collectionView setMj_footer:footer];
    
    [self registerCellForCollectionView:self.collectionView];
    [self loadDataWithLoadingView:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - # Delegate
//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - # Getter
- (TLSearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[TLSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索表情"];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}

- (TLExpressionSearchViewController *)searchVC
{
    if (_searchVC == nil) {
        _searchVC = [[TLExpressionSearchViewController alloc] init];
    }
    return _searchVC;
}

- (TLExpressionProxy *)proxy
{
    if (_proxy == nil) {
        _proxy = [[TLExpressionProxy alloc] init];
    }
    return _proxy;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGRect rect = CGRectMake(0, HEIGHT_NAVBAR + HEIGHT_STATUSBAR, WIDTH_SCREEN, HEIGHT_SCREEN - HEIGHT_NAVBAR - HEIGHT_STATUSBAR);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setAlwaysBounceVertical:YES];
    }
    return _collectionView;
}

- (void)registerCellForCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerClass:[TLExpressionPublicCell class] forCellWithReuseIdentifier:@"TLExpressionPublicCell"];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EmptyCell"];
}

#pragma mark - # Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count == 0 ? 1 : self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.data.count) {
        TLExpressionPublicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLExpressionPublicCell" forIndexPath:indexPath];
        TLEmojiGroup *emojiGroup = [self.data objectAtIndex:indexPath.row];
        [cell setGroup:emojiGroup];
        return cell;
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"EmptyCell" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.data.count) {
        TLEmojiGroup *group = [self.data objectAtIndex:indexPath.row];
        TLExpressionDetailViewController *detailVC = [[TLExpressionDetailViewController alloc] init];
        [detailVC setGroup:group];
        [self.parentViewController setHidesBottomBarWhenPushed:YES];
        [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.data.count) {
        return CGSizeMake(WIDTH_CELL, HEIGHT_CELL);
    }
    return collectionView.bounds.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.data.count == 0 ? 0 : SPACE_CELL;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.data.count == 0 ? 0 : SPACE_CELL;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.data.count == 0 ? UIEdgeInsetsMake(0, 0, 0, 0) : UIEdgeInsetsMake(EDGE, EDGE, EDGE, EDGE);
}

- (void)loadDataWithLoadingView:(BOOL)showLoadingView
{
    if (showLoadingView) {
        [SVProgressHUD show];
    }
    kPageIndex = 1;
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionPublicListByPageIndex:kPageIndex success:^(id data) {
        [SVProgressHUD dismiss];
        kPageIndex ++;
        weakSelf.data = [[NSMutableArray alloc] init];
        for (TLEmojiGroup *group in data) {     // 优先使用本地表情
            TLEmojiGroup *localEmojiGroup = [[TLExpressionHelper sharedHelper] emojiGroupByID:group.groupID];
            if (localEmojiGroup) {
                [self.data addObject:localEmojiGroup];
            }
            else {
                [self.data addObject:group];
            }
        }
        [weakSelf.collectionView reloadData];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)loadMoreData
{
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionPublicListByPageIndex:kPageIndex success:^(NSMutableArray *data) {
        [SVProgressHUD dismiss];
        if (data.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        else {
            [self.collectionView.mj_footer endRefreshing];
            kPageIndex ++;
            for (TLEmojiGroup *group in data) {     // 优先使用本地表情
                TLEmojiGroup *localEmojiGroup = [[TLExpressionHelper sharedHelper] emojiGroupByID:group.groupID];
                if (localEmojiGroup) {
                    [self.data addObject:localEmojiGroup];
                }
                else {
                    [self.data addObject:group];
                }
            }
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSString *error) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD dismiss];
    }];
}
@end
