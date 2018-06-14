//  NSObject+Freedom.m
//  Freedom
//  Created by htf on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "NSObject+Freedom.h"
@implementation NSObject (Freedom)
@end
@implementation UIImagePickerController (Fixed)
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:colorGrayBG];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.5f]}];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
@end
@implementation UINavigationItem (Fixed)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)setLeftBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated{
    if (item == nil) {
        [self setRightBarButtonItems:nil animated:animated];
    }else if (item.title != nil) {
        [self setLeftBarButtonItems:@[item] animated:animated];
    }else{
        [self setLeftBarButtonItems:@[[UIBarButtonItem fixItemSpace:-NAVBAR_ITEM_FIXED_SPACE], item] animated:animated];
    }
}
- (void)setRightBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated{
    if (item == nil) {
        [self setRightBarButtonItems:nil animated:animated];
    }else if (item.title != nil) {
        [self setRightBarButtonItems:@[item] animated:animated];
    }else{
        [self setRightBarButtonItems:@[[UIBarButtonItem fixItemSpace:-NAVBAR_ITEM_FIXED_SPACE], item] animated:animated];
    }
}
#pragma clang diagnostic pop
@end
@implementation UIFont (expanded)
+ (UIFont *) fontNavBarTitle{
    return [UIFont boldSystemFontOfSize:17.5f];
}
+ (UIFont *) fontConversationUsername{
    return [UIFont systemFontOfSize:17.0f];
}
+ (UIFont *) fontConversationDetail{
    return [UIFont systemFontOfSize:14.0f];
}
+ (UIFont *) fontConversationTime{
    return [UIFont systemFontOfSize:12.5f];
}
+ (UIFont *) fontFriendsUsername{
    return [UIFont systemFontOfSize:17.0f];
}
+ (UIFont *) fontMineNikename{
    return [UIFont systemFontOfSize:17.0f];
}
+ (UIFont *) fontMineUsername{
    return [UIFont systemFontOfSize:14.0f];
}
+ (UIFont *) fontSettingHeaderAndFooterTitle{
    return [UIFont systemFontOfSize:14.0f];
}
+ (UIFont *)fontTextMessageText{
    CGFloat size = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CHAT_FONT_SIZE"];
    if (size == 0) {
        size = 16.0f;
    }
    return [UIFont systemFontOfSize:size];
}
@end
@import Accelerate;
#import <float.h>
@implementation UIImage (ImageEffects)
- (UIImage *)applyLightEffect{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    return [self applyBlurWithRadius:2 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
- (UIImage *)applyExtraLightEffect{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
- (UIImage *)applyDarkEffect{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    int componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }else{
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        DLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        DLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        DLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }else{
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
@end
@implementation NSArray (NSArray_ILExtension)
- (NSArray *)offsetRangesInArrayBy:(NSUInteger)offset{
    NSUInteger aOffset = 0;
    NSUInteger prevLength = 0;
    NSMutableArray *ranges = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for(NSInteger i = 0; i < [self count]; i++){
        @autoreleasepool {
            NSRange range = [[self objectAtIndex:i] rangeValue];
            prevLength    = range.length;
            
            range.location -= aOffset;
            range.length    = offset;
            [ranges addObject:NSStringFromRange(range)];
            
            aOffset = aOffset + prevLength - offset;
        }
    }
    
    return ranges;
}
@end

@implementation NSString (NSString_ILExtension)
- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString{
    NSAssert(indexes != nil, @"%s: indexes 不可以为nil", __PRETTY_FUNCTION__);
    NSAssert(aString != nil, @"%s: aString 不可以为nil", __PRETTY_FUNCTION__);
    NSUInteger offset = 0;
    NSMutableString *raw = [self mutableCopy];
    NSInteger prevLength = 0;
    for(NSInteger i = 0; i < [indexes count]; i++){
        @autoreleasepool {
            NSRange range = [[indexes objectAtIndex:i] rangeValue];
            prevLength = range.length;
            
            range.location -= offset;
            [raw replaceCharactersInRange:range withString:aString];
            offset = offset + prevLength - [aString length];
        }
    }
    
    return raw;
}
- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                     options:NSRegularExpressionCaseInsensitive error:&error];
    if (error){
        
    }else{
        NSMutableArray *results = [[NSMutableArray alloc] init];
        NSRange searchRange = NSMakeRange(0, [self length]);
        [regx enumerateMatchesInString:self options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            NSRange groupRange =  [result rangeAtIndex:index];
            NSString *match = [self substringWithRange:groupRange];
            [results addObject:match];
        }];
        return results;
    }
    return nil;
}
@end
@implementation UIViewController (add)
-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier{
    DLog(@"代理通知发现点击了控制器%@", identifier);
    NSArray *theNewItems = @[@"Kugou",@"JuheData",@"Iqiyi",@"Taobao",@"Sina",@"Alipay",@"Resume",@"MyDatabase",@"MicroEnergy",@"Wechart",@"Dianping",@"Toutiao",@"Books",@"Freedom",@"PersonalApply"];
    int a = [identifier intValue];
    [radialMenu didTapCenterView:nil];
    NSString *controlName = theNewItems[a];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if([controlName isEqualToString:@"Sina"]){
        NSString *s =[NSString stringWithFormat:@"%@TabBarController",controlName];
        UIViewController *con = [[NSClassFromString(s) alloc]init];
        CATransition *animation = [CATransition animation];
        animation.duration = 1;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:con animated:NO completion:^{
        }];
        return;
    }
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:controlName bundle:nil];
    UIViewController *con = [StoryBoard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@TabBarController",controlName]];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    [self.view.window.layer addAnimation:animation forKey:nil];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    win.rootViewController = con;
    [win makeKeyAndVisible];
}
#pragma mark 摇一摇
/** 开始摇一摇 */
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSArray *theNewItems = FREEDOMItems;
    CKRadialMenu *theMenu = [[CKRadialMenu alloc] initWithFrame:CGRectMake(APPW/2-25, APPH/2-25, 50, 50)];
    for(int i = 0;i<theNewItems.count;i++){
        UIImageView *a = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        a.image = [UIImage imageNamed:[theNewItems[i] valueForKey:@"icon"]];
        [theMenu addPopoutView:a withIndentifier:[NSString stringWithFormat:@"%d",i]];
    }
    [theMenu enableDevelopmentMode];
    theMenu.distanceBetweenPopouts = 2*180/theNewItems.count;
    theMenu.delegate = self;
    [self.view addSubview:theMenu];
    theMenu.center = self.view.center;
    UIWindow *win = [[UIApplication sharedApplication]keyWindow];
    [win addSubview:theMenu];
    [win bringSubviewToFront:theMenu];
}
@end
