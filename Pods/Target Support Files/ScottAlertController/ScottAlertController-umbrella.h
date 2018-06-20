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

#import "ScottAlertViewController+BlurEffects.h"
#import "UIImage+ScottAlertView.h"
#import "UIView+ScottAlertView.h"
#import "UIView+ScottAutoLayout.h"
#import "ScottBaseAnimation.h"
#import "ScottDropDownAnimation.h"
#import "ScottFadeAnimation.h"
#import "ScottScaleFadeAnimation.h"
#import "ScottAlertController.h"
#import "ScottAlertView.h"
#import "ScottShowAlertView.h"
#import "ScottAlertViewController.h"

FOUNDATION_EXPORT double ScottAlertControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char ScottAlertControllerVersionString[];

