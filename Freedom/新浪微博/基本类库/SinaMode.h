//
//  SinaMode.h
//  Freedom
//
//  Created by htf on 2018/4/27.
//  Copyright © 2018年 薛超. All rights reserved.
#import <Foundation/Foundation.h>
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
@end
//  用一个HMCommonItem模型来描述每行的信息：图标、标题、子标题、右边的样式（箭头、文字、数字、开关、打钩）
@interface SinaMode : NSObject
/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 子标题 */
@property (nonatomic, copy) NSString *subtitle;
/** 右边显示的数字标记 */
@property (nonatomic, copy) NSString *badgeValue;
/** 点击这行cell，需要调转到哪个控制器 */
@property (nonatomic, assign) Class destVcClass;
/** 封装点击这行cell想做的事情 */
// block 只能用 copy
@property (nonatomic, copy) void (^operation)();
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemWithTitle:(NSString *)title;
@end
