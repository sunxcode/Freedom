//  TLExpressionChosenViewController.m
//  Freedom
//  Created by Super on 16/4/4.
#import "TLExpressionChosenViewController.h"
#import "TLExpressionSearchViewController.h"
#import "TLSearchController.h"
#import "MJRefresh.h"
#import "TLExpressionDetailViewController.h"
#import "TLExpressionHelper.h"
#import "MJRefresh.h"
#import "TLPictureCarouselView.h"
@interface TLExpressionBannerCell () <TLPictureCarouselDelegate>
@property (nonatomic, strong) TLPictureCarouselView *picCarouselView;
@end
@implementation TLExpressionBannerCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBottomLineStyle:TLCellLineStyleNone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.picCarouselView];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setData:(NSArray *)data{
    _data = data;
    [self.picCarouselView setData:data];
}
#pragma mark - 
- (void)pictureCarouselView:(TLPictureCarouselView *)pictureCarouselView didSelectItem:(id<TLPictureCarouselProtocol>)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(expressionBannerCellDidSelectBanner:)]) {
        [self.delegate expressionBannerCellDidSelectBanner:model];
    }
}
#pragma mark - 
- (void)p_addMasonry{
    [self.picCarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
#pragma mark - 
- (TLPictureCarouselView *)picCarouselView{
    if (_picCarouselView == nil) {
        _picCarouselView = [[TLPictureCarouselView alloc] init];
        [_picCarouselView setDelegate:self];
    }
    return _picCarouselView;
}
@end
@interface TLExpressionChosenViewController () <UISearchBarDelegate>
@property (nonatomic, strong) TLSearchController *searchController;
@property (nonatomic, strong) TLExpressionSearchViewController *searchVC;
@end
@implementation TLExpressionChosenViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.tableView setFrame:CGRectMake(0, HEIGHT_NAVBAR + HEIGHT_STATUSBAR, WIDTH_SCREEN, HEIGHT_SCREEN - HEIGHT_STATUSBAR - HEIGHT_NAVBAR)];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [self.tableView setMj_footer:footer];
    
    [self registerCellsForTableView:self.tableView];
    [self loadDataWithLoadingView:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}
#pragma mark - 
- (TLExpressionProxy *)proxy{
    if (_proxy == nil) {
        _proxy = [[TLExpressionProxy alloc] init];
    }
    return _proxy;
}
- (TLSearchController *)searchController{
    if (_searchController == nil) {
        _searchController = [[TLSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索表情"];
        [_searchController.searchBar setDelegate:self.searchVC];
    }
    return _searchController;
}
- (TLExpressionSearchViewController *)searchVC{
    if (_searchVC == nil) {
        _searchVC = [[TLExpressionSearchViewController alloc] init];
    }
    return _searchVC;
}
- (void)loadDataWithLoadingView:(BOOL)showLoadingView{
    if (showLoadingView) {
        [SVProgressHUD show];
    }
    kPageIndex = 1;
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionChosenListByPageIndex:kPageIndex success:^(id data) {
        [SVProgressHUD dismiss];
        kPageIndex ++;
        weakSelf.data = [[NSMutableArray alloc] init];
        for (TLEmojiGroup *group in data) {     // 优先使用本地表情
            TLEmojiGroup *localEmojiGroup = [[TLExpressionHelper sharedHelper] emojiGroupByID:group.groupID];
            if (localEmojiGroup) {
                [self.data addObject:localEmojiGroup];
            }else{
                [self.data addObject:group];
            }
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    
    [self.proxy requestExpressionChosenBannerSuccess:^(id data) {
        self.bannerData = data;
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}
- (void)loadMoreData{
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionChosenListByPageIndex:kPageIndex success:^(NSMutableArray *data) {
        [SVProgressHUD dismiss];
        if (data.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
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
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSString *error) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD dismiss];
    }];
}
- (void)registerCellsForTableView:(UITableView *)tableView{
    [tableView registerClass:[TLExpressionBannerCell class] forCellReuseIdentifier:@"TLExpressionBannerCell"];
    [tableView registerClass:[TLExpressionCell class] forCellReuseIdentifier:@"TLExpressionCell"];
}
#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.bannerData.count > 0 ? 2 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.bannerData.count > 0 ? 1 : self.data.count;
    }else if (section == 1) {
        return self.data.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && self.bannerData.count > 0) {
        TLExpressionBannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:@"TLExpressionBannerCell"];
        [bannerCell setData:self.bannerData];
        [bannerCell setDelegate:self];
        return bannerCell;
    }
    TLExpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLExpressionCell"];
    TLEmojiGroup *group = self.data[indexPath.row];
    [cell setGroup:group];
    [cell setDelegate:self];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && self.bannerData.count == 0) || indexPath.section == 1) {
        TLEmojiGroup *group = [self.data objectAtIndex:indexPath.row];
        TLExpressionDetailViewController *detailVC = [[TLExpressionDetailViewController alloc] init];
        [detailVC setGroup:group];
        [self.parentViewController setHidesBottomBarWhenPushed:YES];
        [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.bannerData.count > 0 ? HEIGHT_BANNERCELL : HEGIHT_EXPCELL;
    }else if (indexPath.section == 1) {
        return HEGIHT_EXPCELL;
    }
    return 0;
}
//MARK: TLExpressionBannerCellDelegate
- (void)expressionBannerCellDidSelectBanner:(id)item{
    TLExpressionDetailViewController *detailVC = [[TLExpressionDetailViewController alloc] init];
    [detailVC setGroup:item];
    [self.parentViewController setHidesBottomBarWhenPushed:YES];
    [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
}
//MARK: TLExpressionCellDelegate
- (void)expressionCellDownloadButtonDown:(TLEmojiGroup *)group{
    group.status = TLEmojiGroupStatusDownloading;
    [self.proxy requestExpressionGroupDetailByGroupID:group.groupID pageIndex:1 success:^(id data) {
        group.data = data;
        [[TLExpressionHelper sharedHelper] downloadExpressionsWithGroupInfo:group progress:^(CGFloat progress) {
            
        } success:^(TLEmojiGroup *group) {
            group.status = TLEmojiGroupStatusDownloaded;
            NSInteger index = [self.data indexOfObject:group];
            if (index < self.data.count) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
            BOOL ok = [[TLExpressionHelper sharedHelper] addExpressionGroup:group];
            if (!ok) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"表情 %@ 存储失败！", group.groupName]];
            }
        } failure:^(TLEmojiGroup *group, NSString *error) {
            
        }];
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"\"%@\" 下载失败: %@", group.groupName, error]];
    }];
}
@end
