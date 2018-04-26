//  TLUser.h
//  Freedom
// Created by Super
#import "TLChatUserProtocol.h"
@interface TLUserSetting : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL star;
@property (nonatomic, assign) BOOL dismissTimeLine;
@property (nonatomic, assign) BOOL prohibitTimeLine;
@property (nonatomic, assign) BOOL blackList;
@end
@interface TLUserDetail : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *qqNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSArray *albumArray;
@property (nonatomic, strong) NSString *motto;
@property (nonatomic, strong) NSString *momentsWallURL;
/// 备注信息
@property (nonatomic, strong) NSString *remarkInfo;
/// 备注图片（本地地址）
@property (nonatomic, strong) NSString *remarkImagePath;
/// 备注图片 (URL)
@property (nonatomic, strong) NSString *remarkImageURL;
/// 标签
@property (nonatomic, strong) NSMutableArray *tags;
@end
@interface TLUserChatSetting : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL top;
@property (nonatomic, assign) BOOL noDisturb;
@property (nonatomic, strong) NSString *chatBGPath;
@end
@interface TLUser : NSObject<TLChatUserProtocol>
/// 用户ID
@property (nonatomic, strong) NSString *userID;
/// 用户名
@property (nonatomic, strong) NSString *username;
/// 昵称
@property (nonatomic, strong) NSString *nikeName;
/// 头像URL
@property (nonatomic, strong) NSString *avatarURL;
/// 头像Path
@property (nonatomic, strong) NSString *avatarPath;
/// 备注名
@property (nonatomic, strong) NSString *remarkName;
/// 界面显示名称
@property (nonatomic, strong, readonly) NSString *showName;
#pragma mark - 其他
@property (nonatomic, strong) TLUserDetail *detailInfo;
@property (nonatomic, strong) TLUserSetting *userSetting;
@property (nonatomic, strong) TLUserChatSetting *chatSetting;
#pragma mark - 列表用
/*拼音  
 *
 *  来源：备注 > 昵称 > 用户名*/
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *pinyinInitial;
@end
