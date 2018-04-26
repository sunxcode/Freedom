//  TLMessageManager.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
#import "TLDBMessageStore.h"
#import "TLDBConversationStore.h"
#import "TLMessage.h"
@protocol TLMessageManagerConvVCDelegate <NSObject>
- (void)updateConversationData;
@end
@interface TLMessageManager : NSObject
@property (nonatomic, assign) id messageDelegate;
@property (nonatomic, assign) id<TLMessageManagerConvVCDelegate>conversationDelegate;
@property (nonatomic, strong, readonly) NSString *userID;
@property (nonatomic, strong) TLDBMessageStore *messageStore;
@property (nonatomic, strong) TLDBConversationStore *conversationStore;
+ (TLMessageManager *)sharedInstance;
#pragma mark - 发送
- (void)sendMessage:(TLMessage *)message
           progress:(void (^)(TLMessage *, CGFloat))progress
            success:(void (^)(TLMessage *))success
            failure:(void (^)(TLMessage *))failure;
#pragma mark - 查询
/*查询聊天记录*/
- (void)messageRecordForPartner:(NSString *)partnerID
                       fromDate:(NSDate *)date
                          count:(NSUInteger)count
                       complete:(void (^)(NSArray *, BOOL))complete;
/*查询聊天文件*/
- (void)chatFilesForPartnerID:(NSString *)partnerID
                    completed:(void (^)(NSArray *))completed;
/*查询聊天图片*/
- (void)chatImagesAndVideosForPartnerID:(NSString *)partnerID
                              completed:(void (^)(NSArray *))completed;
#pragma mark - 删除
/*删除单条聊天记录*/
- (BOOL)deleteMessageByMsgID:(NSString *)msgID;
/*删除与某好友的聊天记录*/
- (BOOL)deleteMessagesByPartnerID:(NSString *)partnerID;
/*删除所有聊天记录*/
- (BOOL)deleteAllMessages;
- (BOOL)addConversationByMessage:(TLMessage *)message;
- (void)conversationRecord:(void (^)(NSArray *))complete;
- (BOOL)deleteConversationByPartnerID:(NSString *)partnerID;
@end
