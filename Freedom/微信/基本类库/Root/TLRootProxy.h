//  TLRootProxy.h
//  Freedom
// Created by Super
#import "TLSettingGroup.h"
#import "TLGroup.h"
@interface TLRootProxy : NSObject
- (void)requestClientInitInfoSuccess:(void (^)(id))clientInitInfo
                             failure:(void (^)(NSString *))error;
- (void)userLoginWithUsername:(NSString *)username
                     password:(NSString *)password
                      success:(void (^)(id))userInfo
                      failure:(void (^)(NSString *))error;
- (NSMutableArray *)chatDetailDataByUserInfo:(TLUser *)userInfo;
- (NSMutableArray *)chatDetailDataByGroupInfo:(TLGroup *)groupInfo;
@end
