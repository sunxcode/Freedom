//
//  UIButton+expanded.h
//  MyFirstAPP
//
//  Created by 薛超 on 17/1/18.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (expanded)
+ (UIButton *)initBtnWithFrame:(CGRect)frame target:(id)target method:(SEL)method title:(NSString *)title setimageName:(NSString *)setimageName backImageName:(NSString *)backImageName;

- (void) setImage:(UIImage *)image imageHL:(UIImage *)imageHL;
@end
