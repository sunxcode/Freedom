//  TLUserGroupCell.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
@class TLUser;
@protocol WechatUserGroupCellDelegate <NSObject>
- (void)userGroupCellDidSelectUser:(TLUser *)user;
- (void)userGroupCellAddUserButtonDown;
@end
@interface WechatUserGroupCell : UITableViewCell
@property (nonatomic, assign) id<WechatUserGroupCellDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *users;
@end
