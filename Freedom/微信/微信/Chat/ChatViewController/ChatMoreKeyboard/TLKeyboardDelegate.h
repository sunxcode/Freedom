//  TLKeyboardDelegate.h
//  Freedom
//  Created by Super on 16/2/17.
#import <Foundation/Foundation.h>
@protocol TLKeyboardDelegate <NSObject>
@optional
- (void) chatKeyboardWillShow:(id)keyboard;
- (void) chatKeyboardDidShow:(id)keyboard;
- (void) chatKeyboardWillDismiss:(id)keyboard;
- (void) chatKeyboardDidDismiss:(id)keyboard;
- (void) chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height;
@end
