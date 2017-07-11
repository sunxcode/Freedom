//
//  JuheAPIViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/9/5.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "JuheAPIViewController.h"
#import "JuheAPIDetailViewController.h"
@interface JuheAPICollectionViewCell : UICollectionViewCell{
    UIView *view;
    UIImageView *imageView;
    UILabel *nameLabel;
    NSMutableDictionary *thumbnailCache;
}
-(void)setDataWithDic:(NSDictionary*)dic;
@end
@implementation JuheAPICollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, (H(self)-80)*0.5, 80, 80)];
        view.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithFrame:view.frame];
        imageView.layer.borderWidth = 2;
        imageView.layer.cornerRadius = 40;
        [view addSubview:imageView];
        [self.contentView addSubview:view];
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(XW(imageView),(H(self)-20)*0.5,200,20)];
        [self.contentView addSubview:nameLabel];
    }return self;
}
-(void)setDataWithDic:(NSDictionary*)dic{
    nameLabel.text = [dic valueForKey:@"name"];
    NSString *imgURL = [dic valueForKey:@"picture"];
    [imageView setImage:nil];
    __block UIImage *imageProduct = [thumbnailCache objectForKey:imgURL];
    if(imageProduct){
        imageView.image = imageProduct;
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageNamed:imgURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [thumbnailCache setValue:image forKey:imgURL];
            });
        });
    }
    imageView.clipsToBounds = YES;
}
@end
@interface JuheAPILayout : UICollectionViewFlowLayout
@end
@implementation JuheAPILayout
- (instancetype)init{
    self = [super init];
    if (self) {
        // 设置item的大小
        self.itemSize = CGSizeMake((kScreenWidth-40)/3.0, 120);
        // 设置水平滚动
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置最小行间距和格间距为10
        self.minimumInteritemSpacing = 10;//格
        self.minimumLineSpacing = 10;//行
        // 设置内边距
        self.sectionInset = UIEdgeInsetsMake(30, 10, 0,10);
    }return self;
}
@end
@interface JuheAPIViewController()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *juheAPICollectionView;
    NSMutableArray *APIArray;
}
@end
@implementation JuheAPIViewController
static NSString * const reuseIdentifier = @"JuheAPICell";
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
    searchBar.placeholder = @"输入问题关键字";
    self.navigationItem.titleView = searchBar;
    UIImageView *banner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 120)];
    banner.image = [UIImage imageNamed:@""];
    juheAPICollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, YH(banner), kScreenWidth,kScreenHeight-100) collectionViewLayout:[[JuheAPILayout alloc]init]];
    juheAPICollectionView.backgroundColor = [UIColor whiteColor];
    juheAPICollectionView.delegate = self;
    juheAPICollectionView.dataSource = self;
    [juheAPICollectionView registerClass:[JuheAPICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubviews:banner,juheAPICollectionView,nil];
}

-(void)moreAction{
    DLog(@"更多");
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return APIArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JuheAPICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[JuheAPICollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 100, 120)];
    }
    [cell setDataWithDic:APIArray[indexPath.item]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(240, 100);
}
@end
