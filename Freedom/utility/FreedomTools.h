//  FreedomTools.h
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RCloudModel.h"
@interface ChineseToPinyin : NSObject
@property(strong,nonatomic)NSString *string;
@property(strong,nonatomic)NSString *pinYin;
//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;
//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr;
//返回一组字母排序数组(中英混排)
+(NSMutableArray*)SortArray:(NSArray*)stringArr;
char pinyinFirstLetter(unsigned short hanzi);
+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (NSString *) firstPinyinFromChinise:(NSString *)string;

+ (char) sortSectionTitle:(NSString *)string;
@end

@interface FreedomTools : NSObject
+(FreedomTools *)sharedManager;
//验证手机号码
+ (BOOL)validateMobile:(NSString *)mobile;
//验证电子邮箱
+ (BOOL)validateEmail:(NSString *)email;
//验证密码
+ (BOOL)validatePassword:(NSString *)password;
+ (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName;
+ (NSString *)defaultGroupPortrait:(RCGroup *)groupInfo;
+ (NSString *)defaultUserPortrait:(RCUserInfo *)userInfo;
+ (NSString *)getIconCachePath:(NSString *)fileName;
+ (NSString *)hanZiToPinYinWithString:(NSString *)hanZi;
+ (NSString *)getFirstUpperLetter:(NSString *)hanzi;
+ (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)userList;
+ (BOOL)isContains:(NSString *)firstString withString:(NSString *)secondString;
+ (UIImage*) getImageWithColor:(UIColor*)color andHeight:(CGFloat)height;
+ (UIBarButtonItem *)barButtonItemContainImage:(UIImage *)buttonImage imageViewFrame:(CGRect)imageFrame buttonTitle:(NSString *)buttonTitle titleColor:(UIColor*)titleColor titleFrame:(CGRect)titleFrame buttonFrame:(CGRect)buttonFrame target:(id)target action:(SEL)method;
/// 正则判断字符串是否是中文
+ (BOOL)isChinese:(NSString *)str;
+ (void)show:(NSString *)msg;

//通过自己Id获取自己的用户信息
- (void)getUserInfo:(NSString *)userId completion:(void (^)(RCUserInfo *))completion;
//通过好友Id获取好友的用户信息
- (void)getFriendInfo:(NSString *)friendId completion:(void (^)(RCUserInfo *))completion;
//通过好友Id从数据库中获取好友的用户信息
- (RCUserInfo *)getFriendInfoFromDB:(NSString *)friendId;
//如有好友备注，则显示备注
-(NSArray *)getFriendInfoList:(NSArray *)friendList;
//通过userId设置默认的用户信息
- (RCUserInfo *)generateDefaultUserInfo:(NSString *)userId;

@end
