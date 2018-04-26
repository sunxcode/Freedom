//  TLConversation.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
#import "TLUser.h"
@interface TLConversation : NSObject
/*会话类型（个人，讨论组，企业号）*/
@property (nonatomic, assign) TLConversationType convType;
/*消息提醒类型*/
@property (nonatomic, assign) TLMessageRemindType remindType;
/*用户ID*/
@property (nonatomic, strong) NSString *partnerID;
/*用户名*/
@property (nonatomic, strong) NSString *partnerName;
/*头像地址（网络）*/
@property (nonatomic, strong) NSString *avatarURL;
/*头像地址（本地）*/
@property (nonatomic, strong) NSString *avatarPath;
/*时间*/
@property (nonatomic, strong) NSDate *date;
/*消息展示内容*/
@property (nonatomic, strong) NSString *content;
/*提示红点类型*/
@property (nonatomic, assign, readonly) TLClueType clueType;
@property (nonatomic, assign, readonly) BOOL isRead;
/*未读数量*/
@property (nonatomic, assign) NSInteger unreadCount;
- (void)updateUserInfo:(TLUser *)user;
- (void)updateGroupInfo:(TLGroup *)group;
@end
