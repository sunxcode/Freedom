#import "UIColor+add.h"
@implementation UIColor (add)
#pragma mark - # 字体
+ (UIColor *)colorTextBlack {
    return [UIColor blackColor];
}
+ (UIColor *)colorTextGray {
    return [UIColor grayColor];
}
+ (UIColor *)colorTextGray1 {
    return RGBACOLOR(160, 160, 160, 1.0);
}
#pragma mark - 灰色
+ (UIColor *)colorGrayBG {
    return RGBACOLOR(239.0, 239.0, 244.0, 1.0);
}
+ (UIColor *)colorGrayCharcoalBG {
    return RGBACOLOR(235.0, 235.0, 235.0, 1.0);
}
+ (UIColor *)colorGrayLine {
    return [UIColor colorWithWhite:0.5 alpha:0.3];
}
+ (UIColor *)colorGrayForChatBar {
    return RGBACOLOR(245.0, 245.0, 247.0, 1.0);
}
+ (UIColor *)colorGrayForMoment {
    return RGBACOLOR(243.0, 243.0, 245.0, 1.0);
}
#pragma mark - 绿色
+ (UIColor *)colorGreenDefault {
    return RGBACOLOR(2.0, 187.0, 0.0, 1.0f);
}
#pragma mark - 蓝色
+ (UIColor *)colorBlueMoment {
    return RGBACOLOR(74.0, 99.0, 141.0, 1.0);
}
#pragma mark - 黑色
+ (UIColor *)colorBlackForNavBar {
    return RGBACOLOR(20.0, 20.0, 20.0, 1.0);
}
+ (UIColor *)colorBlackBG {
    return RGBACOLOR(46.0, 49.0, 50.0, 1.0);
}
+ (UIColor *)colorBlackAlphaScannerBG {
    return [UIColor colorWithWhite:0 alpha:0.6];
}
+ (UIColor *)colorBlackForAddMenu {
    return RGBACOLOR(71, 70, 73, 1.0);
}
+ (UIColor *)colorBlackForAddMenuHL {
    return RGBACOLOR(65, 64, 67, 1.0);
}
- (NSString *)fetchStyleString {
	return [self styleString];
}
@end
