//  TLFriendDetailViewController.h
//  Freedom
// Created by Super
#import "WechatInfoViewController.h"
#define     HEIGHT_USER_CELL           90.0f
#define     HEIGHT_ALBUM_CELL          80.0f
#import "WechartModes.h"
@protocol TLFriendDetailUserCellDelegate <NSObject>
- (void)friendDetailUserCellDidClickAvatar:(TLInfo *)info;
@end
@interface WechatFriendDetailUserCell : TLTableViewCell
@property (nonatomic, assign) id<TLFriendDetailUserCellDelegate>delegate;
@property (nonatomic, strong) TLInfo *info;
@end
@class TLUser;
@interface WechatFriendDetailViewController : WechatInfoViewController <TLFriendDetailUserCellDelegate>
- (void)registerCellClass;
@property (nonatomic, strong) TLUser *user;
@end
