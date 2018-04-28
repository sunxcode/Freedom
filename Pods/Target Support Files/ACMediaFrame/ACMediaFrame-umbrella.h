#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ACMediaFrame.h"
#import "ACMediaFrameConst.h"
#import "ACMediaImageCell.h"
#import "ACMediaManager.h"
#import "ACMediaModel.h"
#import "ACSelectMediaView.h"
#import "NSString+ACMediaExt.h"
#import "UIImage+ACGif.h"
#import "UIImageView+ACMediaExt.h"
#import "UIView+ACMediaExt.h"
#import "UIViewController+ACMediaExt.h"

FOUNDATION_EXPORT double ACMediaFrameVersionNumber;
FOUNDATION_EXPORT const unsigned char ACMediaFrameVersionString[];

