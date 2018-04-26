//  TLMoment.m
//  Freedom
// Created by Super
#import "TLMoment.h"
@implementation TLMoment
- (id)init{
    if (self = [super init]) {
        [TLMoment mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"user" : @"TLUser",
                      @"detail" : @"TLMomentDetail",
                      @"extension" : @"TLMomentExtension"};
        }];
    }
    return self;
}
#pragma mark - 
- (TLMomentFrame *)momentFrame{
    if (_momentFrame == nil) {
        _momentFrame = [[TLMomentFrame alloc] init];
        _momentFrame.height = 76.0f;
        _momentFrame.height += _momentFrame.heightDetail = self.detail.detailFrame.height;  // 正文高度
        _momentFrame.height += _momentFrame.heightExtension = self.extension.extensionFrame.height;   // 拓展高度
    }
    return _momentFrame;
}
@end
@implementation TLMomentFrame
@end
