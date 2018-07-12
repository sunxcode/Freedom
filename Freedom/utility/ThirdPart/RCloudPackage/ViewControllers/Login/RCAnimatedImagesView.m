//
//  RCAnimatedImagesView.m
//  Freedom
//
//  Created by Super on 7/6/18.
//  Copyright © 2018 薛超. All rights reserved.
//
#import "RCAnimatedImagesView.h"
#import "RCDHttpTool.h"
#import "AFHttpTool.h"
#import "RCloudModel.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import <RongIMKit/RongIMKit.h>
@interface RCAnimatedImagesView () {
    BOOL animating;
    NSUInteger totalImages;
    NSUInteger currentlyDisplayingImageViewIndex;
    NSInteger currentlyDisplayingImageIndex;
}
@property(nonatomic, retain) NSArray *imageViews;
@property(nonatomic, retain) NSTimer *imageSwappingTimer;
+ (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber;
@end
@implementation RCAnimatedImagesView
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        NSMutableArray *imageViews = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-150 * 3,-150,self.bounds.size.width +  (150 * 2),self.bounds.size.height + (150 * 2))];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = NO;
            [self addSubview:imageView];
            [imageViews addObject:imageView];
        }
        totalImages = 2;
        self.imageViews = [imageViews copy];
        currentlyDisplayingImageIndex = -1;
    }
    return self;
}
- (void)startAnimating {
    if (!animating) {
        animating = YES;
        [self.imageSwappingTimer fire];
    }
}
- (void)bringNextImage {
    UIImageView *imageViewToHide =
    [self.imageViews objectAtIndex:currentlyDisplayingImageViewIndex];
    currentlyDisplayingImageViewIndex =
    currentlyDisplayingImageViewIndex == 0 ? 1 : 0;
    UIImageView *imageViewToShow =
    [self.imageViews objectAtIndex:currentlyDisplayingImageViewIndex];
    NSUInteger nextImageToShowIndex = 0;
    do {
        nextImageToShowIndex =
        [[self class] randomIntBetweenNumber:0 andNumber:totalImages - 1];
    } while (nextImageToShowIndex == currentlyDisplayingImageIndex);
    currentlyDisplayingImageIndex = nextImageToShowIndex;
    imageViewToShow.image = [UIImage imageNamed:@"login_background.png"];
    static const CGFloat kMovementAndTransitionTimeOffset = 0.1;
    [UIView animateWithDuration:self.timePerImage + 2 + kMovementAndTransitionTimeOffset delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveLinear animations:^{
         NSInteger randomTranslationValueX = 150 * 3.5 -[[self class]randomIntBetweenNumber:0 andNumber:150];
         NSInteger randomTranslationValueY = 0;
         CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(randomTranslationValueX,randomTranslationValueY);
         CGFloat randomScaleTransformValue = [[self class] randomIntBetweenNumber:115 andNumber:120] /100;
         CGAffineTransform scaleTransform = CGAffineTransformMakeScale(randomScaleTransformValue, randomScaleTransformValue);
         imageViewToShow.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
     }completion:NULL];
    [UIView animateWithDuration:2 delay:kMovementAndTransitionTimeOffset options:UIViewAnimationOptionBeginFromCurrentState |
     UIViewAnimationCurveLinear animations:^{
         imageViewToShow.alpha = 1.0;
         imageViewToHide.alpha = 0.0;
     }completion:^(BOOL finished) {
         if (finished) {
             imageViewToHide.transform = CGAffineTransformIdentity;
         }
     }];
}
- (void)reloadData {
    [self.imageSwappingTimer fire];
}
- (void)stopAnimating {
    if (animating) {
        [_imageSwappingTimer invalidate];
        _imageSwappingTimer = nil;
        [UIView animateWithDuration:2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            for (UIImageView *imageView in self.imageViews) {
                imageView.alpha = 0.0;
            }
        }completion:^(BOOL finished) {
            currentlyDisplayingImageIndex = -1;
            animating = NO;
        }];
    }
}
- (NSTimeInterval)timePerImage {
    if (_timePerImage == 0) {
        return 20.0;
    }
    return _timePerImage;
}
- (NSTimer *)imageSwappingTimer {
    if (!_imageSwappingTimer) {
        _imageSwappingTimer = [NSTimer scheduledTimerWithTimeInterval:self.timePerImage target:self selector:@selector(bringNextImage) userInfo:nil repeats:YES];
    }
    return _imageSwappingTimer;
}
+ (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber {
    if (minNumber > maxNumber) {
        return [self randomIntBetweenNumber:maxNumber andNumber:minNumber];
    }
    NSUInteger i = (arc4random() % (maxNumber - minNumber + 1)) + minNumber;
    return i;
}
#pragma mark - Memory Management
- (void)dealloc {
    [_imageSwappingTimer invalidate];
}
@end
