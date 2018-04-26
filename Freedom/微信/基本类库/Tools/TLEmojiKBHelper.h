//  TLEmojiKBHelper.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
#import "TLEmojiGroup.h"
@interface TLEmojiKBHelper : NSObject
+ (TLEmojiKBHelper *)sharedKBHelper;
- (void)emojiGroupDataByUserID:(NSString *)userID complete:(void (^)(NSMutableArray *))complete;
- (void)updateEmojiGroupData;
@end
