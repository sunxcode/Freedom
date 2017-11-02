//
//  TLRootProxy.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/13.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLRootProxy.h"

@implementation TLRootProxy

- (void)requestClientInitInfoSuccess:(void (^)(id)) clientInitInfo
                             failure:(void (^)(NSString *))error
{
    NSString *urlString = [TLHost clientInitInfoURL];
    [NetBase POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"OK");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"OK");
    }];
}

- (void)userLoginWithUsername:(NSString *)username
                     password:(NSString *)password
                      success:(void (^)(id))userInfo
                      failure:(void (^)(NSString *))error
{

}

@end
