//  TLMenuItem.m
//  Freedom
// Created by Super
#import "TLMenuItem.h"
@implementation TLMenuItem
+ (TLMenuItem *) createMenuWithIconPath:(NSString *)iconPath title:(NSString *)title{
    TLMenuItem *item = [[TLMenuItem alloc] init];
    item.iconPath = iconPath;
    item.title = title;
    return item;
}
@end
