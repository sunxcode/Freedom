//  TLNewFriendViewController.h
//  Freedom
// Created by Super
#import "WechatTableViewController.h"
@protocol TLAddThirdPartFriendCellDelegate <NSObject>
- (void)addThirdPartFriendCellDidSelectedType:(NSString *)thirdPartFriendType;
@end
@interface TLNewFriendViewController : WechatTableViewController<UISearchBarDelegate, TLAddThirdPartFriendCellDelegate>
- (void)registerCellClass;
@end
