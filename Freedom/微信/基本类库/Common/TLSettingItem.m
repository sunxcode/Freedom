//  TLSettingItem.m
//  Freedom
// Created by Super
#import "TLSettingItem.h"
@implementation TLSettingItem
+ (TLSettingItem *) createItemWithTitle:(NSString *)title{
    TLSettingItem *item = [[TLSettingItem alloc] init];
    item.title = title;
    return item;
}
- (id) init{
    if (self = [super init]) {
        self.showDisclosureIndicator = YES;
    }
    return self;
}
- (NSString *) cellClassName{
    switch (self.type) {
        case TLSettingItemTypeDefalut:
            return @"TLSettingCell";
            break;
        case TLSettingItemTypeTitleButton:
            return @"TLSettingButtonCell";
            break;
        case TLSettingItemTypeSwitch:
            return @"TLSettingSwitchCell";
            break;
        default:
            break;
    }
    return nil;
}
@end
