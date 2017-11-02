//
//  TLImageMessage.m
//  TLChat
//
//  Created by libokun on 16/3/28.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLImageMessage.h"

@implementation TLImageMessage
@synthesize imagePath = _imagePath;
@synthesize imageURL = _imageURL;

#pragma mark -
- (NSString *)imagePath
{
    if (_imagePath == nil) {
        _imagePath = [self.content objectForKey:@"path"];
    }
    return _imagePath;
}
- (void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
    [self.content setObject:imagePath forKey:@"path"];
}

- (NSString *)imageURL
{
    if (_imageURL == nil) {
        _imageURL = [self.content objectForKey:@"url"];
    }
    return _imageURL;
}
- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    [self.content setObject:imageURL forKey:@"url"];
}

- (CGSize)imageSize
{
    CGFloat width = [[self.content objectForKey:@"w"] doubleValue];
    CGFloat height = [[self.content objectForKey:@"h"] doubleValue];
    return CGSizeMake(width, height);
}
- (void)setImageSize:(CGSize)imageSize
{
    [self.content setObject:[NSNumber numberWithDouble:imageSize.width] forKey:@"w"];
    [self.content setObject:[NSNumber numberWithDouble:imageSize.height] forKey:@"h"];
}

#pragma mark -
- (TLMessageFrame *)messageFrame
{
    if (kMessageFrame == nil) {
        kMessageFrame = [[TLMessageFrame alloc] init];
        kMessageFrame.height = 20 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0);

        CGSize imageSize = self.imageSize;
        if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
            kMessageFrame.contentSize = CGSizeMake(100, 100);
        }
        else if (imageSize.width > imageSize.height) {
            CGFloat height = WIDTH_SCREEN * 0.45 * imageSize.height / imageSize.width;
            height = height < WIDTH_SCREEN * 0.25 ? WIDTH_SCREEN * 0.25 : height;
            kMessageFrame.contentSize = CGSizeMake(WIDTH_SCREEN * 0.45, height);
        }
        else {
            CGFloat width = WIDTH_SCREEN * 0.45 * imageSize.width / imageSize.height;
            width = width < WIDTH_SCREEN * 0.25 ? WIDTH_SCREEN * 0.25 : width;
            kMessageFrame.contentSize = CGSizeMake(width, WIDTH_SCREEN * 0.45);
        }
        
        kMessageFrame.height += kMessageFrame.contentSize.height;
    }
    return kMessageFrame;
}

- (NSString *)conversationContent
{
    return @"[图片]";
}

- (NSString *)messageCopy
{
    return [self.content mj_JSONString];
}

@end
