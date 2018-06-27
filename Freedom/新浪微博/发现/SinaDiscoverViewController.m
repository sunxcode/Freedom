//  XFDiscoverViewController.m
//  Freedom
//  Created by Super on 15/9/13.
#import "SinaDiscoverViewController.h"
@implementation SinaDiscoverViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tableView属性
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 375, 30)];
    self.navigationItem.titleView = searchBar;
    searchBar.placeholder = @"大家都在搜：男模遭趴光";

}
@end
