//
//  TLChatTableViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/9.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLChatCellMenuView.h"

#import "TLTextMessage.h"
#import "TLImageMessage.h"
#import "TLExpressionMessage.h"

#import "TLTextMessageCell.h"
#import "TLImageMessageCell.h"
#import "TLExpressionMessageCell.h"
#import "TLActionSheet.h"
//  TLChatTableViewControllerDelegate.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/23.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLMessage;
@class TLChatTableViewController;
@protocol TLChatTableViewControllerDelegate <NSObject>

/**
 *  聊天界面点击事件，用于收键盘
 */
- (void)chatTableViewControllerDidTouched:(TLChatTableViewController *)chatTVC;

/**
 *  下拉刷新，获取某个时间段的聊天记录（异步）
 *
 *  @param chatTVC   chatTVC
 *  @param date      开始时间
 *  @param count     条数
 *  @param completed 结果Blcok
 */
- (void)chatTableViewController:(TLChatTableViewController *)chatTVC
             getRecordsFromDate:(NSDate *)date
                          count:(NSUInteger)count
                      completed:(void (^)(NSDate *, NSArray *, BOOL))completed;

@optional
/**
 *  消息长按删除
 *
 *  @return 删除是否成功
 */
- (BOOL)chatTableViewController:(TLChatTableViewController *)chatTVC
                  deleteMessage:(TLMessage *)message;

/**
 *  用户头像点击事件
 */
- (void)chatTableViewController:(TLChatTableViewController *)chatTVC
             didClickUserAvatar:(TLUser *)user;

/**
 *  Message点击事件
 */
- (void)chatTableViewController:(TLChatTableViewController *)chatTVC
                didClickMessage:(TLMessage *)message;

/**
 *  Message双击事件
 */
- (void)chatTableViewController:(TLChatTableViewController *)chatTVC
          didDoubleClickMessage:(TLMessage *)message;

@end

@interface UITableView (expanded)

- (void)scrollToBottomWithAnimation:(BOOL)animation;
@end

@interface TLChatTableViewController : UITableViewController<TLMessageCellDelegate, TLActionSheetDelegate>

- (void)registerCellClass;


@property (nonatomic, assign) id<TLChatTableViewControllerDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *data;

/// 禁用下拉刷新
@property (nonatomic, assign) BOOL disablePullToRefresh;

/// 禁用长按菜单
@property (nonatomic, assign) BOOL disableLongPressMenu;

/**
 *  发送消息（在列表展示）
 */
- (void)addMessage:(TLMessage *)message;

/**
 *  删除消息
 */
- (void)deleteMessage:(TLMessage *)message;

/**
 *  滚动到底部
 *
 *  @param animation 是否执行动画
 */
- (void)scrollToBottomWithAnimation:(BOOL)animation;

/**
 *  重新加载聊天信息
 */
- (void)reloadData;

@end
