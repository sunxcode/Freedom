//
//  MyDatabaseViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/18.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "MyDatabaseViewController.h"
#import "MyDatabaseEditViewController.h"
@interface DatabaseCollectionViewCell : BaseCollectionViewCell
@end
@implementation DatabaseCollectionViewCell
-(void)initUI{
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, APPW/5-20,40)];
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(0,YH(self.icon), APPW/5-12, 20)];
    self.title.font = fontnomal;self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubviews:self.title,self.icon,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = @"蚂蚁花呗";
    self.icon.image = [UIImage imageNamed:@"taobaomini1"];
}
@end
@interface MyDatabaseViewController()<UICollectionViewDelegateFlowLayout>{}
@end
@implementation MyDatabaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个性特色自由主义";
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain actionBlick:^{}];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:Padd] style:UIBarButtonItemStyleDone actionBlick:^{}];
    self.navigationItem.leftBarButtonItem  = left;
    self.navigationItem.rightBarButtonItem = right;
    BaseCollectionViewLayout *layout = [BaseCollectionViewLayout sharedFlowlayoutWithCellSize:CGSizeMake((APPW-50)/4, 60) groupInset:UIEdgeInsetsMake(0, 10, 0, 10) itemSpace:10 linespace:10];
    layout.headerReferenceSize = CGSizeMake(APPW, 30);layout.footerReferenceSize = CGSizeZero;
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110) collectionViewLayout:layout];
    self.collectionView.dataArray = [NSMutableArray arrayWithObjects:@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"},@{@"name":@"流量充值",@"pic":@"juhechart"}, nil];
    [self fillTheCollectionViewDataWithCanMove:NO sectionN:1 itemN:22 itemName:@"DatabaseCollectionViewCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.collectionView.frame = self.view.bounds;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *log = [NSString stringWithFormat:@"你选择的是%zd，%zd", indexPath.section, indexPath.row];
    [SVProgressHUD showSuccessWithStatus:log];DLog(@"%@",log);
    [self pushController:[MyDatabaseEditViewController class] withInfo:self.collectionView.dataArray[indexPath.row] withTitle:@"数据库编辑详情"];
}

@end

