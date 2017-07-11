//
//  NetWork.m
//  JF团购
//
//  Created by 保修一站通 on 15/8/15.
//  Copyright (c) 2015年 JF团购. All rights reserved.
////  项目详解：
//  github:https://github.com/tubie/JFTudou
//  简书：http://www.jianshu.com/p/2156ec56c55b


#import "NetWork.h"
@implementation NetWork

+(void)sendGetUrl:(NSString *)url withParams:(NSDictionary *)params success:(successBlock) success failure:(failureBlock)failure
{
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetEngine GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

+(void)sendGetByReplacingUrl:(NSString *)url withParams:(NSDictionary *)params success:(successBlock) success failure:(failureBlock)failure
{
    NSString *urlStr = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetEngine GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}


@end
