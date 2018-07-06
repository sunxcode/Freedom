//
//  RCDConversationSettingBaseViewController.m
//  RCloudMessage
//
//  Created by 杜立召 on 15/7/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDConversationSettingBaseViewController.h"

#import "RCDConversationSettingTableViewHeader.h"
#import <RongIMLib/RongIMLib.h>
#define CellReuseIdentifierCellIsTop @"CellIsTop"
#define CellReuseIdentifierCellNewMessageNotify @"CellNewMessageNotify"
#define CellReuserIdentifierCellClearHistory @"CellClearHistory"
@interface RCDConversationSettingTableViewCell : UITableViewCell

@property(nonatomic, strong) UISwitch *swich;
@property(nonatomic, strong) UILabel *label;

@end
@implementation RCDConversationSettingTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setTextAlignment:NSTextAlignmentLeft];
        _swich = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self addSubview:_label];
        [self addSubview:_swich];

        [_swich setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_swich(33)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _swich)]];
        //        [self addConstraints:[NSLayoutConstraint
        //        constraintsWithVisualFormat:@"H:[_swich(35)]-30-|"
        //                                                                     options:kNilOptions
        //                                                                     metrics:nil
        //                                                                       views:NSDictionaryOfVariableBindings(_swich)]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_swich
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f
                             constant:0]];

        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_label(30)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _label)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-16-[_label]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _label, _swich)]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_swich
                             attribute:NSLayoutAttributeRight
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeRight
                             multiplier:1.0f
                             constant:-20]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_label
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f
                             constant:0]];
    }
    return self;
}

@end

@interface RCDConversationSettingClearMessageCell : UITableViewCell

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIButton *touchBtn;
@end

@implementation RCDConversationSettingClearMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];

        _touchBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_nameLabel];
        [self addSubview:_touchBtn];

        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_touchBtn setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_touchBtn(44)]|"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _touchBtn)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[_touchBtn]|"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _touchBtn)]];

        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_nameLabel(30)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _nameLabel)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-16-[_nameLabel]-20-|"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _nameLabel)]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_nameLabel
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f
                             constant:0]];
    }
    return self;
}
@end

@interface RCDConversationSettingBaseViewController () <
    RCDConversationSettingTableViewHeaderDelegate>
@property(nonatomic, strong) RCDConversationSettingTableViewHeader *header;
@property(nonatomic, strong) UIView *headerView;

@property(nonatomic, strong) RCDConversationSettingTableViewCell *cell_isTop;
@property(nonatomic, strong)
    RCDConversationSettingTableViewCell *cell_newMessageNotify;

@end

@implementation RCDConversationSettingBaseViewController

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;

  // landspace notification
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(orientChange:)
             name:UIDeviceOrientationDidChangeNotification
           object:nil];
  // add the header view
  _headerView = [[UIView alloc] initWithFrame:CGRectZero];

  _header = [[RCDConversationSettingTableViewHeader alloc] init];
  _header.settingTableViewHeaderDelegate = self;
  [_header setBackgroundColor:[UIColor whiteColor]];

  [_headerView addSubview:_header];
  [_header setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_headerView
      addConstraints:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"V:|-10-[_header]|"
                                  options:kNilOptions
                                  metrics:nil
                                    views:NSDictionaryOfVariableBindings(
                                              _header)]];
  [_headerView
      addConstraints:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|[_header]|"
                                  options:kNilOptions
                                  metrics:nil
                                    views:NSDictionaryOfVariableBindings(
                                              _header)]];

  // footer view
  self.tableView.tableFooterView = [UIView new];
}

- (void)addUsers:(NSMutableArray *)users {
  if (!users)
    return;
  _header.users = [NSMutableArray arrayWithArray:users];
  self.users = users;
  [_header reloadData];
  _headerView.frame =
      CGRectMake(0, 0, APPW,
                 _header.collectionViewLayout.collectionViewContentSize.height + 20);
  self.tableView.tableHeaderView = _headerView;
}

- (void)disableDeleteMemberEvent:(BOOL)disable {
  if (_header) {
    _header.isAllowedDeleteMember = !disable;
  }
}

- (void)disableInviteMemberEvent:(BOOL)disable {
  if (_header) {
    _header.isAllowedInviteMember = !disable;
  }
}

- (NSArray *)defaultCells {

  _cell_isTop =
      [[RCDConversationSettingTableViewCell alloc] initWithFrame:CGRectZero];
  [_cell_isTop.swich addTarget:self
                        action:@selector(onClickIsTopSwitch:)
              forControlEvents:UIControlEventValueChanged];
  _cell_isTop.swich.on = _switch_isTop;
  _cell_isTop.label.text = NSLocalizedStringFromTable(
      @"SetToTop", @"RongCloudKit", nil); //@"置顶聊天";

  _cell_newMessageNotify =
      [[RCDConversationSettingTableViewCell alloc] initWithFrame:CGRectZero];
  [_cell_newMessageNotify.swich
             addTarget:self
                action:@selector(onClickNewMessageNotificationSwitch:)
      forControlEvents:UIControlEventValueChanged];
  _cell_newMessageNotify.swich.on = _switch_newMessageNotify;
  _cell_newMessageNotify.label.text = NSLocalizedStringFromTable(
      @"NewMsgNotification", @"RongCloudKit", nil); //@"新消息通知";

  RCDConversationSettingClearMessageCell *cell_clearHistory =
      [[RCDConversationSettingClearMessageCell alloc] initWithFrame:CGRectZero];
  [cell_clearHistory.touchBtn addTarget:self
                                 action:@selector(onClickClearMessageHistory:)
                       forControlEvents:UIControlEventTouchUpInside];
  cell_clearHistory.nameLabel.text = NSLocalizedStringFromTable(
      @"ClearRecord", @"RongCloudKit", nil); //@"清除聊天记录";

  NSArray *_defaultCells =
      @[ _cell_isTop, _cell_newMessageNotify, cell_clearHistory ];

  return _defaultCells;
}

- (void)setSwitch_isTop:(BOOL)switch_isTop {
  _cell_isTop.swich.on = switch_isTop;
  _switch_isTop = switch_isTop;
}

- (void)setSwitch_newMessageNotify:(BOOL)switch_newMessageNotify {
  _cell_newMessageNotify.swich.on = switch_newMessageNotify;
  _switch_newMessageNotify = switch_newMessageNotify;
}

// landspace notification
- (void)orientChange:(NSNotification *)noti {
  _headerView.frame =
      CGRectMake(0, 0, APPW,
                 _header.collectionViewLayout.collectionViewContentSize.height + 20);
  self.tableView.tableHeaderView = _headerView;

  if (self.headerHidden) {
    self.tableView.tableHeaderView = nil;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _headerView.frame =
      CGRectMake(0, 0, APPW,
                 _header.collectionViewLayout.collectionViewContentSize.height + 20);
  self.tableView.tableHeaderView = _headerView;
  if (self.headerHidden) {
    self.tableView.tableHeaderView = nil;
  }
  if (_headerView) {
    _header.showDeleteTip = NO;
    [_header reloadData];
  }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44.f;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return self.defaultCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  return self.defaultCells[indexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 20;
}

// override to impletion
//置顶聊天
- (void)onClickIsTopSwitch:(id)sender {
}

//新消息通知
- (void)onClickNewMessageNotificationSwitch:(id)sender {
}

//清除聊天记录
- (void)onClickClearMessageHistory:(id)sender {
}

//子类重写以下两个回调实现点击事件
#pragma mark - RCConversationSettingTableViewHeader Delegate
- (void)settingTableViewHeader:
            (RCDConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users {
}

- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath {
}
- (void)didTipHeaderClicked:(NSString *)userId {
}
@end
