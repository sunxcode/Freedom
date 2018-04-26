//  TLEmojiGroupControl.h
//  Freedom
//  Created by Super on 16/2/19.
#import <UIKit/UIKit.h>
#import "TLEmojiGroup.h"
typedef NS_ENUM(NSInteger, TLGroupControlSendButtonStatus) {
    TLGroupControlSendButtonStatusGray,
    TLGroupControlSendButtonStatusBlue,
    TLGroupControlSendButtonStatusNone,
};
@class TLEmojiGroupControl;
@protocol TLEmojiGroupControlDelegate <NSObject>
- (void)emojiGroupControl:(TLEmojiGroupControl*)emojiGroupControl didSelectedGroup:(TLEmojiGroup *)group;
- (void)emojiGroupControlEditButtonDown:(TLEmojiGroupControl *)emojiGroupControl;
- (void)emojiGroupControlEditMyEmojiButtonDown:(TLEmojiGroupControl *)emojiGroupControl;
- (void)emojiGroupControlSendButtonDown:(TLEmojiGroupControl *)emojiGroupControl;
@end
@interface TLEmojiGroupControl : UIView
@property (nonatomic, assign) TLGroupControlSendButtonStatus sendButtonStatus;
@property (nonatomic, strong) NSMutableArray *emojiGroupData;
@property (nonatomic, assign) id<TLEmojiGroupControlDelegate>delegate;
@end
