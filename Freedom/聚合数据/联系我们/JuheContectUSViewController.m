//  JuheContectUSViewController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "JuheContectUSViewController.h"
#import "JuhePublicViewController.h"
#import "JuheMessageViewController.h"
#import "JuheAboutUSViewController.h"
#import "JuheChartViewController.h"
@interface JuheContectUSViewCell:BaseCollectionViewOCCell{
    NSMutableDictionary *thumbnailCache;
}
-(void)setCollectionDataWithDic:(NSDictionary*)dict;
@end
@implementation JuheContectUSViewCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(0, 0, APPW*2/3, 120);
    self.title.frame = CGRectMake(0, YH(self.icon), W(self.icon), 20);
    self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubviews:self.icon,self.title,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary*)dict{
    
    self.title.text = dict[@"name"];
    __block UIImage *imageProduct = [thumbnailCache objectForKey:dict[@"pic"]];
    if(imageProduct){
        self.icon.image = imageProduct;
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageNamed:dict[@"pic"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.icon.image = image;
                [thumbnailCache setValue:image forKey:dict[@"pic"]];
            });
        });
    }
}
@end
@implementation JuheContectUSViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"联系我们";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((APPW*2)/3, 140);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    layout.minimumInteritemSpacing = 50;
    layout.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-TabBarH) collectionViewLayout:layout];
   
    dataArray = [NSMutableArray arrayWithObjects:@{@"name":@"进入公众号",@"pic":@"juheintopublic"},@{@"name":@"查看历史消息",@"pic":@"juhelookhistory"},@{@"name":@"关于我们",@"pic":@"juheaboutus"},@{@"name":@"聊天",@"pic":PuserLogo}, nil];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        [self pushController:[JuhePublicViewController class] withInfo:nil withTitle:dataArray[indexPath.row][@"name"] withOther:nil];
    }else if(indexPath.row==1){
        [self pushController:[JuheMessageViewController class] withInfo:nil withTitle:dataArray[indexPath.row][@"name"] withOther:nil];
    }else if(indexPath.row==2){
        [self pushController:[JuheAboutUSViewController class] withInfo:nil withTitle:dataArray[indexPath.row][@"name"] withOther:nil];
    }else{
        [self pushController:[JuheChartViewController class] withInfo:nil withTitle:dataArray[indexPath.row][@"name"] withOther:nil];
    }
}
@end
