
#import <UIKit/UIKit.h>


@interface UIImage (add)
- (UIImage *)subImageAtRect:(CGRect)rect;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToWidth:(CGFloat)value;
- (UIImage *)imageScaledToHeight:(CGFloat)value;
- (UIImage *)imageScaledToSizeEx:(CGSize)size;
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
- (UIImage *)gaussianBlur;
- (CGFloat)resizableHeightWithFixedwidth:(CGFloat)width;
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
-(UIImage*)getGrayImage:(UIImage*)sourceImage;
+ (UIImage *) getLaunchImage;
#pragma mark 以上是淘宝详情的，以下是原有的
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)scalingToSize:(CGSize)size;
//加载最原始的图片,没有经过渲染
+(instancetype)imageWithRenderingOriginalName:(NSString *)imageName;
//加载全屏的图片
+(UIImage *)fullScreenImage:(NSString *)imageName;
//可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;
//  可以自由拉伸不会变形的图片
+(UIImage *)resizedImage:(NSString *)imageName;
+ (instancetype)imageWithStretchableName:(NSString *)imageName;
+ (instancetype)resizableWithImageName:(NSString *)imageName;
- (CGRect) getRectWithSize:(CGSize) size;

@end
