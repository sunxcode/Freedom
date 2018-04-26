//  TLMomentComment.m
//  Freedom
// Created by Super
#import "TLMomentComment.h"
@implementation TLMomentComment
- (id)init{
    if (self = [super init]) {
        [TLMomentComment mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"user" : @"TLUser",
                      @"toUser" : @"TLUser"};
        }];
    }
    return self;
}
#pragma mark - 
- (TLMomentCommentFrame *)commentFrame{
    if (_commentFrame == nil) {
        _commentFrame = [[TLMomentCommentFrame alloc] init];
        _commentFrame.height = 35.0f;
    }
    return _commentFrame;
}
@end
@implementation TLMomentCommentFrame
@end
