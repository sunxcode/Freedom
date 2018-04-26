//  TLAppHelper.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
@interface TLAppHelper : NSObject
@property (nonatomic, strong) NSString *version;
+ (TLAppHelper *)sharedHelper;
@end
