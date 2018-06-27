//
//  SinaMode.m
//  Freedom
//
//  Created by Super on 2018/4/27.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "SinaMode.h"
@implementation SinaAccount
/*存储账号信息@param account 账号模型*/
+ (void)saveAccount:(SinaAccount *)account{
    // 自定义对象的存储必须用NSKeyedArchiver
    NSString *XFAccountPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"];
    [NSKeyedArchiver archiveRootObject:account toFile:XFAccountPath];
}
/*返回账号信息@return 账号模型（如果账号过期，返回nil）*/
+ (SinaAccount *)account{
    NSString *XFAccountPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"];
    SinaAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:XFAccountPath];
    /* 验证账号是否过期 */
    // 过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    // 获得过期时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    // 获得当前时间
    NSDate *now = [NSDate date];
    // 如果expiresTime <= now，过期
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending) { // 过期
        return nil;
    }
    return account;
}
+(instancetype)accountWithDict:(NSDictionary *)dict {
    
    SinaAccount *account = [[self alloc]init];
    
    account.access_token = dict[@"access_token"];
    account.uid = dict[@"uid"];
    account.expires_in = dict[@"expires_in"];
    // 获得账号存储的时间（accessToken的产生时间）
    account.created_time = [NSDate date];
    return account;
}
/*当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒*/
-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.created_time forKey:@"created_time"];
    [aCoder encodeObject:self.name forKey:@"name"];
    
}
/*当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）*/
-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.created_time = [aDecoder decodeObjectForKey:@"created_time"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        
    }
    
    return self;
}
@end

@implementation SinaMode
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon{
    SinaMode *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}
+ (instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithTitle:title icon:nil];
}
@end
