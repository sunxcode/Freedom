//
//  TLConversation.m
//  TLChat
//
//  Created by 李伯坤 on 16/1/23.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLConversation.h"
#import "TLGroup.h"
@implementation TLConversation

- (void)setConvType:(TLConversationType)convType
{
    _convType = convType;
    switch (convType) {
        case TLConversationTypePersonal:
        case TLConversationTypeGroup:
            _clueType = TLClueTypePointWithNumber;
            break;
        case TLConversationTypePublic:
        case TLConversationTypeServerGroup:
            _clueType = TLClueTypePoint;
            break;
        default:
            break;
    }
}

- (BOOL)isRead
{
    return self.unreadCount == 0;
}

- (void)updateUserInfo:(TLUser *)user
{
    self.partnerName = user.showName;
    self.avatarPath = user.avatarPath;
    self.avatarURL = user.avatarURL;
}

- (void)updateGroupInfo:(TLGroup *)group
{
    self.partnerName = group.groupName;
    self.avatarPath = group.groupAvatarPath;
}
@end
