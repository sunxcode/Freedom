//
//  TLExpressionMessage.m
//  TLChat
//
//  Created by libokun on 16/3/28.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLExpressionMessage.h"

@implementation TLExpressionMessage
@synthesize emoji = _emoji;

- (void)setEmoji:(TLEmoji *)emoji
{
    _emoji = emoji;
    [self.content setObject:emoji.groupID forKey:@"groupID"];
    [self.content setObject:emoji.emojiID forKey:@"emojiID"];
    CGSize imageSize = [UIImage imageNamed:self.path].size;
    [self.content setObject:[NSNumber numberWithDouble:imageSize.width] forKey:@"w"];
    [self.content setObject:[NSNumber numberWithDouble:imageSize.height] forKey:@"h"];
}
- (TLEmoji *)emoji
{
    if (_emoji == nil) {
        _emoji = [[TLEmoji alloc] init];
        _emoji.groupID = self.content[@"groupID"];
        _emoji.emojiID = self.content[@"emojiID"];
    }
    return _emoji;
}

- (NSString *)path
{
    return self.emoji.emojiPath;
}

- (NSString *)url
{
    return [TLHost expressionDownloadURLWithEid:self.emoji.emojiID];
}

- (CGSize)emojiSize
{
    CGFloat width = [self.content[@"w"] doubleValue];
    CGFloat height = [self.content[@"h"] doubleValue];
    return CGSizeMake(width, height);
}

#pragma mark -
- (TLMessageFrame *)messageFrame
{
    if (kMessageFrame == nil) {
        kMessageFrame = [[TLMessageFrame alloc] init];
        kMessageFrame.height = 20 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0);
        
        kMessageFrame.height += 5;
        
        CGSize emojiSize = self.emojiSize;
        if (CGSizeEqualToSize(emojiSize, CGSizeZero)) {
            kMessageFrame.contentSize = CGSizeMake(80, 80);
        }
        else if (emojiSize.width > emojiSize.height) {
            CGFloat height = WIDTH_SCREEN * 0.35 * emojiSize.height / emojiSize.width;
            height = height < WIDTH_SCREEN * 0.2 ? WIDTH_SCREEN * 0.2 : height;
            kMessageFrame.contentSize = CGSizeMake(WIDTH_SCREEN * 0.35, height);
        }
        else {
            CGFloat width = WIDTH_SCREEN * 0.35 * emojiSize.width / emojiSize.height;
            width = width < WIDTH_SCREEN * 0.2 ? WIDTH_SCREEN * 0.2 : width;
            kMessageFrame.contentSize = CGSizeMake(width, WIDTH_SCREEN * 0.35);
        }
    
        kMessageFrame.height += kMessageFrame.contentSize.height;
    }
    return kMessageFrame;
}

- (NSString *)conversationContent
{
    return @"[表情]";
}

- (NSString *)messageCopy
{
    return [self.content mj_JSONString];
}

@end
