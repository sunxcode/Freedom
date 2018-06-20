//  FreedomDetailViewController.m
//  Freedom
// Created by Super
#import "WeChatChatDetailViewController.h"
#import "WechatFriendDetailViewController.h"
#import "TLMessageManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "WechatUserGroupCell.h"
#import "WechatActionSheet.h"
#import "TLChatViewController.h"
#import "WechatChatFileViewController.h"
#import "WXBgSettingViewController.h"
#define     TAG_EMPTY_CHAT_REC      1001
@interface WeChatChatDetailViewController () <WechatUserGroupCellDelegate, TLActionSheetDelegate>
@property (nonatomic, strong) TLMessageManager *helper;
@end
@implementation WeChatChatDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"聊天详情"];
    
    self.helper = [TLMessageManager sharedInstance];
    self.data = [self.helper chatDetailDataByUserInfo:self.user];
    
    [self.tableView registerClass:[WechatUserGroupCell class] forCellReuseIdentifier:@"TLUserGroupCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        WechatUserGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLUserGroupCell"];
        [cell setUsers:[NSMutableArray arrayWithArray:@[self.user]]];
        [cell setDelegate:self];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TLSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"聊天文件"]) {
        WechatChatFileViewController *chatFileVC = [[WechatChatFileViewController alloc] init];
        [chatFileVC setPartnerID:self.user.userID];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatFileVC animated:YES];
    }else if ([item.title isEqualToString:@"设置当前聊天背景"]) {
        WXBgSettingViewController *chatBGSettingVC = [[WXBgSettingViewController alloc] init];
        [chatBGSettingVC setPartnerID:self.user.userID];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatBGSettingVC animated:YES];
    }else if ([item.title isEqualToString:@"清空聊天记录"]) {
        WechatActionSheet *actionSheet = [[WechatActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空聊天记录" otherButtonTitles: nil];
        actionSheet.tag = TAG_EMPTY_CHAT_REC;
        [actionSheet show];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSUInteger count = self.user ? 1 : 0;
        return ((count + 1) / 4 + ((((count + 1) % 4) == 0) ? 0 : 1)) * 90 + 15;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
//MARK: TLActionSheetDelegate
- (void)actionSheet:(WechatActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == TAG_EMPTY_CHAT_REC) {
        if (buttonIndex == 0) {
            BOOL ok = [[TLMessageManager sharedInstance] deleteMessagesByPartnerID:self.user.userID];
            if (!ok) {
                [UIAlertView bk_alertViewWithTitle:@"错误" message:@"清空聊天记录失败"];
            }else{
                [[TLChatViewController sharedChatVC] resetChatVC];
            }
        }
    }
}
//MARK: TLUserGroupCellDelegate
- (void)userGroupCellDidSelectUser:(TLUser *)user{
    WechatFriendDetailViewController *detailVC = [[WechatFriendDetailViewController alloc] init];
    [detailVC setUser:user];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)userGroupCellAddUserButtonDown{
    [UIAlertView bk_alertViewWithTitle:@"提示" message:@"添加讨论组成员"];
}
@end
