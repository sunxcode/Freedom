//
//  UIScrollView+expanded.h
//  MyFirstAPP
//
//  Created by 薛超 on 17/1/18.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (expanded)
- (NSInteger)pages;
- (NSInteger)currentPage;
- (CGFloat)scrollPercent;

- (NSInteger)pagesY;
- (NSInteger)pagesX;
- (NSInteger)currentPageY;
- (NSInteger)currentPageX;
- (void) setPageY:(CGFloat)page;
- (void) setPageX:(CGFloat)page;
- (void) setPageY:(CGFloat)page animated:(BOOL)animated;
- (void) setPageX:(CGFloat)page animated:(BOOL)animated;
@end
