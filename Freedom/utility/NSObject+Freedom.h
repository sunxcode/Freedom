//  NSObject+Freedom.h
//  Freedom
//  Created by htf on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface NSObject (Freedom)
@end
@interface UIImagePickerController (Fixed)
@end
@interface UINavigationItem (Fixed)
@end
@interface UIFont (expanded)
+ (UIFont *)fontNavBarTitle;
+ (UIFont *)fontConversationUsername;
+ (UIFont *)fontConversationDetail;
+ (UIFont *)fontConversationTime;
+ (UIFont *) fontFriendsUsername;
+ (UIFont *)fontMineNikename;
+ (UIFont *)fontMineUsername;
+ (UIFont *)fontSettingHeaderAndFooterTitle;
+ (UIFont *)fontTextMessageText;
@end
@interface UIImage (ImageEffects)
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
@interface NSString (NSString_ILExtension)
- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString;
- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index;
@end
@interface NSArray (NSArray_ILExtension)
- (NSArray *)offsetRangesInArrayBy:(NSUInteger)offset;
@end

@interface UIViewController (add)<CKRadialMenuDelegate>
@end
