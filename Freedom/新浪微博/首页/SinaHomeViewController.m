
#import "SinaHomeViewController.h"
#import "SinaAuthController.h"
@interface SinaUser : NSObject
/**    string    字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;
/**    string    友好显示名称*/
@property (nonatomic, copy) NSString *name;
/**    string    用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;
/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;
@property (nonatomic, assign, getter = isVip) BOOL vip;
/** 认证类型 */
@property (nonatomic, assign) int verified_type;
@end
@interface SinaStatus : NSObject
/**    string    字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;
/**    string    微博信息内容*/
@property (nonatomic, copy) NSString *text;
/**    object    微博作者的用户信息字段 详细*/
@property (nonatomic, strong) SinaUser *user;
/**    string    微博创建时间*/
@property (nonatomic, copy) NSString *created_at;
/**    string    微博来源*/
@property (nonatomic, copy) NSString *source;
/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;
/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
@property (nonatomic, strong) SinaStatus *retweeted_status;
/**    int    转发数*/
@property (nonatomic, assign) int reposts_count;
/**    int    评论数*/
@property (nonatomic, assign) int comments_count;
/**    int    表态数*/
@property (nonatomic, assign) int attitudes_count;
@end
@interface SinaStatusViewCell : UITableViewCell
/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) UIImageView *photosView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;
/* 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) UILabel *retweetContentLabel;
/** 转发配图 */
@property (nonatomic, weak) UIImageView *retweetPhotosView;
/** 工具条 */
@property (nonatomic, weak) UIView *toolbar;
@property (nonatomic,strong) SinaStatus *status;
@end
@implementation SinaUser
@end
@implementation SinaStatus
@end
@implementation SinaStatusViewCell
@end


@interface SinaHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray<SinaStatus*> *list;
@end
@implementation SinaHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = [NSMutableArray arrayWithCapacity:10];
    self.title = [SinaAccount account].name;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH - TopHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"u_personAdd"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"u_scan"] style:UIBarButtonItemStylePlain target:nil action:nil];
    // 设置图片和文字
    NSString *url = @"https://api.weibo.com/2/users/show.json";
    SinaAccount *account = [SinaAccount account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    [Net GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *name = responseObject[@"name"];
        self.title = name;
        account.name = name;
        [SinaAccount saveAccount:account];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(refreshStatus:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    [refresh beginRefreshing];
    [[AFHTTPSessionManager manager] GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [responseObject[@"status"] description];
        self.tabBarItem.badgeValue = status;
        [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

/*UIRefreshControl进入刷新状态：加载最新的数据*/
-(void)refreshStatus:(UIRefreshControl *)control {
    NSString *url = @"https://api.weibo.com/2/statuses/friends_timeline.json";
     SinaAccount *account = [SinaAccount account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"since_id"] = @0;
    [[AFHTTPSessionManager manager] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *newStatuses = [SinaStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        [self.list addObjectsFromArray:newStatuses];
        [self.tableView reloadData];
        [control endRefreshing];
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
// 加载更多的微博数据
-(void)loadMoreStatus {
    SinaAccount *account = [SinaAccount account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"max_id"] = @(0);
    [[AFHTTPSessionManager manager] GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *newStatuses = [SinaStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        [self.list addObjectsFromArray:newStatuses];
        [self.tableView reloadData];
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}
//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"status";
    SinaStatusViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SinaStatusViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        [cell.originalView addSubviews:cell.iconView,cell.vipView,cell.photosView,cell.nameLabel,cell.timeLabel,cell.sourceLabel,cell.contentLabel,cell.retweetContentLabel,cell.retweetPhotosView,nil];
        [cell.contentView addSubviews:cell.originalView,cell.retweetView,cell.toolbar,nil];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
@end
