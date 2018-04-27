//  SDAssetsTableViewControllerCellModel.h
//  Freedom
//  Created by Super on 15-6-4.

#import <Foundation/Foundation.h>
@interface AlipayTools : NSObject
+ (NSArray *)itemsArray;
+ (void)saveItemsArray:(NSArray *)array;
@end
@interface SDAssetsTableViewControllerCellModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconImageName;
@property (nonatomic, copy) Class destinationControllerClass;
+ (instancetype)modelWithTitle:(NSString *)title iconImageName:(NSString *)iconImageName destinationControllerClass:(Class)destinationControllerClass;
@end
