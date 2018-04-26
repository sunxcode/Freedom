//  TLAddMenuItem.m
//  Freedom
// Created by Super
#import "TLAddMenuItem.h"
@implementation TLAddMenuItem
+ (TLAddMenuItem *)createWithType:(TLAddMneuType)type title:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className{
    TLAddMenuItem *item = [[TLAddMenuItem alloc] init];
    item.type = type;
    item.title = title;
    item.iconPath = iconPath;
    item.className = className;
    return item;
}
@end
