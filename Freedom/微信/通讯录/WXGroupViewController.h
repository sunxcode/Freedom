//  TLGroupViewController.h
//  Freedom
// Created by Super
#import "WechatTableViewController.h"
#import "TLUserHelper.h"
#import "TLTableViewCell.h"
@interface WXGroupSearchViewController : WechatTableViewController <UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *groupData;
@end
@interface WXGroupCell : TLTableViewCell
@property (nonatomic, strong) TLGroup *group;
@end
@interface WXGroupViewController : WechatTableViewController
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) WXGroupSearchViewController *searchVC;
- (void)registerCellClass;
@end
