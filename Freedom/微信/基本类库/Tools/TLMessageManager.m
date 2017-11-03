//
//  TLMessageManager.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/13.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLMessageManager.h"
#import "TLChatViewController.h"

#import "TLUserHelper.h"
static TLMessageManager *messageManager;

@implementation TLMessageManager

+ (TLMessageManager *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        messageManager = [[TLMessageManager alloc] init];
    });
    return messageManager;
}

- (void)sendMessage:(TLMessage *)message
           progress:(void (^)(TLMessage *, CGFloat))progress
            success:(void (^)(TLMessage *))success
            failure:(void (^)(TLMessage *))failure
{
    BOOL ok = [self.messageStore addMessage:message];
    if (!ok) {
        DLog(@"存储Message到DB失败");
    }
    else {      // 存储到conversation
        ok = [self addConversationByMessage:message];
        if (!ok) {
            DLog(@"存储Conversation到DB失败");
        }
    }
}


#pragma mark - Getter -
- (TLDBMessageStore *)messageStore
{
    if (_messageStore == nil) {
        _messageStore = [[TLDBMessageStore alloc] init];
    }
    return _messageStore;
}

- (TLDBConversationStore *)conversationStore
{
    if (_conversationStore == nil) {
        _conversationStore = [[TLDBConversationStore alloc] init];
    }
    return _conversationStore;
}

- (NSString *)userID
{
    return [TLUserHelper sharedHelper].userID;
}

- (BOOL)addConversationByMessage:(TLMessage *)message
{
    NSString *partnerID = message.friendID;
    NSInteger type = 0;
    if (message.partnerType == TLPartnerTypeGroup) {
        partnerID = message.groupID;
        type = 1;
    }
    BOOL ok = [self.conversationStore addConversationByUid:message.userID fid:partnerID type:type date:message.date];
    
    return ok;
}

- (void)conversationRecord:(void (^)(NSArray *))complete
{
    NSArray *data = [self.conversationStore conversationsByUid:self.userID];
    complete(data);
}

- (BOOL)deleteConversationByPartnerID:(NSString *)partnerID
{
    BOOL ok = [self deleteMessagesByPartnerID:partnerID];
    if (ok) {
        ok = [self.conversationStore deleteConversationByUid:self.userID fid:partnerID];
    }
    return ok;
}

- (void)messageRecordForPartner:(NSString *)partnerID
                       fromDate:(NSDate *)date
                          count:(NSUInteger)count
                       complete:(void (^)(NSArray *, BOOL))complete
{
    [self.messageStore messagesByUserID:self.userID partnerID:partnerID fromDate:date count:count complete:^(NSArray *data, BOOL hasMore) {
        complete(data, hasMore);
    }];
}

- (void)chatFilesForPartnerID:(NSString *)partnerID
                    completed:(void (^)(NSArray *))completed
{
    NSArray *data = [self.messageStore chatFilesByUserID:self.userID partnerID:partnerID];
    completed(data);
}

- (void)chatImagesAndVideosForPartnerID:(NSString *)partnerID
                              completed:(void (^)(NSArray *))completed

{
    NSArray *data = [self.messageStore chatImagesAndVideosByUserID:self.userID partnerID:partnerID];
    completed(data);
}

- (BOOL)deleteMessageByMsgID:(NSString *)msgID
{
    return [self.messageStore deleteMessageByMessageID:msgID];
}

- (BOOL)deleteMessagesByPartnerID:(NSString *)partnerID
{
    BOOL ok = [self.messageStore deleteMessagesByUserID:self.userID partnerID:partnerID];
    if (ok) {
        [[TLChatViewController sharedChatVC] resetChatVC];
    }
    return ok;
}

- (BOOL)deleteAllMessages
{
    BOOL ok = [self.messageStore deleteMessagesByUserID:self.userID];
    if (ok) {
        [[TLChatViewController sharedChatVC] resetChatVC];
        ok = [self.conversationStore deleteConversationsByUid:self.userID];
    }
    return ok;
}

@end
