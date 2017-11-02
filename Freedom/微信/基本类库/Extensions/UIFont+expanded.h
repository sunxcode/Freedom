//
//  UIFont+expanded.h
//  Created by 薛超 on 17/1/18.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (expanded)
#pragma mark - Common
+ (UIFont *)fontNavBarTitle;

#pragma mark - Conversation
+ (UIFont *)fontConversationUsername;
+ (UIFont *)fontConversationDetail;
+ (UIFont *)fontConversationTime;

#pragma mark - Friends
+ (UIFont *) fontFriendsUsername;

#pragma mark - Mine
+ (UIFont *)fontMineNikename;
+ (UIFont *)fontMineUsername;

#pragma mark - Setting
+ (UIFont *)fontSettingHeaderAndFooterTitle;


#pragma mark - Chat
+ (UIFont *)fontTextMessageText;
@end
