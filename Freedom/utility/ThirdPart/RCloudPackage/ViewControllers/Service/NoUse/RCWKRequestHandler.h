//
//  RCWKRequestHandler.h
//  RongIMDemo
//
//  Created by litao on 15/3/30.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//by Super 说明:这个对象只在WatchKit里面用
#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>
@protocol RCWKAppInfoProvider
- (NSString *)getAppName;
- (NSString *)getAppGroups;
- (NSArray *)getAllUserInfo;
- (NSArray *)getAllGroupInfo;
- (NSArray *)getAllFriends;
- (void)openParentApp;
- (BOOL)getNewMessageNotificationSound;
- (void)setNewMessageNotificationSound:(BOOL)on;
- (void)logout;
- (BOOL)getLoginStatus;
@end
@interface RCWKRequestHandler : NSObject
- (instancetype)initHelperWithUserInfo:(NSDictionary *)userInfo
                              provider:(id<RCWKAppInfoProvider>)provider
                                 reply:(void (^)(NSDictionary *))reply;
- (BOOL)handleWatchKitRequest;
@end
