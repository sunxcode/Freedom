//  TLPublicServerViewController.m
//  Freedom
// Created by Super
#import "WXPublicServerViewController.h"
#import "WXPublicServerSearchViewController.h"
#import "WechatSearchController.h"
@interface WXPublicServerViewController () <UISearchBarDelegate>
@property (nonatomic, strong) WechatSearchController *searchController;
@property (nonatomic, strong) WXPublicServerSearchViewController *searchVC;
@end
@implementation WXPublicServerViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"公众号"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    [self.tableView setTableHeaderView:self.searchController.searchBar];
}
#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
}
#pragma mark - Delegate -
//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
#pragma mark - Getter -
- (WechatSearchController *)searchController{
    if (_searchController == nil) {
        _searchController = [[WechatSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索"];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}
- (WXPublicServerSearchViewController *)searchVC{
    if (_searchVC == nil) {
        _searchVC = [[WXPublicServerSearchViewController alloc] init];
    }
    return _searchVC;
}
@end
