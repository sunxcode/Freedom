
#import <Foundation/Foundation.h>

#define default_pwd @"default_pwd"
#define default_userName @"default_userName"
#define default_userLogo @"default_userLogo"
#define default_userId @"default_userId"
#define default_userToken @"default_userToken"
#define default_userAccount @"default_userAccount"
#define default_userAddress @"default_userAddress"
#define default_userstatus @"default_userstatus"
#define default_useriscard @"default_useriscard"
#define default_userallmony @"default_userallmony"
#define default_usercanusermony @"default_usercanusermony"
#define default_userphone @"default_userphone"
#define default_useridcard @"default_useridcard"
#define default_setDefaultStartVibrate @"default_setDefaultStartVibrate"
#define default_setDefaultplaySystemSound @"default_setDefaultplaySystemSound"

#import "CustomTabBar.h"
@class BaseViewController;
#import "BaseViewController.h"
//#import "SRWebSocket.h"
//#import <AlipaySDK/AlipaySDK.h>//支付宝

//1成功 0失败 2未知错误
typedef void (^LoginSuc)(NSInteger NoLogin);
typedef void (^DownloadNewData)(BOOL isSuccess);

@interface Utility : NSObject
//启用缓存
@property (nonatomic,assign) BOOL offline;

+(id)Share;
+ (void)alertError:(NSString*)content;
+ (void)alertSuccess:(NSString*)content;
- (void)alert:(NSString*)content;
- (void)alert:(NSString*)content delegate:(id)delegate;
- (NSString*)timeToNow:(NSString*)theDate;
- (BOOL) validateEmail: (NSString *) candidate ;
- (BOOL) validateTel: (NSString *) candidate ;
- (void) makeCall:(NSString *)phoneNumber;

+ (BOOL)removeForArrayObj:(id)obj forKey:(NSString*)key;
+ (void)saveToDefaults:(id)obj forKey:(NSString*)key;
+ (void)saveToArrayDefaults:(id)obj forKey:(NSString*)key;
+ (void)saveToArrayDefaults:(id)obj replace:(id)oldobj forKey:(NSString*)key;

+ (id)defaultsForKey:(NSString*)key;
+ (void)removeForKey:(NSString*)key;

//用户相关
@property (nonatomic, strong) NSString *userAccount;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userGroupId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPwd;
@property (nonatomic, strong) NSString *userLogo;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *userAddress;
@property (nonatomic, strong) NSString *userMobile;
@property (nonatomic, strong) NSString *userlongitude;
@property (nonatomic, strong) NSString *userlatitude;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, strong) NSString *userroom_id;
@property (nonatomic, strong) NSString *userSign;
@property (nonatomic, strong) NSString *usermony;
@property (nonatomic, strong) NSString *userstatus;
@property (nonatomic, strong) NSString *useriscards;
@property (nonatomic, strong) NSString *userallmony;
@property (nonatomic, strong) NSString *usercanusermony;
@property (nonatomic, strong) NSString *userphone;
@property (nonatomic, strong) NSString *useridcard;
-(void)renzhenghh;

@property(nonatomic,weak)BaseViewController* currentViewController;
//@property (nonatomic,strong) NSString *userNemberId;////绑定设备的id
//@property (nonatomic,assign) BOOL userBluetoothBinding;////绑定设备

@property (nonatomic, assign) BOOL boolAnimationHidden;
@property (nonatomic, assign) BOOL isMan;
@property (nonatomic, assign) BOOL isPushEnable;

@property (nonatomic,assign ) BOOL isAlertViewFlag;//弹出类型设置
@property (nonatomic, strong) NSString *deviceNum;

@property (nonatomic, strong) LoginSuc loginSuc;
@property (nonatomic, strong) DownloadNewData loadNewData;
//
@property (nonatomic, strong) NSMutableDictionary *badgeViewDict;

@property (nonatomic,strong)CustomTabBar *CustomTabBar_zk;

//@property(nonatomic,strong)SRWebSocket *srWebSocket;

@property (nonatomic, assign) BOOL isDefaultNOStartSystemShake;//是否开启振动
@property (nonatomic, assign) BOOL isNOStartVibrate;
@property (nonatomic, assign) BOOL isDefaultNOplaySystemSound;//是否开启声音
@property (nonatomic, assign) BOOL isNOplaySystemSound;



+(id)uid;
-(void)ShowMessage:(NSString *)title msg:(NSString *)msg;
-(void)hiddenMessageAlert;
-(void)isLoginAccount:(NSString *)account pwd:(NSString *)password aLogin:(LoginSuc)aLoginSuc;


-(void)isLogin:(LoginSuc)aLoginSuc;
-(BOOL)isLogin;



-(void)loginWithAccount:(NSString *)account pwd:(NSString *)password;
-(void)registerWithAccount:(NSString *)account pwd:(NSString *)password authorCode:(NSString *)code;
//-(void)registerWithAccount:(NSString *)account code:(NSString *)aCode pwd:(NSString *)password name:(NSString *)name sex:(BOOL)isMan;
//获取内存地址
-(NSString *)getAddressBy:(NSString *)description;
- (BOOL)isAvailableIOS:(CGFloat)availableVersion;
//-(NSString*)blowfish:(NSString*)password;
//登陆注册
- (void)showLoginAlert:(BOOL)abool;
- (void)hiddenLoginAlert;
//刷新push enable
- (void)reloadIsPushEnable;
//用户本地数据
-(void)saveUserInfoToDefault;
-(void)readUserInfoFromDefault;
-(void)clearUserInfoInDefault;
//清除本地数据库
-(void)removeSqlData;

///改变时间格式yy/MM/dd HH:mm
- (NSString*)time_ChangeTheFormat:(NSString*)theDate;
-(NSInteger )time_Age:(NSString *)theDate;//年龄计算
///计算时间差
-(NSInteger)ACtimeToNow:(NSString*)theDate;
////data-固定格式时间yy/MM/dd
-(NSString *)timeToFormatConversion:(NSString *)aDate;

////时间戳
-(NSString *)timeToTimestamp:(NSString *)timestamp;
////刚刚。。。。
-(NSString *)time_strDate:(NSString *)theDate;
///时间
- (NSString*)timeToNow_zk:(NSString*)theDate;

///通过时间戳计算生日
- (NSString*)birthdayWithTime:(NSString *)timestamp;

//
-(void)getUserIdByDeviceNum;

///处理图片大小
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
//通过颜色来生成一个纯色图片
- (UIImage *)imageFromColor:(UIColor *)color rect:(CGSize )aSize;

///类似qq聊天窗口的抖动效果
-(void)viewAnimations:(UIView *)aV;

///view 左右抖动
-(void)leftRightAnimations:(UIView *)view;
///背景view
- (UIView*)tipsView:(NSString*)str;
///圆角或椭圆
-(void)viewLayerRound:(UIView *)view borderWidth:(float)width borderColor:(UIColor *)color;

//讯飞
//-(void)iflyView:(NSString *)str;

///获取当前app版本
-(NSString *)VersionSelect;
//更新版本
- (void)upDataVersion;
-(void)VersionNew;

///判断是否为整形：
- (BOOL)isPureInt:(NSString*)string;
///判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string;


//////////////数据格式化
//格式化电话号码
-(NSString *)ACFormatPhone:(NSString *)str;
//格式化手机号
-(NSString *)ACFormatMobile:(NSString *)str;
//格式化身份证号
-(NSString *)ACFormatIDC:(NSString *)str;
//格式化组织机构代码证
-(NSString *)ACFormatOCC:(NSString *)str;
//格式化车牌号
-(NSString *)ACFormatPlate:(NSString *)str;
//格式化vin
-(NSString *)ACFormatVin:(NSString *)str;
//------数字格式化----------------
-(NSString*)ACFormatNumStr:(NSString*)nf;

//格式化身份证号2
-(NSString *)ACFormatIDC_DH:(NSString *)str;
//格式化vin2
-(NSString *)ACFormatVin_DH:(NSString *)str;

//定位
-(void)loadUserLocation;

//-(void)paymentResult:(NSString *)result;
//-(void)showAlipay:(id)data;

//-(void)WebSocketsend:(NSString *)strJson;
//-(void)websocketClose;
//- (void)WebSocketLogin;

//z振动
-(void)StartSystemShake;
//播放提示音
-(void)playSystemSound;

///启动过渡图片
-(void)showStartTransitionView;
-(void)hiddenStartTransitionView;

//是否支持蓝牙协议4.0
- (BOOL)whetherToSupportBluetoothProtocol;

////读取数据
//-(void)showDataSynchronizationView;
//-(void)hiddenDataSynchronizationView;

@end
