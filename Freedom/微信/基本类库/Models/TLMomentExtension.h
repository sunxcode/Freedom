//  TLMomentExtension.h
//  Freedom
// Created by Super
#import "TLMomentComment.h"
@interface TLMomentExtensionFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightLiked;
@property (nonatomic, assign) CGFloat heightComments;
@end
@interface TLMomentExtension : NSObject
@property (nonatomic, strong) NSMutableArray *likedFriends;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) TLMomentExtensionFrame *extensionFrame;
@end
