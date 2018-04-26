
//  TLUser.m
//  Freedom
// Created by Super
#import "TLUser.h"
#import "NSString+expanded.h"
@implementation TLUserChatSetting
@end
@implementation TLUserDetail
@end
@implementation TLUserSetting
@end
@implementation TLUser
- (id)init{
    if (self = [super init]) {
        [TLUser mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"detailInfo" : @"TLUserDetail",
                      @"userSetting" : @"TLUserSetting",
                      @"chatSetting" : @"TLUserChatSetting",};
        }];
    }
    return self;
}
- (void)setUsername:(NSString *)username{
    if ([username isEqualToString:_username]) {
        return;
    }
    _username = username;
    if (self.remarkName.length == 0 && self.nikeName.length == 0 && self.username.length > 0) {
        self.pinyin = username.pinyin;
        self.pinyinInitial = username.pinyinInitial;
    }
}
- (void)setNikeName:(NSString *)nikeName{
    if ([nikeName isEqualToString:_nikeName]) {
        return;
    }
    _nikeName = nikeName;
    if (self.remarkName.length == 0 && self.nikeName.length > 0) {
        self.pinyin = nikeName.pinyin;
        self.pinyinInitial = nikeName.pinyinInitial;
    }
}
- (void)setRemarkName:(NSString *)remarkName{
    if ([remarkName isEqualToString:_remarkName]) {
        return;
    }
    _remarkName = remarkName;
    if (_remarkName.length > 0) {
        self.pinyin = remarkName.pinyin;
        self.pinyinInitial = remarkName.pinyinInitial;
    }
}
#pragma mark - Getter
- (NSString *)showName{
    return self.remarkName.length > 0 ? self.remarkName : (self.nikeName.length > 0 ? self.nikeName : self.username);
}
- (TLUserDetail *)detailInfo{
    if (_detailInfo == nil) {
        _detailInfo = [[TLUserDetail alloc] init];
    }
    return _detailInfo;
}
- (NSString *)chat_userID{
    return self.userID;
}
- (NSString *)chat_username{
    return self.showName;
}
- (NSString *)chat_avatarURL{
    return self.avatarURL;
}
- (NSString *)chat_avatarPath{
    return self.avatarPath;
}
- (NSInteger)chat_userType{
    return TLChatUserTypeUser;
}
@end
