//  TLMomentComment.h
//  Freedom
// Created by Super
#import "TLUser.h"
@interface TLMomentCommentFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@end
@interface TLMomentComment : NSObject
@property (nonatomic, strong) TLUser *user;
@property (nonatomic, strong) TLUser *toUser;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) TLMomentCommentFrame *commentFrame;
@end
