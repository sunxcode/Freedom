//  TLEmoji.m
//  Freedom
// Created by Super
#import "TLEmoji.h"
@implementation TLEmoji
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"emojiID" : @"pId",
             @"emojiURL" : @"Url",
             @"emojiName" : @"credentialName",
             @"emojiPath" : @"imageFile",
             @"size" : @"size",
             };
}
- (NSString *)emojiPath{
    if (_emojiPath == nil) {
        NSString *groupPath = [NSFileManager pathExpressionForGroupID:self.groupID];
        _emojiPath = [NSString stringWithFormat:@"%@%@", groupPath, self.emojiID];
    }
    return _emojiPath;
}
@end
