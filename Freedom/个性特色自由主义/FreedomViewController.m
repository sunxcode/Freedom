//  FreedomViewController.m
//  Freedom
//  Created by Super on 16/8/18.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "FreedomViewController.h"
#import "FreedomBooksViewController.h"
@interface FreedomViewCell : BaseCollectionViewOCCell
@end
@implementation FreedomViewCell
-(void)initUI{
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, APPW/5-20,40)];
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(0,YH(self.icon), APPW/5-12, 20)];
    self.title.font = fontnomal;self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubviews:self.title,self.icon,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = dict[@"name"];
    self.icon.image = [UIImage imageNamed:dict[@"pic"]];
}
@end
@interface FreedomViewController()<UICollectionViewDelegateFlowLayout>{
    NSArray *dataArray;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@end
@implementation FreedomViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个性特色自由主义";
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain actionBlick:^{}];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:Padd] style:UIBarButtonItemStyleDone actionBlick:^{}];
    self.navigationItem.leftBarButtonItem  = left;
    self.navigationItem.rightBarButtonItem = right;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((APPW-50)/4, 60);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(APPW, 30);layout.footerReferenceSize = CGSizeZero;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110) collectionViewLayout:layout];
    dataArray = [NSMutableArray arrayWithObjects:@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo}, nil];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = whitecolor;
    self.collectionView.frame = self.view.bounds;
    [self.view addSubview:self.collectionView];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight|UIRectEdgeBottom;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *log = [NSString stringWithFormat:@"你选择的是%zd，%zd", indexPath.section, indexPath.row];
    [SVProgressHUD showSuccessWithStatus:log];DLog(@"%@",log);
    [self pushController:[FreedomBooksViewController class] withInfo:dataArray[indexPath.row] withTitle:@"书籍详情" withOther:nil];
}
@end
