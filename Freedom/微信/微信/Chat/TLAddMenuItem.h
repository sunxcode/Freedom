//  TLAddMenuItem.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
@interface TLAddMenuItem : NSObject
@property (nonatomic, assign) TLAddMneuType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *className;
+ (TLAddMenuItem *)createWithType:(TLAddMneuType)type title:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className;
@end
