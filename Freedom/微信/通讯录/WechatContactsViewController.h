//  TLContactsViewController.h
//  Freedom
// Created by Super
#import "WechatTableViewController.h"
@interface TLContactsSearchViewController : WechatTableViewController <UISearchResultsUpdating>
@property (nonatomic, strong) NSArray *contactsData;
@end
@interface WechatContactsViewController : WechatTableViewController
/// 通讯录好友（初始数据）
@property (nonatomic, strong) NSArray *contactsData;
/// 通讯录好友（格式化的列表数据）
@property (nonatomic, strong) NSArray *data;
/// 通讯录好友索引
@property (nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) TLContactsSearchViewController *searchVC;
- (void)registerCellClass;
@end
