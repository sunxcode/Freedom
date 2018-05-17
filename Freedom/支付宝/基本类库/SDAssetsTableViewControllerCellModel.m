//  SDAssetsTableViewControllerCellModel.m
//  Freedom
//  Created by Super on 15-6-4.
/*
 
*********************************************************************************
 */
#import "SDAssetsTableViewControllerCellModel.h"
@implementation AlipayTools
#define kItemsArrayCacheKey @"AlipayHomeIconsCacheKey"
+ (NSArray *)itemsArray{
    NSArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:kItemsArrayCacheKey];
    if(!temp){
    temp =  @[@{@"淘宝" : @"i00"}, // title => imageString
                             @{@"生活缴费" : @"i01"},
                             @{@"教育缴费" : @"i02"},
                             @{@"红包" : Phongbao},
                             @{@"物流" : @"i04"},
                             @{@"信用卡" : @"i05"},
                             @{@"转账" : @"i06"},
                             @{@"爱心捐款" : @"i07"},
                             @{@"彩票" : @"i08"},
                             @{@"当面付" : @"i09"},
                             @{@"余额宝" : @"i10"},
                             @{@"AA付款" : @"i11"},
                             @{@"国际汇款" : @"i12"},
                             @{@"淘点点" : @"i13"},
                             @{@"淘宝电影" : @"i14"},
                             @{@"亲密付" : @"i15"},
                             @{@"股市行情" : @"i16"},
                             @{@"汇率换算" : @"i17"}
                             ];
        [self saveItemsArray:temp];
    }
    return temp;
    
}
+ (void)saveItemsArray:(NSArray *)array{
    [[NSUserDefaults standardUserDefaults] setObject:[array copy] forKey:kItemsArrayCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
@implementation SDAssetsTableViewControllerCellModel
+ (instancetype)modelWithTitle:(NSString *)title iconImageName:(NSString *)iconImageName destinationControllerClass:(Class)destinationControllerClass{
    SDAssetsTableViewControllerCellModel *model = [[SDAssetsTableViewControllerCellModel alloc] init];
    model.title = title;
    model.iconImageName = iconImageName;
    model.destinationControllerClass = destinationControllerClass;
    return model;
}
@end
