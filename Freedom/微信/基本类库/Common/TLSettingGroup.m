//  TLSettingGroup.m
//  Freedom
// Created by Super
#import "TLSettingGroup.h"
@implementation TLSettingGroup
+ (TLSettingGroup *) createGroupWithHeaderTitle:(NSString *)headerTitle
                                    footerTitle:(NSString *)footerTitle
                                          items:(NSMutableArray *)items{
    TLSettingGroup *group= [[TLSettingGroup alloc] init];
    group.headerTitle = headerTitle;
    group.footerTitle = footerTitle;
    group.items = items;
    return group;
}
#pragma mark - Public Mthods
- (id) objectAtIndex:(NSUInteger)index{
    return [self.items objectAtIndex:index];
}
- (NSUInteger)indexOfObject:(id)obj{
    return [self.items indexOfObject:obj];
}
- (void)removeObject:(id)obj{
    [self.items removeObject:obj];
}
#pragma mark - Setter
- (void) setHeaderTitle:(NSString *)headerTitle{
    _headerTitle = headerTitle;
    _headerHeight = [FreedomTools getTextHeightOfText:headerTitle font:[UIFont fontSettingHeaderAndFooterTitle] width:WIDTH_SCREEN - 30];
}
- (void) setFooterTitle:(NSString *)footerTitle{
    _footerTitle = footerTitle;
    _footerHeight = [FreedomTools getTextHeightOfText:footerTitle font:[UIFont fontSettingHeaderAndFooterTitle] width:WIDTH_SCREEN - 30];
}
#pragma mark - Getter
- (NSUInteger) count{
    return self.items.count;
}
@end
