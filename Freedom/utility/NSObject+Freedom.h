//  NSObject+Freedom.h
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface RCUnderlineTextField : UITextField
@end
@interface NSObject (Freedom)
@end
@interface UIView (Freedom)
- (void)shake;
- (UIImage *)imageFromView ;
@end
@interface UIViewController (DismissKeyboard)
-(void)setupForDismissKeyboard;
@end

