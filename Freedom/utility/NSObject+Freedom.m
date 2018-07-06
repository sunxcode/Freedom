//  NSObject+Freedom.m
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
@implementation RCUnderlineTextField
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:161 green:163 blue:168 alpha:0.2f].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextBeginPath(context);
    CGFloat baselineOffset = 45.0f;
    CGContextMoveToPoint(context, self.bounds.origin.x, baselineOffset);
    CGContextAddLineToPoint(context, self.bounds.size.width - 10, baselineOffset);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}
@end

@implementation UIView (Freedom)
- (void)shake{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    CGFloat x = self.center.x;
    CGFloat y = self.center.y;
    CGFloat xarray[10] = {x,x-5,x+5,x,x-5,x+5,x,x-5,x+5,x};
    NSMutableArray *array = [NSMutableArray array];
    int lenth = sizeof(xarray)/sizeof(CGFloat);
    for(int i = 0;i<lenth;i++){
        CGFloat a = xarray[i];
        [array addObject:[NSValue valueWithCGPoint:CGPointMake(a, y)]];
    }
    [keyAn setValues:array];
    NSArray *times = [[NSArray alloc] initWithObjects:@0.1f,@0.2f,@0.3f,@0.4f,@0.5f,@0.6f,@0.7f,@0.8f,@0.9f,@1.0f, nil];
    [keyAn setKeyTimes:times];
    [self.layer addAnimation:keyAn forKey:@"Shark"];
}
- (UIImage *)imageFromView {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
@implementation UIViewController (DismissKeyboard)
- (void)setupForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];

    __weak UIViewController *weakSelf = self;

    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}
@end
@implementation NSObject (Freedom)
@end
