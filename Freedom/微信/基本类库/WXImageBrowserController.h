//  TLImageBrowserController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "WXBaseViewController.h"
@interface WXImageBrowserController : WXBaseViewController
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) NSInteger curIndex;
- (id)initWithImages:(NSArray *)images curImageIndex:(NSInteger)index curImageRect:(CGRect)rect;
- (void)show;
@end
