//  TLMessageProtocol.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
@protocol TLMessageProtocol <NSObject>
- (NSString *)messageCopy;
- (NSString *)conversationContent;
@end
