//  FreedomTools.h
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
@class WXGroup;
@class SinaAccount;
@interface FreedomTools : NSObject
+ (CGFloat)getTextHeightOfText:(NSString *)text
                          font:(UIFont *)font
                         width:(CGFloat)width;
+ (void)createGroupAvatar:(WXGroup *)group
                 finished:(void (^)(NSString *groupID))finished;
+ (void)captureScreenshotFromView:(UIView *)view
                             rect:(CGRect)rect
                         finished:(void (^)(NSString *avatarPath))finished;
+ (NSDate *)strToDate:(NSString *)str;
+ (NSString *)getMinuteSecondWithSecond:(NSTimeInterval)time;
+ (UIImage *)imageWithOriginalName:(NSString *)imageName;
+ (UIImage *)imageWithStretchableName:(NSString *)imageName;
/// 正则判断字符串是否是中文
+ (BOOL)isChinese:(NSString *)str;
+ (void)show:(NSString *)msg;
/*获取URL的单例*/
+(FreedomTools *)sharedManager;
/*主界面的数据*/
-(NSString *)urlWithHomeData;
/*分类的数据*/
-(NSString *)urlWithclassifyData;
/*发现的数据*/
-(NSString *)urlWithDiscoverData;
/*订阅的数据*/
-(NSString *)urlWithSubscribeData;
/*视频详情 */
-(NSString*)urlWithVideoDetailData:(NSString *)iid;
/*视频链接*/
-(NSString*)urlWithVideo:(NSString *)iid;
/*视频推荐*/
-(NSString *)urlWithRecommentdata:(NSString *)iid;
/*简书数据*/
-(NSString *)urlWithJianShuData;
@property (nonatomic, strong) NSString *version;
/*存储账号信息@param account 账号模型*/
+ (void)saveAccount:(SinaAccount *)account;
/*返回账号信息 @return 账号模型（如果账号过期，返回nil）*/
+ (SinaAccount *)account;
+ (NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString;
+ (NSMutableArray *)matchMobileLink:(NSString *)pattern;
+ (NSMutableArray *)matchWebLink:(NSString *)pattern;
@end
