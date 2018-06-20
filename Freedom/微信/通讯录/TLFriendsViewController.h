//  TLFriendsViewController.h
//  Freedom
// Created by Super
#import "WechatTableViewController.h"
#import "WechatFriendSearchViewController.h"
#define     HEIGHT_FRIEND_CELL      54.0f
#define     HEIGHT_HEADER           22.0f
#import "TLUserHelper.h"
#import "TLTableViewCell.h"
@interface WXFriendCell : TLTableViewCell
/*用户信息*/
@property (nonatomic, strong) TLUser *user;
@end
@interface WXFriendHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) NSString *title;
@end

@interface TLFriendsViewController : WechatTableViewController
@property (nonatomic, weak) NSMutableArray *data;
@property (nonatomic, weak) NSMutableArray *sectionHeaders;
@property (nonatomic, strong) WechatFriendSearchViewController *searchVC;
- (void)registerCellClass;
@end
