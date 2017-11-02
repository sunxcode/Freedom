//
//  TLContactsViewController.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLContactsViewController.h"
#import "TLSearchController.h"
#import "TLUserGroup.h"
#import "TLFriendHeaderView.h"
#import "TLContactCell.h"

@interface TLContactsViewController () <UISearchBarDelegate>

@property (nonatomic, strong) TLSearchController *searchController;

@end

@implementation TLContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"通讯录朋友"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:[UIColor colorBlackForNavBar]];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    [self registerCellClass];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [TLFriendHelper tryToGetAllContactsSuccess:^(NSArray *data, NSArray *formatData, NSArray *headers) {
        [SVProgressHUD dismiss];
        self.data = formatData;
        self.contactsData = data;
        self.headers = headers;
        [self.tableView reloadData];
        
        [MobClick event:@"e_get_contacts"];
    } failed:^{
        [SVProgressHUD dismiss];
        [UIAlertView bk_alertViewWithTitle:@"错误" message:@"未成功获取到通讯录信息"];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

#pragma mark - Getter -
- (TLSearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[TLSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索"];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}

- (TLContactsSearchViewController *)searchVC
{
    if (_searchVC == nil) {
        _searchVC = [[TLContactsSearchViewController alloc] init];
    }
    return _searchVC;
}

- (void)registerCellClass
{
    [self.tableView registerClass:[TLFriendHeaderView class] forHeaderFooterViewReuseIdentifier:@"TLFriendHeaderView"];
    [self.tableView registerClass:[TLContactCell class] forCellReuseIdentifier:@"TLContactCell"];
}

#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TLUserGroup *group = [self.data objectAtIndex:section];
    return group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLContact *contact = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    TLContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLContactCell"];
    [cell setContact:contact];
    if (indexPath.section == self.data.count - 1 && indexPath.row == [self.data[indexPath.section] count] - 1) {
        [cell setBottomLineStyle:TLCellLineStyleFill];
    }
    else {
        [cell setBottomLineStyle:(indexPath.row == [self.data[indexPath.section] count] - 1 ? TLCellLineStyleNone : TLCellLineStyleDefault)];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TLUserGroup *group = [self.data objectAtIndex:section];
    TLFriendHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLFriendHeaderView"];
    [view setTitle:group.groupName];
    return view;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.headers;
}

//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchVC setContactsData:self.contactsData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

@end
