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
#pragma mark - Common
+ (UIFont *)fontNavBarTitle;
#pragma mark - Conversation
+ (UIFont *)fontConversationUsername;
+ (UIFont *)fontConversationDetail;
+ (UIFont *)fontConversationTime;
#pragma mark - Friends
+ (UIFont *) fontFriendsUsername;
#pragma mark - Mine
+ (UIFont *)fontMineNikename;
+ (UIFont *)fontMineUsername;
#pragma mark - Setting
+ (UIFont *)fontSettingHeaderAndFooterTitle;
#pragma mark - Chat
+ (UIFont *)fontTextMessageText;
@end
@interface UIImage (ImageEffects)
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
//  NSString+NSString_ILExtension.h
//  Freedom
//  Created by Super on 14/10/22.
#import <Foundation/Foundation.h>
@interface NSString (NSString_ILExtension)
- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString;
- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index;
@end
//  NSArray+NSArray_ILExtension.h
//  Freedom
//  Created by Super on 14/10/22.
#import <Foundation/Foundation.h>
@interface NSArray (NSArray_ILExtension)
- (NSArray *)offsetRangesInArrayBy:(NSUInteger)offset;
@end

@interface UIViewController (add)<CKRadialMenuDelegate>
@end
