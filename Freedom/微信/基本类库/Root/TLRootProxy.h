//
//  TLRootProxy.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/13.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

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
