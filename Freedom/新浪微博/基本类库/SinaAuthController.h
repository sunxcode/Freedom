
//  Freedom
//  Created by Super on 15/9/20.
#import <UIKit/UIKit.h>
#import "SinaBaseViewController.h"
@interface SinaAccount : NSObject <NSCoding>
/**　string    用于调用access_token，接口获取授权后的access token。*/
@property (nonatomic, copy) NSString *access_token;
/**　string    access_token的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSNumber *expires_in;
/**　string    当前授权用户的UID。*/
@property (nonatomic, copy) NSString *uid;
/**    access token的创建时间 */
@property (nonatomic, strong) NSDate *created_time;
/** 用户昵称  */
@property (nonatomic,copy)NSString *name;
+ (instancetype)accountWithDict:(NSDictionary *)dict;
/*存储账号信息@param account 账号模型*/
+ (void)saveAccount:(SinaAccount *)account;
/*返回账号信息 @return 账号模型（如果账号过期，返回nil）*/
+ (SinaAccount *)account;
@end
@interface SinaAuthController : SinaBaseViewController
@end
