//
//  TLChatTableViewController.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/9.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLChatTableViewController.h"
#import "MJRefresh.h"
#import "TLTextDisplayView.h"

#define     PAGE_MESSAGE_COUNT      15
@implementation UITableView (expanded)

- (void)scrollToBottomWithAnimation:(BOOL)animation
{
    NSUInteger section = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        section = [self.dataSource numberOfSectionsInTableView:self] - 1;
    }
    if ([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        NSUInteger row = [self.dataSource tableView:self numberOfRowsInSection:section];
        if (row > 0) {
            [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row - 1 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:animation];
        }
    }
}

@end
@interface TLChatTableViewController ()

@property (nonatomic, strong) MJRefreshNormalHeader *refresHeader;

/// 用户决定新消息是否显示时间
@property (nonatomic, strong) NSDate *curDate;

@end

@implementation TLChatTableViewController
@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 20)]];
    if (!self.disablePullToRefresh) {
        [self.tableView setMj_header:self.refresHeader];
    }
    [self registerCellClass];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchTableView)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([[TLChatCellMenuView sharedMenuView] isShow]) {
        [[TLChatCellMenuView sharedMenuView] dismiss];
    }
}

#pragma mark - Public Methods -
- (void)reloadData
{
    [self.data removeAllObjects];
    [self.tableView reloadData];
    self.curDate = [NSDate date];
    if (!self.disablePullToRefresh) {
        [self.tableView setMj_header:self.refresHeader];
    }
    [self p_tryToRefreshMoreRecord:^(NSInteger count, BOOL hasMore) {
        if (!hasMore) {
            self.tableView.mj_header = nil;
        }
        if (count > 0) {
            [self.tableView reloadData];
            [self.tableView scrollToBottomWithAnimation:NO];
        }
    }];
}

- (void)addMessage:(TLMessage *)message
{
    [self.data addObject:message];
    [self.tableView reloadData];
}

- (void)setData:(NSMutableArray *)data
{
    _data = data;
    [self.tableView reloadData];
}

- (void)deleteMessage:(TLMessage *)message
{
    NSInteger index = [self.data indexOfObject:message];
    if (_delegate && [_delegate respondsToSelector:@selector(chatTableViewController:deleteMessage:)]) {
        BOOL ok = [_delegate chatTableViewController:self deleteMessage:message];
        if (ok) {
            [self.data removeObject:message];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [MobClick event:@"e_delete_message"];
        }
        else {
            [UIAlertView bk_alertViewWithTitle:@"错误" message:@"从数据库中删除消息失败。"];
        }
    }
}

- (void)scrollToBottomWithAnimation:(BOOL)animation
{
    [self.tableView scrollToBottomWithAnimation:animation];
}

- (void)setDisablePullToRefresh:(BOOL)disablePullToRefresh
{
    if (disablePullToRefresh) {
        [self.tableView setMj_header:nil];
    }
    else {
        [self.tableView setMj_header:self.refresHeader];
    }
}

#pragma mark - Event Response -
- (void)didTouchTableView
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatTableViewControllerDidTouched:)]) {
        [_delegate chatTableViewControllerDidTouched:self];
    }
}

#pragma mark - Private Methods -
/**
 *  获取聊天历史记录
 */
- (void)p_tryToRefreshMoreRecord:(void (^)(NSInteger count, BOOL hasMore))complete
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatTableViewController:getRecordsFromDate:count:completed:)]) {
        [_delegate chatTableViewController:self
                        getRecordsFromDate:self.curDate
                                     count:PAGE_MESSAGE_COUNT
                                 completed:^(NSDate *date, NSArray *array, BOOL hasMore) {
                                     if (array.count > 0 && [date isEqualToDate:self.curDate]) {
                                         self.curDate = [array[0] date];
                                         [self.data insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                                         complete(array.count, hasMore);
                                     }
                                     else {
                                         complete(0, hasMore);
                                     }
                                 }];
    }
}

#pragma mark - Getter -
- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (MJRefreshNormalHeader *)refresHeader
{
    if (_refresHeader == nil) {
        _refresHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self p_tryToRefreshMoreRecord:^(NSInteger count, BOOL hasMore) {
                [self.tableView.mj_header endRefreshing];
                if (!hasMore) {
                    self.tableView.mj_header = nil;
                }
                if (count > 0) {
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }];
        }];
        _refresHeader.lastUpdatedTimeLabel.hidden = YES;
        _refresHeader.stateLabel.hidden = YES;
    }
    return _refresHeader;
}

#pragma mark - Public Methods -
- (void)registerCellClass
{
    [self.tableView registerClass:[TLTextMessageCell class] forCellReuseIdentifier:@"TLTextMessageCell"];
    [self.tableView registerClass:[TLImageMessageCell class] forCellReuseIdentifier:@"TLImageMessageCell"];
    [self.tableView registerClass:[TLExpressionMessageCell class] forCellReuseIdentifier:@"TLExpressionMessageCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}

#pragma mark - Delegate -
//MARK: UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLMessage * message = self.data[indexPath.row];
    if (message.messageType == TLMessageTypeText) {
        TLTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLTextMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    else if (message.messageType == TLMessageTypeImage) {
        TLImageMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLImageMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    else if (message.messageType == TLMessageTypeExpression) {
        TLExpressionMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLExpressionMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}

//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row >= self.data.count) {
        return 0.0f;
    }
    TLMessage * message = self.data[indexPath.row];
    return message.messageFrame.height;
}

//MARK: TLMessageCellDelegate
- (void)messageCellDidClickAvatarForUser:(TLUser *)user
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewController:didClickUserAvatar:)]) {
        [self.delegate chatTableViewController:self didClickUserAvatar:user];
    }
}

- (void)messageCellTap:(TLMessage *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewController:didClickMessage:)]) {
        [self.delegate chatTableViewController:self didClickMessage:message];
    }
}

/**
 *  双击Message Cell
 */
- (void)messageCellDoubleClick:(TLMessage *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewController:didDoubleClickMessage:)]) {
        [self.delegate chatTableViewController:self didDoubleClickMessage:message];
    }
}

- (void)messageCellLongPress:(TLMessage *)message rect:(CGRect)rect
{
    NSInteger row = [self.data indexOfObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if (self.disableLongPressMenu) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if ([[TLChatCellMenuView sharedMenuView] isShow]) {
        return;
    }
    
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    rect.origin.y += cellRect.origin.y - self.tableView.contentOffset.y;
    __weak typeof(self)weakSelf = self;
    [[TLChatCellMenuView sharedMenuView] showInView:self.navigationController.view withMessageType:message.messageType rect:rect actionBlock:^(TLChatMenuItemType type) {
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if (type == TLChatMenuItemTypeCopy) {
            NSString *str = [message messageCopy];
            [[UIPasteboard generalPasteboard] setString:str];
        }
        else if (type == TLChatMenuItemTypeDelete) {
            TLActionSheet *actionSheet = [[TLActionSheet alloc] initWithTitle:@"是否删除该条消息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
            actionSheet.tag = [self.data indexOfObject:message];
            [actionSheet show];
        }
    }];
}

//MARK: UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewControllerDidTouched:)]) {
        [self.delegate chatTableViewControllerDidTouched:self];
    }
}

//MARK: TLActionSheetDelegate
- (void)actionSheet:(TLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        TLMessage * message = [self.data objectAtIndex:actionSheet.tag];
        [self p_deleteMessage:message];
    }
}

#pragma mark - Private Methods -
- (void)p_deleteMessage:(TLMessage *)message
{
    NSInteger index = [self.data indexOfObject:message];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewController:deleteMessage:)]) {
        BOOL ok = [self.delegate chatTableViewController:self deleteMessage:message];
        if (ok) {
            [self.data removeObject:message];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [MobClick event:@"e_delete_message"];
        }
        else {
            [UIAlertView bk_alertViewWithTitle:@"错误" message:@"从数据库中删除消息失败。"];
        }
    }
}
@end
