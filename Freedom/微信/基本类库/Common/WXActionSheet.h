//  TLActionSheet.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
@protocol WXActionSheetDelegate; 
@interface WXActionSheet : UIView
@property(nonatomic, assign, readonly) NSInteger numberOfButtons;
@property(nonatomic, assign, readonly) NSInteger cancelButtonIndex;
@property(nonatomic, assign, readonly) NSInteger destructiveButtonIndex;
@property (nonatomic, assign) id<WXActionSheetDelegate> delegate;
- (id)initWithTitle:(NSString *)title
           delegate:(id<WXActionSheetDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (void)show;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
@end
@protocol WXActionSheetDelegate <NSObject>
@optional;
- (void)actionSheet:(WXActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)actionSheet:(WXActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)actionSheet:(WXActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end
