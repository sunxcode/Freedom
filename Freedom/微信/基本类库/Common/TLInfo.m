//  TLInfo.m
//  Freedom
// Created by Super
#import "TLInfo.h"
@implementation TLInfo
+ (TLInfo *)createInfoWithTitle:(NSString *)title subTitle:(NSString *)subTitle{
    TLInfo *info = [[TLInfo alloc] init];
    info.title = title;
    info.subTitle = subTitle;
    return info;
}
- (id)init{
    if (self = [super init]) {
        self.showDisclosureIndicator = YES;
    }
    return self;
}
- (UIColor *)buttonColor{
    if (_buttonColor == nil) {
        return colorGreenDefault;
    }
    return _buttonColor;
}
- (UIColor *)buttonHLColor{
    if (_buttonHLColor == nil) {
        return [self buttonColor];
    }
    return _buttonHLColor;
}
- (UIColor *)titleColor{
    if (_titleColor == nil) {
        return [UIColor blackColor];
    }
    return _titleColor;
}
- (UIColor *)buttonBorderColor{
    if (_buttonBorderColor == nil) {
        return colorGrayLine;
    }
    return _buttonBorderColor;
}
@end
