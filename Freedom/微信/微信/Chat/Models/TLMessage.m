//  TLMessage.m
//  Freedom
// Created by Super
#import "TLMessage.h"
@implementation TLMessageFrame
@end
@implementation TLMessage
+ (TLMessage *)createMessageByType:(TLMessageType)type{
    NSString *className;
    if (type == TLMessageTypeText) {
        className = @"TLTextMessage";
    }else if (type == TLMessageTypeImage) {
        className = @"TLImageMessage";
    }else if (type == TLMessageTypeExpression) {
        className = @"TLExpressionMessage";
    }
    if (className) {
        return [[NSClassFromString(className) alloc] init];
    }
    return nil;
}
- (id)init{
    if (self = [super init]) {
        self.messageID = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 10000)];
    }
    return self;
}
#pragma mark - Protocol
- (NSString *)conversationContent{
    return @"子类未定义";
}
- (NSString *)messageCopy{
    return @"子类未定义";
}
#pragma mark - 
- (NSMutableDictionary *)content{
    if (_content == nil) {
        _content = [[NSMutableDictionary alloc] init];
    }
    return _content;
}
@end
