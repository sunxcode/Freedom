//  TLFriendsViewController.m
//  Freedom
// Created by Super
#import "TLFriendsViewController.h"
#import "TLSearchController.h"
#import "TLAddFriendViewController.h"
#import "TLFriendHeaderView.h"
#import "TLFriendCell.h"
#import "TLFriendHelper.h"
#import "TLNewFriendViewController.h"
#import "TLGroupViewController.h"
#import "TLTagsViewController.h"
#import "TLPublicServerViewController.h"
#import "TLFriendDetailViewController.h"
@interface TLFriendsViewController ()
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) TLFriendHelper *friendHelper;
@property (nonatomic, strong) TLSearchController *searchController;
@end
@implementation TLFriendsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"通讯录"];
    
    [self p_initUI];        // 初始化界面UI
    [self registerCellClass];
    
    self.friendHelper = [TLFriendHelper sharedFriendHelper];      // 初始化好友数据业务类
    self.data = self.friendHelper.data;
    self.sectionHeaders = self.friendHelper.sectionHeaders;
    [self.footerLabel setText:[NSString stringWithFormat:@"%ld位联系人", (long)self.friendHelper.friendCount]];
    
    __weak typeof(self) weakSelf = self;
    [self.friendHelper setDataChangedBlock:^(NSMutableArray *data, NSMutableArray *headers, NSInteger friendCount) {
        weakSelf.data = data;
        weakSelf.sectionHeaders = headers;
        [weakSelf.footerLabel setText:[NSString stringWithFormat:@"%ld位联系人", (long)friendCount]];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    TLAddFriendViewController *addFriendVC = [[TLAddFriendViewController alloc] init];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addFriendVC animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}
#pragma mark - Private Methods -
- (void)p_initUI{
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.tableView setSeparatorColor:colorGrayLine];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    [self.tableView setTableFooterView:self.footerLabel];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_friend"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}
#pragma mark - Getter -
- (TLSearchController *)searchController{
    if (_searchController == nil) {
        _searchController = [[TLSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索"];
        [_searchController.searchBar setDelegate:self];
        [_searchController setShowVoiceButton:YES];
    }
    return _searchController;
}
- (TLFriendSearchViewController *)searchVC{
    if (_searchVC == nil) {
        _searchVC = [[TLFriendSearchViewController alloc] init];
    }
    return _searchVC;
}
- (UILabel *)footerLabel{
    if (_footerLabel == nil) {
        _footerLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 50.0f)];
        [_footerLabel setTextAlignment:NSTextAlignmentCenter];
        [_footerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_footerLabel setTextColor:[UIColor grayColor]];
    }
    return _footerLabel;
}
#pragma mark - Public Methods -
- (void)registerCellClass{
    [self.tableView registerClass:[TLFriendHeaderView class] forHeaderFooterViewReuseIdentifier:@"TLFriendHeaderView"];
    [self.tableView registerClass:[TLFriendCell class] forCellReuseIdentifier:@"TLFriendCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TLUserGroup *group = [self.data objectAtIndex:section];
    return group.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    TLUserGroup *group = [self.data objectAtIndex:section];
    TLFriendHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLFriendHeaderView"];
    [view setTitle:group.groupName];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TLFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLFriendCell"];
    TLUserGroup *group = [self.data objectAtIndex:indexPath.section];
    TLUser *user = [group objectAtIndex:indexPath.row];
    [cell setUser:user];
    
    if (indexPath.section == self.data.count - 1 && indexPath.row == group.count - 1){  // 最后一个cell，底部全线
        [cell setBottomLineStyle:TLCellLineStyleFill];
    }else{
        [cell setBottomLineStyle:indexPath.row == group.count - 1 ? TLCellLineStyleNone : TLCellLineStyleDefault];
    }
    
    return cell;
}
// 拼音首字母检索
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionHeaders;
}
// 检索时空出搜索框
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if(index == 0) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, tableView.frameWidth, tableView.frameHeight) animated:NO];
        return -1;
    }
    return index;
}
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_FRIEND_CELL;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return HEIGHT_HEADER;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TLUser *user = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        if ([user.userID isEqualToString:@"-1"]) {
            TLNewFriendViewController *newFriendVC = [[TLNewFriendViewController alloc] init];
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:newFriendVC animated:YES];
            [self setHidesBottomBarWhenPushed:NO];
        }else if ([user.userID isEqualToString:@"-2"]) {
            TLGroupViewController *groupVC = [[TLGroupViewController alloc] init];
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:groupVC animated:YES];
            [self setHidesBottomBarWhenPushed:NO];
        }else if ([user.userID isEqualToString:@"-3"]) {
            TLTagsViewController *tagsVC = [[TLTagsViewController alloc] init];
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:tagsVC animated:YES];
            [self setHidesBottomBarWhenPushed:NO];
        }else if ([user.userID isEqualToString:@"-4"]) {
            TLPublicServerViewController *publicServer = [[TLPublicServerViewController alloc] init];
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:publicServer animated:YES];
            [self setHidesBottomBarWhenPushed:NO];
        }
    }else{
        TLFriendDetailViewController *detailVC = [[TLFriendDetailViewController alloc] init];
        [detailVC setUser:user];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchVC setFriendsData:[TLFriendHelper sharedFriendHelper].friendsData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.tabBarController.tabBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"语音搜索按钮" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
@end
