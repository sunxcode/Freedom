//  TLUserHelper.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
#import "TLUser.h"
@interface TLUserHelper : NSObject
@property (nonatomic, strong) TLUser *user;
@property (nonatomic, strong, readonly) NSString *userID;
+ (TLUserHelper *) sharedHelper;
@end
