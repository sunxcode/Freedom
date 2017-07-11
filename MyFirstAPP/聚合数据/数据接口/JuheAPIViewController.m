#import "JuheAPIViewController.h"
#import "JuheAPIDetailViewController.h"

@interface JuheAPICollectionViewCell : BaseCollectionViewCell{
    NSMutableDictionary *thumbnailCache;
}
@end
@implementation JuheAPICollectionViewCell
-(void)initUI{
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, W(self)-20,W(self)-20)];
    self.icon.layer.cornerRadius = 10;
    self.icon.clipsToBounds = YES;
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, YH(self.icon), W(self.icon), 20)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = fontnomal;
    [self addSubviews:self.icon,self.title,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = dict[@"name"];
    NSString *imgURL = [dict valueForKey:@"pic"];
    __block UIImage *imageProduct = [thumbnailCache objectForKey:imgURL];
    if(imageProduct){
        self.icon.image = imageProduct;
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageNamed:imgURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.icon.image = image;
                [thumbnailCache setValue:image forKey:imgURL];
            });
        });
    }
}
@end
@interface JuheAPIViewController(){
    BaseScrollView *banner;
}
@end
@implementation JuheAPIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}
#pragma mark 搭建UI界面
-(void)buildUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addstore_icon_add@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = more;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入想要查找的接口";
    self.navigationItem.titleView = searchBar;
    
    banner = [[BaseScrollView alloc]initWithFrame:CGRectMake(0,0, APPW, 120)];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type", nil];
    [Net GET:GETBanner parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *adViewArr = responseObject[@"data"][@"list"];
        if (adViewArr != nil && adViewArr.count > 0) {
            NSMutableArray *urls = [NSMutableArray arrayWithCapacity:10];
            for(int i=0;i<adViewArr.count;i++){
                NSString *url = [adViewArr[i] objectForJSONKey:@"pic"];
                [urls addObject:url];
            }
            [banner setWithTitles:nil icons:urls round:NO size:CGSizeZero type:MyScrollBanner controllers:nil selectIndex:^(NSInteger index, NSDictionary *dict) {
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:alertErrorTxt];
    }];
    
    BaseCollectionViewLayout *layout = [BaseCollectionViewLayout sharedFlowlayoutWithCellSize:CGSizeMake((APPW-50)/4, 90) groupInset:UIEdgeInsetsMake(YH(banner)+10, 10, 0, 10) itemSpace:10 linespace:10];
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-100) collectionViewLayout:layout];
    self.collectionView.dataArray = [NSMutableArray arrayWithObjects:
  @{@"name":@"IP地址",@"pic":@"juheintopublic"},@{@"name":@"手机号码归属地",@"pic":@"juhelookhistory"},@{@"name":@"身份证查询",@"pic":@"juheaboutus"},@{@"name":@"常用快递",@"pic":@"juhechart"},
  @{@"name":@"餐饮美食",@"pic":@"juhechart"},@{@"name":@"菜谱大全",@"pic":@"juhechart"},@{@"name":@"彩票开奖结果",@"pic":@"juhechart"},@{@"name":@"邮编查询",@"pic":@"juhechart"},
  @{@"name":@"律师查询",@"pic":@"juhechart"},@{@"name":@"笑话大全",@"pic":@"juhechart"},@{@"name":@"小说大全",@"pic":@"juhechart"},@{@"name":@"恋爱物语",@"pic":@"juhechart"},
  @{@"name":@"商品比价",@"pic":@"juhechart"},@{@"name":@"新闻",@"pic":@"juhechart"},@{@"name":@"微信精选",@"pic":@"juhechart"},@{@"name":@"经典日至",@"pic":@"juhechart"},
  @{@"name":@"天气查询",@"pic":@"juhechart"},@{@"name":@"手机话费",@"pic":@"juhechart"},@{@"name":@"个人缴费",@"pic":@"juhechart"},@{@"name":@"移动出行",@"pic":@"juhechart"},
  @{@"name":@"足球赛事",@"pic":@"juhechart"},@{@"name":@"新闻资讯",@"pic":@"juhechart"},@{@"name":@"视频播放",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"}, nil];
    [self fillTheCollectionViewDataWithCanMove:NO sectionN:1 itemN:20 itemName:@"JuheAPICollectionViewCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView addSubview:banner];
    [self.view addSubviews:self.collectionView,nil];
}

-(void)moreAction{
    DLog(@"更多");
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self pushController:[JuheAPIDetailViewController class] withInfo:self.collectionView.dataArray[indexPath.row] withTitle:self.collectionView.dataArray[indexPath.row][@"name"]];
}
@end





