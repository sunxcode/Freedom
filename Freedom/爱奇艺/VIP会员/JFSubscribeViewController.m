//  JFSubscribeViewController.m
//  Freedom
//  Created by Freedom on 15/10/9.
#import "JFSubscribeViewController.h"
#import "JFVideoDetailViewController.h"
@interface JFSubItemModel : NSObject
@property(nonatomic, strong) NSNumber *itemID;
@property(nonatomic, strong) NSString *formatTotalTime;
@property(nonatomic, strong) NSString *code;
@property(nonatomic, strong) NSNumber *totalTime;
@property(nonatomic, strong) NSNumber *pubDate;
@property(nonatomic, strong) NSString *playLink;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *userpic_220_220;
@property(nonatomic, strong) NSNumber *playNum;
@property(nonatomic, strong) NSString *bigPic;
@property(nonatomic, strong) NSNumber *limit;
@property(nonatomic, strong) NSString *picurl;
@property(nonatomic, strong) NSNumber *playtimes;
@property(nonatomic, strong) NSString *userpic;
@property(nonatomic, strong) NSString *formatPubDate;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSNumber *uid;
@end
@interface JFSubscribeModel : NSObject
@property(nonatomic, strong) NSNumber *video_count;
@property(nonatomic, strong) NSString *Description;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *channelized_type;
@property(nonatomic, strong) NSString *subed_count;
@property(nonatomic, strong) NSMutableArray *last_item;
@property(nonatomic, strong) NSString *podcast_user_id;
@property(nonatomic, strong) NSString *isVuser;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *avatar;
@end
@class JFSubscribeModel,JFSubscribeCell,JFSubItemModel;
@protocol JFSubscribeCellDelagate <NSObject>
-(void)didSelectSubscribeCell:(JFSubscribeCell *)subCell subItem:(JFSubItemModel *)subItem;
@end
@interface JFSubscribeCell : UITableViewCell
@property(nonatomic, strong)JFSubscribeModel *subscribeM;
@property(nonatomic, weak)id <JFSubscribeCellDelagate>delegate;
@end

@implementation JFSubItemModel
@end
@implementation JFSubscribeModel
@end
@class JFSubScribeCardView,JFSubItemModel;
@protocol JFSubImageScrollViewDelegate <NSObject>
@optional
-(void)didSelectSubScrollView:(JFSubScribeCardView *)subScrollView subItem:(JFSubItemModel *)subItem;
@end
@interface JFSubImageScrollView : UIView
@property(nonatomic, weak) id <JFSubImageScrollViewDelegate>delegate;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSArray *dataArray;
@end
@class JFSubItemModel,JFSubScribeCardView;
@protocol JFSubScribeCardViewDelegate <NSObject>
-(void)didSelectSubImageCard:(JFSubScribeCardView *)subImageCard subItem:(JFSubItemModel *)subItem;
@end
@interface JFSubScribeCardView : UIView
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *cardImageView;
@property (strong, nonatomic) UILabel *cardLabel;
@property(nonatomic, strong) JFSubItemModel *subItem;
@property(nonatomic, weak) id<JFSubScribeCardViewDelegate>delegate;
@end
@implementation JFSubScribeCardView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
        self.cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 200, 20)];
        [self addSubviews:self.cardImageView,self.cardLabel,nil];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, frame.size.width-5, frame.size.height-30)];
        [self addSubview:self.imageView];
        
        //
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height-30, frame.size.width-5, 30)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor blackColor];
        //        self.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self addSubview:self.titleLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapImageCard:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
-(void)setSubItem:(JFSubItemModel *)subItem{
    _subItem = subItem;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:subItem.picurl] placeholderImage:[UIImage imageNamed:@"rec_holder"]];
    self.titleLabel.text = subItem.title;
    //    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:subItem.picurl]  placeholderImage:[UIImage imageNamed:@"rec_holder"]];
    //    self.cardLabel .text = subItem.title;
}
-(void)TapImageCard:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectSubImageCard:subItem:)]) {
        [self.delegate didSelectSubImageCard:self subItem:self.subItem];
    }
}
@end
@interface JFSubImageScrollView ()<JFSubScribeCardViewDelegate>
@end
@implementation JFSubImageScrollView
-(JFSubImageScrollView*)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.contentSize = CGSizeMake(2*APPW, frame.size.height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        //card
        float cardWidth = (APPW*2-15)/3;
        
        for (int i = 0; i < 3; i++) {
            JFSubScribeCardView *card = [[JFSubScribeCardView alloc] initWithFrame:CGRectMake(cardWidth*i, 0, cardWidth, frame.size.height)];
            
            card.frame = CGRectMake((cardWidth+5)*i +5, 0, cardWidth, frame.size.height);
            card.tag = 20+i;
            [self.scrollView addSubview:card];
            card.delegate = self;
        }
    }
    return self;
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    for (int i = 0; i < 3; i++) {
        JFSubItemModel *item = dataArray[i];
        JFSubScribeCardView *card = (JFSubScribeCardView *)[self.scrollView viewWithTag:20+i];
        [card setSubItem:item];
    }
}
-(void)didSelectSubImageCard:(JFSubScribeCardView *)subImageCard subItem:(JFSubItemModel *)subItem{
    if ([self.delegate respondsToSelector:@selector(didSelectSubScrollView:subItem:)]) {
        [self.delegate didSelectSubScrollView:subImageCard subItem:subItem];
    }
}
@end
@interface JFSubscribeCell ()<JFSubImageScrollViewDelegate>{
    NSMutableArray *_items;
    JFSubImageScrollView *_scrollV;
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_subedLabel;
    UIButton *_dingyueBtn;
}
@end
@implementation JFSubscribeCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        [self initViews];
    }
    return self;
}
-(void)initViews{
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 210)];
    backview.backgroundColor = [UIColor whiteColor];
    [self addSubview:backview];
    
    //
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    _imageView.layer.cornerRadius = 20;
    _imageView.layer.masksToBounds = YES;
    [backview addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 120, 25)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    [backview addSubview:_titleLabel];
    
    _subedLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 25, 120, 25)];
    _subedLabel.font = [UIFont systemFontOfSize: 12];
    _subedLabel.textColor = [UIColor lightGrayColor];
    [backview addSubview:_subedLabel];
    
    _dingyueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dingyueBtn.frame = CGRectMake(APPW-10-70, 10, 70, 29);
    [_dingyueBtn setImage:[UIImage imageNamed:@"search_channel_subscribe_noPlay"] forState:UIControlStateNormal];
    [_dingyueBtn setImage:[UIImage imageNamed:@"search_channel_subscribed"] forState:UIControlStateSelected];
    [backview addSubview:_dingyueBtn];
    
    //
    _scrollV = [[JFSubImageScrollView alloc] initWithFrame:CGRectMake(0, 55, APPW, 155)];
    _scrollV.delegate = self;
    [backview addSubview:_scrollV];
    
}
-(void)setSubscribeM:(JFSubscribeModel *)subscribeM{
    _subscribeM = subscribeM;
    [_items removeAllObjects];
    for (int i = 0; i < subscribeM.last_item.count; i++) {
        JFSubItemModel *item = [JFSubItemModel mj_objectWithKeyValues:subscribeM.last_item[i]];
        [_items addObject:item];
    }
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:subscribeM.image] placeholderImage:[UIImage imageNamed:@"rec_holder"]];
    _titleLabel.text = subscribeM.title;
    _subedLabel.text = [NSString stringWithFormat:@"订阅 %@", subscribeM.subed_count];
    [_scrollV setDataArray:_items];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)didSelectSubScrollView:(JFSubScribeCardView *)subScrollView subItem:(JFSubItemModel *)subItem{
    if ([self.delegate respondsToSelector:@selector(didSelectSubscribeCell:subItem:)]) {
        [self.delegate didSelectSubscribeCell:self subItem:subItem];
    }
    
}
@end

@interface JFSubscribeViewController ()<UITableViewDataSource,UITableViewDelegate,JFSubscribeCellDelagate>{
    NSMutableArray *_dataSource;
}
@property (nonatomic, strong) UITableView *subscribeTableView;
@end
@implementation JFSubscribeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initView];
    [self setUpRefresh];
    
}
#pragma mark - 设置普通模式下啦刷新
-(void)setUpRefresh{
    self.subscribeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [self.subscribeTableView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
-(void)initNav{
    self.title = @"订阅推荐";
    _dataSource = [[NSMutableArray alloc] init];
}
-(void)initData{
    NSString *urlStr = [[FreedomTools sharedManager]urlWithSubscribeData];
    
    [NetBase GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.subscribeTableView.mj_header endRefreshing];
        NSMutableArray *array = [responseObject objectForKey:@"results"];
        for (int i = 0; i < array.count; i++) {
            JFSubscribeModel *subM = [JFSubscribeModel mj_objectWithKeyValues:array[i]];
            [_dataSource addObject:subM];
            
        }
        [self.subscribeTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)initView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH  -64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.subscribeTableView =  tableView;
    [self.view addSubview:self.subscribeTableView];
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 215;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"JFSubscribeCell";
    JFSubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[JFSubscribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.delegate = self;
    
    JFSubscribeModel *subM = [_dataSource objectAtIndex:indexPath.row];    
    [cell setSubscribeM:subM];
    
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didSelectSubscribeCell:(JFSubscribeCell *)subCell subItem:(JFSubItemModel *)subItem{
    JFVideoDetailViewController *videoDetailVC = [[JFVideoDetailViewController alloc]init];
    videoDetailVC.iid = subItem.code;
    [self.navigationController pushViewController:videoDetailVC animated:YES];
    
}
@end
