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
    return [[NSUserDefaults standardUserDefaults] objectForKey:kItemsArrayCacheKey];
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
