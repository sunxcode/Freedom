
#import <UIKit/UIKit.h>
//CGFloat DegreesToRadians(CGFloat degrees);
//CGFloat RadiansToDegrees(CGFloat radians);
CGFloat RadiansToDegrees(CGFloat radians);
NS_INLINE  UIImage *InlineScaledImageToMiniumuSize(UIImage *sourceImage,CGSize targetSize){
    //    UIImage *sourceImage = sourceImage;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    if (CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)scaleFactor = widthFactor;
        else scaleFactor = heightFactor;
    }else{
        return sourceImage;
    }
    newImage = [[UIImage alloc] initWithCGImage:sourceImage.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    if(!newImage) NSLog(@"could not scale image");
    return newImage ;
}

@interface UIImage (expanded)
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
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)fixOrientation;

- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect;
- (UIImage *) imageWithWaterText:(NSString*)text inRect:(CGRect)rect;

- (UIImage *)croppedImage:(CGRect)bounds;
//- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize transparentBorder:(NSUInteger)borderSize cornerRadius:(NSUInteger)cornerRadius interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;
-(UIImage*)rotate:(UIImageOrientation)orient;
- (UIImage*)resizeImageWithNewSize:(CGSize)newSize;
+(UIImage *)imageName:(NSString *)name;
/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
+ (UIImage *)resizableImageWithName:(NSString *)imageName;
@end
