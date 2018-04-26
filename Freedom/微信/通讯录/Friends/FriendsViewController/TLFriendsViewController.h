//  TLFriendsViewController.h
//  Freedom
// Created by Super
#import "TLTableViewController.h"
#import "TLFriendSearchViewController.h"
#define     HEIGHT_FRIEND_CELL      54.0f
#define     HEIGHT_HEADER           22.0f
@interface TLFriendsViewController : TLTableViewController
@property (nonatomic, weak) NSMutableArray *data;
@property (nonatomic, weak) NSMutableArray *sectionHeaders;
@property (nonatomic, strong) TLFriendSearchViewController *searchVC;
- (void)registerCellClass;
@end
