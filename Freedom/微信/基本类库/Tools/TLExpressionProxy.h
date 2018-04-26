//  TLExpressionProxy.h
//  Freedom
// Created by Super
@interface TLExpressionProxy : NSObject
/*精选表情*/
- (void)requestExpressionChosenListByPageIndex:(NSInteger)page
                                       success:(void (^)(id data))success
                                       failure:(void (^)(NSString *error))failure;
/*竞选表情Banner*/
- (void)requestExpressionChosenBannerSuccess:(void (^)(id data))success
                                     failure:(void (^)(NSString *error))failure;
/*网络表情*/
- (void)requestExpressionPublicListByPageIndex:(NSInteger)page
                                       success:(void (^)(id data))success
                                       failure:(void (^)(NSString *error))failure;
/*表情搜索*/
- (void)requestExpressionSearchByKeyword:(NSString *)keyword
                                 success:(void (^)(id data))success
                                 failure:(void (^)(NSString *error))failure;
/*表情详情*/
- (void)requestExpressionGroupDetailByGroupID:(NSString *)groupID
                                    pageIndex:(NSInteger)pageIndex
                                      success:(void (^)(id data))success
                                      failure:(void (^)(NSString *error))failure;
@end
