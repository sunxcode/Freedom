//
//  LibraryCollectionViewController.m
//  MyFirstAPP
//  Created by 薛超 on 16/6/24.
//  Copyright © 2016年 薛超. All rights reserved.
#import "LibraryCollectionViewController.h"
@interface LibraryCollectionViewCell : UICollectionViewCell{
    UIView *view;
    UIImageView *imageView;
    UILabel *nameLabel;
    NSMutableDictionary *thumbnailCache;
}
-(void)setDataWithDic:(NSDictionary*)dic;
@end
@implementation LibraryCollectionViewCell
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
@interface LibraryLayout : UICollectionViewFlowLayout
@end
@implementation LibraryLayout
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

@interface LibraryCollectionViewController (){
    NSMutableArray *libraryBooks;
}
@end
@implementation LibraryCollectionViewController
@synthesize contentLength, dismissByBackgroundDrag, dismissByBackgroundTouch, dismissByForegroundDrag;
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentLength = kScreenWidth;
        self.dismissByBackgroundTouch   = YES;
        self.dismissByBackgroundDrag    = YES;
        self.dismissByForegroundDrag    = YES;
    }return self;
}


static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = redcolor;
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight-100)];
    backView.image = [UIImage imageNamed:@""];
    self.collectionView.backgroundView = backView;
    ElasticTransition *ET = (ElasticTransition*)self.transitioningDelegate;
    NSLog(@"\ntransition.edge = %@\ntransition.transformType = %@\ntransition.sticky = %@\ntransition.showShadow = %@", [HelperFunctions typeToStringOfEdge:ET.edge], [ET transformTypeToString], ET.sticky ? @"YES" : @"NO", ET.showShadow ? @"YES" : @"NO");
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = [[LibraryLayout alloc]init];
    [self.collectionView registerClass:[LibraryCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return libraryBooks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LibraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[LibraryCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 100, 120)];
    }
    [cell setDataWithDic:libraryBooks[indexPath.item]];
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
