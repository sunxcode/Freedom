//  TLFriendSearchViewController.h
//  Freedom
//  Created by Super on 16/1/25.
#import "WechatTableViewController.h"
#define     HEIGHT_FRIEND_CELL      54.0f
@interface WechatFriendSearchViewController : WechatTableViewController <UISearchResultsUpdating>
@property (nonatomic, strong) NSMutableArray *friendsData;
@end
