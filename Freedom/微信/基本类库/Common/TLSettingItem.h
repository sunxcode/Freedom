//  TLSettingItem.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
@interface TLSettingItem : NSObject
#define     TLCreateSettingItem(title) [TLSettingItem createItemWithTitle:title]
typedef NS_ENUM(NSInteger, TLSettingItemType) {
    TLSettingItemTypeDefalut = 0,
    TLSettingItemTypeTitleButton,
    TLSettingItemTypeSwitch,
    TLSettingItemTypeOther,
};
/*主标题*/
@property (nonatomic, strong) NSString *title;
/*副标题*/
@property (nonatomic, strong) NSString *subTitle;
/*右图片(本地)*/
@property (nonatomic, strong) NSString *rightImagePath;
/*右图片(网络)*/
@property (nonatomic, strong) NSString *rightImageURL;
/*是否显示箭头（默认YES）*/
@property (nonatomic, assign) BOOL showDisclosureIndicator;
/*停用高亮（默认NO）*/
@property (nonatomic, assign) BOOL disableHighlight;
/*cell类型，默认default*/
@property (nonatomic, assign) TLSettingItemType type;
+ (TLSettingItem *) createItemWithTitle:(NSString *)title;
- (NSString *) cellClassName;
@end
