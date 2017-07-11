//
//  UIImage+DZ.h
//  Shop
//
//  Created by dengwei on 15/11/28.
//  Copyright (c) 2015年 dengw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DZ)

/**
 *  加载最原始的图片,没有经过渲染
 *
 */
+(instancetype)imageWithRenderingOriginalName:(NSString *)imageName;

/**
 *  加载全屏的图片
 *
 */
+(UIImage *)fullScreenImage:(NSString *)imageName;

/**
 *  可以自由拉伸的图片
 *
 */
+ (UIImage *)resizedImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

/**
 *  可以自由拉伸不会变形的图片
 *
 */
+(UIImage *)resizedImage:(NSString *)imageName;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

+ (instancetype)resizableWithImageName:(NSString *)imageName;

@end
