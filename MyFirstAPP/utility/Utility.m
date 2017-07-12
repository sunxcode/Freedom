
#import "Utility.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "JSONKit.h"
#import "BaseScrollView.h"
#import "NSDictionary+expanded.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>//振动
#import <UIKit/UIKit.h>
//#import <iflyMSC/IFlyRecognizerViewDelegate.h>
//#import <iflyMSC/IFlyRecognizerView.h>
#define picMidWidth 200
#define picSmallWidth 100
@interface Utility ()<CLLocationManagerDelegate>{//<IFlyRecognizerViewDelegate>
    UITextField *accountField,*passField;
    NSString *phoneNum;
 //   IFlyRecognizerView     *_iflyRecognizerView;
    NSString *strIFlyType;
    CLLocationManager *locManager;
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
    NSString *packPath;
    BaseScrollView *startView;
    UIButton *hideButton;
}
@property (nonatomic,strong) NSURL *phoneNumberURL;
@property (nonatomic,strong) Reachability *reachability;
@end

@implementation Utility
static Utility *_utilityinstance=nil;
static dispatch_once_t utility;
+(id)Share{
    dispatch_once(&utility, ^ {
        _utilityinstance = [[Utility alloc] init];
        _utilityinstance.userIP=[self getMacAddress].md5;
    });return _utilityinstance;
}
- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarDidChangeFrame:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }return self;
}
+(NSString *)getMacAddress{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else{
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)errorFlag = @"sysctl mgmtInfoBase failure";
        else{
            if ((msgBuffer = malloc(length)) == NULL)   errorFlag = @"buffer allocation failure";
            else{
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    if (errorFlag != NULL){free(msgBuffer);   return errorFlag;}
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    free(msgBuffer);
    return macAddressString;
}

- (BOOL)offline{
    return ![[AFNetworkReachabilityManager sharedManager] isReachable];
}
+ (void)saveArrayToDefaults:(id)obj forKey:(NSString *)key{
    [self saveArrayToDefaults:obj replace:obj forKey:key];
}
+ (void)saveArrayToDefaults:(id)obj replace:(id)oldobj forKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults valueForKey:key];
    NSMutableArray *marray = [NSMutableArray array];
    if (!oldobj) { oldobj = obj;}
    if (array) {
        [marray addObjectsFromArray:array];
        if ([marray containsObject:oldobj]) {
            [marray replaceObjectAtIndex:[marray indexOfObject:oldobj] withObject:obj];
        }else{
            [marray addObject:obj];
        }
    }else{
      [marray addObject:obj];  
    }
    [defaults setValue:marray forKey:key];
    [defaults synchronize];
}

+ (BOOL)removeArrayObj:(id)obj fordefaultsKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults valueForKey:key];
    NSMutableArray *marray = [NSMutableArray array];
    if (array) {
        [marray addObjectsFromArray:array];
        if ([marray containsObject:obj]) {
            [marray removeObject:obj];
        }
    }
    if (marray.count) {
        [defaults setValue:marray forKey:key];
    }else{
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];
    return marray.count;
}
#pragma mark makeCall
- (void) makeCall:(NSString *)phoneNumber{
    phoneNum=[[[[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]
                             stringByReplacingOccurrencesOfString:@"-" withString:@""]
                            stringByReplacingOccurrencesOfString:@"(" withString:@""]
                           stringByReplacingOccurrencesOfString:@")" withString:@""];
    if ([phoneNum intValue]!=0) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNum]]];
    }else {
       [SVProgressHUD showErrorWithStatus:@"无效号码"];
        return;
    }
}

#pragma mark 数据更新
-(void)saveUserInfoToDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.userAccount forKey: USERACCOUNT ];
    [defaults setValue:self.userId forKey: USERID ];
    [defaults setValue:self.userName forKey: USERNAME ];
    [defaults setValue:self.userPwd forKey: USERPWD ];
    [defaults setValue:self.userLogo forKey: USERLOGO ];
    [defaults setValue:self.userToken forKey: USERTOKEN ];
    [defaults setValue:self.userAddress forKey: USERADDRESS ];
    [defaults setValue:self.userlongitude forKey: USERLONGITUDE ];
    [defaults setValue:self.userlatitude forKey: USERLATITUDE ];
    [defaults setValue:self.usertype forKey: USERTYPE ];
    [defaults setValue:self.userSign forKey: USERSIGN ];
    [defaults setValue:self.usermony forKey: USERMONY ];
    [defaults setValue:self.userstatus forKey: USERSTATUS ];
    [defaults setValue:self.usercards forKey: USERCARDS ];
    [defaults setValue:self.userphone forKey: USERPHONE ];
    [defaults setValue:self.useridcard forKey: USERIDCARD ];
    [defaults setValue:self.userWechartnum forKey: USERWECHARTNUM ];
    [defaults setValue:self.userQQnumber forKey: USERQQNUMBER ];
    [defaults setValue:self.userSex forKey: USERSEX ];
    [defaults setValue:self.userAge forKey: USERAGE ];
    [defaults setValue:self.userProtect forKey: USERPROTECT ];
    [defaults setValue:self.userEmail forKey: USEREMAIL ];
    [defaults setValue:self.userDevices forKey: USERDEVICES ];
    [defaults setValue:self.userSystem forKey: USERSYSTEM ];
    [defaults setValue:self.userIP forKey: USERIP ];
    [defaults setValue:self.userRealName forKey: USERREALNAME ];
    
    [defaults synchronize];
}
-(void)readUserInfoFromDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self setUserAccount:[defaults valueForKey: USERACCOUNT ]];
    [self setUserId:[defaults valueForKey: USERID ]];
    [self setUserName:[defaults valueForKey: USERNAME ]];
    [self setUserPwd:[defaults valueForKey: USERPWD ]];
    [self setUserLogo:[defaults valueForKey: USERLOGO ]];
    [self setUserToken:[defaults valueForKey: USERTOKEN ]];
    [self setUserAddress:[defaults valueForKey: USERADDRESS ]];
    [self setUserlongitude:[defaults valueForKey: USERLONGITUDE ]];
    [self setUserlatitude:[defaults valueForKey: USERLATITUDE ]];
    [self setUsertype:[defaults valueForKey: USERTYPE ]];
    [self setUserSign:[defaults valueForKey: USERSIGN ]];
    [self setUsermony:[defaults valueForKey: USERMONY ]];
    [self setUserstatus:[defaults valueForKey: USERSTATUS ]];
    [self setUsercards:[defaults valueForKey: USERCARDS ]];
    [self setUserphone:[defaults valueForKey: USERPHONE ]];
    [self setUseridcard:[defaults valueForKey: USERIDCARD ]];
    [self setUserWechartnum:[defaults valueForKey: USERWECHARTNUM ]];
    [self setUserQQnumber:[defaults valueForKey: USERQQNUMBER ]];
    [self setUserSex:[defaults valueForKey: USERSEX ]];
    [self setUserAge:[defaults valueForKey: USERAGE ]];
    [self setUserProtect:[defaults valueForKey: USERPROTECT ]];
    [self setUserEmail:[defaults valueForKey: USEREMAIL ]];
    [self setUserDevices:[defaults valueForKey: USERDEVICES ]];
    [self setUserSystem:[defaults valueForKey: USERSYSTEM ]];
    [self setUserIP:[defaults valueForKey: USERIP ]];
    [self setUserRealName:[defaults valueForKey: USERREALNAME ]];
}
-(void)clearUserInfoInDefault{
    self.userAccount=
    self.userId=
    self.userName=
    self.userPwd=
    self.userLogo=
    self.userToken=
    self.userAddress=
    self.userlongitude=
    self.userlatitude=
    self.usertype=
    self.userSign=
    self.usermony=
    self.userstatus=
    self.usercards=
    self.userphone=
    self.useridcard=
    self.userWechartnum=
    self.userQQnumber=
    self.userSex=
    self.userAge=
    self.userProtect=
    self.userEmail=
    self.userDevices=
    self.userSystem=
    
    nil;
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict){
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    //消除用户资料
   // delete from tabname(表名)
   // [ZKSqlData deleteSqlData];
}
#pragma mark 登录
-(void)isLoginAccount:(NSString *)account pwd:(NSString *)password aLogin:(LoginSuc)aLoginSuc{
    self.loginSuc = aLoginSuc;
    [self loginWithAccount:account pwd:password];
}

- (void)showLoginAlert{
    UINavigationController *curNav = [[[[Utility Share] CustomTabBar_zk] viewControllers] objectAtIndex:[[[Utility Share] CustomTabBar_zk]selectedIndex]];
    LoginViewController *login=[[LoginViewController alloc]init];
    login.userInfo=@"againLogin";
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:login];
    [curNav presentViewController:nav animated:YES completion:nil];
}

- (void)hiddenLoginAlert{
    UINavigationController *curNav = [[[[Utility Share] CustomTabBar_zk] viewControllers] objectAtIndex:[[[Utility Share] CustomTabBar_zk]selectedIndex]];
    [curNav dismissViewControllerAnimated:YES completion:^{
        self.loginSuc?self.loginSuc(1):nil;
    }];
}
-(void)isLogin:(LoginSuc)aLoginSuc{
    self.loginSuc = aLoginSuc;
    if ([_userId notEmptyOrNull] && [_userToken notEmptyOrNull]) {
        //登录过-验证token是否过期
        [NetBase POST:@"" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject valueForJSONKey:@"status"] isEqualToString:@"200"]) {
                //没过期
                self.loginSuc?self.loginSuc(1):nil;
                self.loginSuc = nil;
            }else{  //过期
                [self clearUserInfoInDefault];
                [self showLoginAlert];
                [SVProgressHUD showImage:nil status:[responseObject valueForJSONKey:@"info"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setValue:[self userId] forKey:@"uid"];
        [dict setValue:[self userToken] forKey:@"token"];
        [NetBase POST:@"" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject valueForJSONKey:@"status"] isEqualToString:@"200"]) {
                //没过期
                self.loginSuc?self.loginSuc(1):nil;
                self.loginSuc = nil;
            }else if ([[responseObject valueForJSONKey:@"status"] isEqualToString:@"501"]) {
                //过期
                [self clearUserInfoInDefault];
                [self showLoginAlert];
                [SVProgressHUD showErrorWithStatus:[responseObject valueForJSONKey:@"info"]];
            } else{
                [SVProgressHUD showErrorWithStatus:[responseObject valueForJSONKey:@"info"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
        self.loginSuc?self.loginSuc(1):nil;
        self.loginSuc = nil;
    }else[self showLoginAlert];
}

-(BOOL)isLogin{
    if ([_userId notEmptyOrNull]) {
        return YES;
    }else return NO;
}

//账号登录
-(void)loginWithAccount:(NSString *)account pwd:(NSString *)password{
    if (![account notEmptyOrNull]){[SVProgressHUD showErrorWithStatus:@"请填写账户"];return;}
    if (![password notEmptyOrNull]){[SVProgressHUD showErrorWithStatus:@"密码不能为空"];return;}
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:account,@"mobile",password.md5,@"pwd",nil];
    [NetBase POST:LOGIN parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *defaults = [responseObject objectForJSONKey:@"data"];
            [self setUserAccount:[defaults valueForKey: USERACCOUNT ]];
            [self setUserId:[defaults valueForKey: USERID ]];
            [self setUserName:[defaults valueForKey: USERNAME ]];
            [self setUserPwd:[defaults valueForKey: USERPWD ]];
            [self setUserLogo:[defaults valueForKey: USERLOGO ]];
            [self setUserToken:[defaults valueForKey: USERTOKEN ]];
            [self setUserAddress:[defaults valueForKey: USERADDRESS ]];
            [self setUserlongitude:[defaults valueForKey: USERLONGITUDE ]];
            [self setUserlatitude:[defaults valueForKey: USERLATITUDE ]];
            [self setUsertype:[defaults valueForKey: USERTYPE ]];
            [self setUserSign:[defaults valueForKey: USERSIGN ]];
            [self setUsermony:[defaults valueForKey: USERMONY ]];
            [self setUserstatus:[defaults valueForKey: USERSTATUS ]];
            [self setUsercards:[defaults valueForKey: USERCARDS ]];
            [self setUserphone:[defaults valueForKey: USERPHONE ]];
            [self setUseridcard:[defaults valueForKey: USERIDCARD ]];
            [self setUserWechartnum:[defaults valueForKey: USERWECHARTNUM ]];
            [self setUserQQnumber:[defaults valueForKey: USERQQNUMBER ]];
            [self setUserSex:[defaults valueForKey: USERSEX ]];
            [self setUserAge:[defaults valueForKey: USERAGE ]];
            [self setUserProtect:[defaults valueForKey: USERPROTECT ]];
            [self setUserEmail:[defaults valueForKey: USEREMAIL ]];
            [self setUserDevices:[defaults valueForKey: USERDEVICES ]];
            [self setUserSystem:[defaults valueForKey: USERSYSTEM ]];
        
            [self setUserIP:[defaults valueForKey: USERIP ]];
            [self setUserRealName:[defaults valueForKey: USERREALNAME ]];
            [self saveUserInfoToDefault];
            [[Utility Share]upDataVersion];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"againLogin" object:nil];
            [[Utility Share] hiddenLoginAlert];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        [self clearUserInfoInDefault];
    }];
}

-(void)registerWithAccount:(NSString *)account pwd:(NSString *)password authorCode:(NSString *)code{
    if (![self validateTel:account]){
        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号"];return;}
    if (![password notEmptyOrNull]){
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];return;}
    if (![code notEmptyOrNull]){
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];return;}
     [NetBase POST:@"" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         //               0：参数异常
         //               1：手机账号不正确(包括空和号码错误)
         //               2：密码不能为空
         //               3、用户已存在
         //               4、发生异常
         //               5、注册成功
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     }];
}

#pragma mark 抖动与振动
//类似qq聊天窗口的抖动效果
-(void)shakeViewAnimation:(UIView *)aV{
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    CGAffineTransform translateTop =CGAffineTransformTranslate(CGAffineTransformIdentity,0.0,1);
    CGAffineTransform translateBottom =CGAffineTransformTranslate(CGAffineTransformIdentity,0.0,-1);
    aV.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        [UIView setAnimationRepeatCount:2.0];
        aV.transform = translateRight;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.07 animations:^{
            aV.transform = translateBottom;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.07 animations:^{
                aV.transform = translateTop;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    aV.transform =CGAffineTransformIdentity;//回到没有设置transform之前的坐标
                } completion:NULL];
            }];
        }];
    }];
}

//view 左右抖动
-(void)leftRightAnimations:(UIView *)view{
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    view.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        view.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                view.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}
// 振动
- (void)StartSystemShake {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//播放提示音
-(void)playSystemSound{
    if (!sound) {
        /*
         ReceivedMessage.caf--收到信息，仅在短信界面打开时播放。
         sms-received1.caf-------三全音
         sms-received2.caf-------管钟琴
         sms-received3.caf-------玻璃
         sms-received4.caf-------圆号
         sms-received5.caf-------铃声
         sms-received6.caf-------电子乐
         SentMessage.caf--------发送信息
         */
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received1",@"caf"];
        //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
                DLog(@"获取的声音的时候，出现错误");
            }
        }
    }
    AudioServicesPlaySystemSound(sound);
}
- (UIView*)tipsView:(NSString*)str;{
    UIView *v = [[UIView alloc] init];
   // UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_data_hint_ic.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 150, APPW-70,80)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = str?str:@"暂无数据，敬请期待！";
   // [imageview setCenter:CGPointMake(160, 120)];
   // [v addSubview:imageview];
    [v addSubview:label];
    return v;
}
#pragma mark 视图与图片
//圆角或椭圆
-(void)viewLayerRound:(UIView *)view borderWidth:(float)width borderColor:(UIColor *)color{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius =H(view)/ 2.0;
    view.layer.borderWidth=width;
    view.layer.borderColor =[color CGColor];
}
//修改图片大小
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//通过颜色来生成一个纯色图片
- (UIImage *)imageFromColor:(UIColor *)color size:(CGSize )aSize{
    CGRect rect = CGRectMake(0, 0,aSize.width, aSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark - IFly
/*
-(void)iflyView:(NSString *)str{
    strIFlyType=str;
    if (!_iflyRecognizerView) {
        //+++++++++++++++++++++语音+++++//初始化语音识别控件++++++++++++/
        NSString *initString = [NSString stringWithFormat:@"appid=%@",APPID];
        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:CGPointMake(160, kScreenHeight/2) initParam:initString];
        _iflyRecognizerView.delegate = self;
        //asr_ptt：默认为 1，当设置为 0 时，将返回无标点符号文本。
        [_iflyRecognizerView setParameter:@"asr_ptt" value:@"0"];
        [_iflyRecognizerView setParameter:@"domain" value:@"iat"];
        [_iflyRecognizerView setParameter:@"asr_audio_path" value:@"asrview.pcm"];
        //[_iflyRecognizerView setParameter:@"asr_audio_path" value:nil];   当你再不需要保存音频时，请在必要的地方加上这行。
    }[_iflyRecognizerView start];
}
#pragma mark - IFlyRecognizerViewDelegat
- (void)onResult:(IFlyRecognizerView *)iFlyRecognizerView theResult:(NSArray *)resultArray{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"ifly_ACZY_new_%@",strIFlyType] object:result];
    self.searchMessageData.text = [NSString stringWithFormat:@"%@%@",self.searchMessageData.text,result];
    [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil];
    [self.searchMessageData becomeFirstResponder];
}

- (void)onEnd:(IFlyRecognizerView *)iFlyRecognizerView theError:(IFlySpeechError *)error{
     if ([error errorCode]!=0) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"识别结束,错误码:%d",[error errorCode]]];
    }
    NSLog(@"errorCode:%d",[error errorCode]);
    [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil];
}
*/

#pragma mark -验证数据
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
- (BOOL) validateTel: (NSString *) candidate {
    NSString *telRegex = @"^1[1234567890]\\d{9}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    NSPredicate *PHSP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if ([telTest evaluateWithObject:candidate] == YES || [PHSP evaluateWithObject:candidate] == YES) {
        return YES;
    }else{
        return NO;
    }
}
//判断ios版本AVAILABLE
- (BOOL)isAvailableIOS:(CGFloat)availableVersion{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=availableVersion) {
        return YES;
    }else{
        return NO;
    }
}
-(NSString *)VersionSelect{
     return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark -数据格式化
///数据格式化
-(NSString *)FormatPhone:(NSString *)str{
    if (str.length<10) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:3];
        NSString *s2=[str substringWithRange:NSMakeRange(3, 4)];
        NSString *s3=[str substringFromIndex:7];
        DLog(@"%@,%@,%@",s1,s2,s3);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,s2,s3];
        return turntoCarIDString;
    }
}
///格式化身份证号
-(NSString *)FormatIDC:(NSString *)str{
    if (str.length==18) {
        NSString *s1=[str substringToIndex:3];
        NSString *s2=[str substringWithRange:NSMakeRange(3, 3)];
        NSString *s3=[str substringWithRange:NSMakeRange(6, 4)];
        NSString *s4=[str substringWithRange:NSMakeRange(10, 4)];
        NSString *s5=[str substringFromIndex:14];
        DLog(@"%@,%@,%@,%@,%@",s1,s2,s3,s4,s5);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",s1,s2,s3,s4,s5];
        return turntoCarIDString;
    }else if(str.length>=15){
        NSString *s1=[str substringToIndex:(str.length-8)];
        NSString *s4=[str substringWithRange:NSMakeRange((str.length-8), 4)];
        NSString *s5=[str substringFromIndex:(str.length-4)];
        DLog(@"%@,%@,%@",s1,s4,s5);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,s4,s5];
        return turntoCarIDString;
    }else{
        return str;
    }
}

/// 格式化组织机构代码证
-(NSString *)FormatOCC:(NSString *)str{
    if (str.length<9) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:4];
        NSString *s2=[str substringWithRange:NSMakeRange(4, 4)];
        NSString *s3=[str substringFromIndex:8];
        DLog(@"%@,%@,%@",s1,s2,s3);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,s2,s3];
        return turntoCarIDString;
    }
}
////格式化车牌号
-(NSString *)FormatPlate:(NSString *)str{
    if (str.length<7) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:(str.length-5)];
        NSString *s2=[str substringWithRange:NSMakeRange((str.length-5), 5)];
        DLog(@"%@,%@",s1,s2);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@",s1,s2];
        return turntoCarIDString;
    }
}
//格式化vin
-(NSString *)FormatVin:(NSString *)str{
    if (str.length<17) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:4];
        NSString *s2=[str substringWithRange:NSMakeRange(4, 4)];
        NSString *s3=[str substringWithRange:NSMakeRange(8, 1)];
        NSString *s4=[str substringWithRange:NSMakeRange(9, 4)];
        NSString *s5=[str substringWithRange:NSMakeRange(13, 4)];
        DLog(@"%@,%@,%@,%@,%@",s1,s2,s3,s4,s5);
        NSString *turntoVinString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",s1,s2,s3,s4,s5];
        return turntoVinString;
    }
}
///数字格式化
-(NSString*)FormatNumStr:(NSString*)nf{
    float f=[nf floatValue];
    DLog(@"%f",f);
    NSNumberFormatter * formatter=[[NSNumberFormatter alloc]init];
    formatter.numberStyle=kCFNumberFormatterCurrencyStyle;
    NSString *turnstr=[formatter stringFromNumber:[NSNumber numberWithFloat:f]];
    DLog(@"turnstr=%@",turnstr);
    turnstr=[turnstr substringFromIndex:1];
    DLog(@"turnstr=%@______",turnstr);
    return turnstr;
}

-(NSString *)timeToNow:(NSString *)theDate{
    NSString *timeString=@"";
    if (!theDate) {return @"";}
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[NSDate dateWithTimeIntervalSince1970:[theDate integerValue]];
    if (!d) {return theDate;}
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=(now-late)>0 ? (now-late) : 0;
    if (cha/60<1) {
        timeString=@"刚刚";
    }else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 分前", timeString];
    }else if (cha/3600>1 && cha/3600<12) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 小时前", timeString];
    }else if(cha/3600<24){
        timeString = @"今天";
    }else if(cha/3600<48){
        timeString = @"昨天";
    }else if(cha/3600/24<10){
        timeString = [NSString stringWithFormat:@"%.0f 天前",cha/3600/24];
    }else if(cha/3600/24<365){
        [dateFormatter setDateFormat:@"MM月dd日"];
        timeString=[dateFormatter stringFromDate:d];
    }else{
        timeString = [NSString stringWithFormat:@"%d年前",(int)cha/3600/24/365];
    }
    return timeString;
}
//时间戳
-(NSString *)timeToTimestamp:(NSString *)timestamp{
    if (!timestamp) {return @"";}
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *aTime = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    NSString *str=[dateFormatter stringFromDate:aTime];
    return str;
}


#pragma mark CLLocationManagerDelegate
-(void)loadUserLocation{
    locManager = [[CLLocationManager alloc]init];//初始化位置管理器
    locManager.delegate = self;//设置代理
    locManager.desiredAccuracy = kCLLocationAccuracyBest;//设置位置经度
    locManager.distanceFilter = 1;//设置每隔-米更新位置
    [locManager startUpdatingLocation];//开始定位服务
    self.userlatitude=@"31.165367";
    self.userlongitude=@"121.407257";
}

//协议中的方法，作用是每当位置发生更新时会调用的委托方法
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //结构体，存储位置坐标
    CLLocationCoordinate2D loc = [newLocation coordinate];
    DLog(@"longitude:%f,latitude:%f",loc.longitude,loc.latitude);
    self.userlatitude=[NSString stringWithFormat:@"%f",loc.latitude];
    self.userlongitude=[NSString stringWithFormat:@"%f",loc.longitude];
}

//当位置获取或更新失败会调用的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString *errorMsg = nil;
    if ([error code] == kCLErrorDenied) {errorMsg = @"访问被拒绝";}
    if ([error code] == kCLErrorLocationUnknown) {errorMsg = @"获取位置信息失败";}
    [SVProgressHUD showErrorWithStatus:errorMsg];
}

#pragma mark  启动过渡图片
-(void)showStartTransitionView{
    if (!startView) {
        startView=[BaseScrollView sharedWelcomWithFrame:[[UIScreen mainScreen] bounds] icons:@[@"1",@"2",@"3",@"4"]];
    }
    [startView show];
}
-(void)hiddenStartTransitionView{
    if (startView) {
        [startView hidden];
    }
}
#pragma mark 元件创建
+ (UITextField *)textFieldlWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor placeholder:(NSString *)aplaceholder text:(NSString*)atext{
    UITextField *baseTextField=[[UITextField alloc]initWithFrame:aframe];
    [baseTextField setKeyboardType:UIKeyboardTypeDefault];
    [baseTextField setBorderStyle:UITextBorderStyleNone];
    [baseTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [baseTextField setTextColor:acolor];
    baseTextField.placeholder=aplaceholder;
    baseTextField.font=afont;
    [baseTextField setSecureTextEntry:NO];
    [baseTextField setReturnKeyType:UIReturnKeyDone];
    [baseTextField setText:atext];
    baseTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return baseTextField;
}

/**
 *	根据aframe返回相应高度的label（默认透明背景色，白色高亮文字）
 *
 *	@param	aframe	预期框架 若height=0则计算高度  若width=0则计算宽度
 *	@param	afont	字体
 *	@param	acolor	颜色
 *	@param	atext	内容
 *  @param  aalignment   位置
 *  @param  afloat   行距
 *	@return	UILabel
 */
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext
{
    return [self labelWithFrame:aframe font:afont color:acolor text:atext textAlignment:NSTextAlignmentLeft];// autorelease];
}

+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment setLineSpacing:(float)afloat
{
    UILabel *lblTemp=[self labelWithFrame:aframe font:afont color:acolor text:atext textAlignment:aalignment];
    if (!aframe.size.height) {
        lblTemp.numberOfLines=0;
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lblTemp.text];
        NSMutableParagraphStyle *paragraphStyleT = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyleT setLineSpacing:afloat];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleT range:NSMakeRange(0, [atext length])];
        lblTemp.attributedText = attributedString;
        
        CGSize size = [lblTemp sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        lblTemp.frame=aframe;
        
    }
    return lblTemp;
}

+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment{
    UILabel *baseLabel=[[UILabel alloc] initWithFrame:aframe];
    if(afont)baseLabel.font=afont;
    if(acolor)baseLabel.textColor=acolor;
    // baseLabel.lineBreakMode=UILineBreakModeCharacterWrap;
    baseLabel.text=atext;
    baseLabel.textAlignment=aalignment;
    baseLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    if(aframe.size.height>20){
        baseLabel.numberOfLines=0;
    }
    if (!aframe.size.height) {
        baseLabel.numberOfLines=0;
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        baseLabel.frame = aframe;
    }else if (!aframe.size.width) {
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
        aframe.size.width = size.width;
        baseLabel.frame = aframe;
    }
    //    baseLabel.adjustsFontSizeToFitWidth=YES
    baseLabel.backgroundColor=[UIColor clearColor];
    baseLabel.highlightedTextColor=acolor;//[UIColor whiteColor];
    return baseLabel;// autorelease];
}

+(UIButton*)buttonWithFrame:(CGRect)_frame title:(NSString*)_title image:(NSString*)_image bgimage:(NSString*)_bgimage{
    UIButton *baseButton=[UIButton buttonWithType:UIButtonTypeCustom];//[[UIButton alloc] initWithFrame:_frame];
    baseButton.frame=_frame;
    baseButton.titleLabel.font=Font(16);
    if (_title) {
        [baseButton setTitle:_title forState:UIControlStateNormal];
        [baseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (_image) {
        [baseButton setImage:[UIImage imageNamed:_image] forState:UIControlStateNormal];
    }
    if (_bgimage) {
        UIImage *bg = [UIImage imageNamed:_bgimage];
        [baseButton setBackgroundImage:bg forState:UIControlStateNormal];
        if (_frame.size.height<0.00001) {
            _frame.size.height = bg.size.height*_frame.size.width/bg.size.width;
            [baseButton setFrame:_frame];
        }else if(_frame.size.width<0.00001) {
            _frame.size.width = bg.size.width*_frame.size.height/bg.size.height;
            _frame.origin.x = (APPW-_frame.size.width)/2.0;
            [baseButton setFrame:_frame];
        }
    }
    return baseButton;// autorelease];
}
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image{
    return [self imageviewWithFrame:_frame defaultimage:_image stretchW:0 stretchH:0];// autorelease];
}
//-1 if want stretch half of image.size
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image stretchW:(NSInteger)_w stretchH:(NSInteger)_h{
    UIImageView *imageview = nil;
    if(_image){
        if (_w&&_h) {
            UIImage *image = [UIImage imageNamed:_image];
            if (_w==-1) {
                _w = image.size.width/2;
            }
            if(_h==-1){
                _h = image.size.height/2;
            }
            imageview = [[UIImageView alloc] initWithImage:
                         [image stretchableImageWithLeftCapWidth:_w topCapHeight:_h]];
            imageview.contentMode=UIViewContentModeScaleToFill;
        }else{
            imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_image]];
            imageview.contentMode=UIViewContentModeScaleAspectFill;
        }
    }
    if (CGRectIsEmpty(_frame)) {
        [imageview setFrame:CGRectMake(_frame.origin.x,_frame.origin.y, imageview.image.size.width, imageview.image.size.height)];
    }else{
        [imageview setFrame:_frame];
    }
    imageview.clipsToBounds=YES;
    return  imageview;// autorelease];
}
#pragma mark 是否支持蓝牙协议4.0
//是否支持蓝牙协议4.0
- (BOOL)whetherToSupportBluetoothProtocol{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if([platform isEqualToString:@"iPhone1,1"]) { return NO;
    }else if ([platform isEqualToString:@"iPhone1,2"]) {platform = @"iPhone 3G";return NO;
    }else if ([platform isEqualToString:@"iPhone2,1"]) {platform = @"iPhone 3GS"; return NO;
    }else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {platform = @"iPhone 4";return NO;
    }else if ([platform isEqualToString:@"iPhone4,1"]) {platform = @"iPhone 4S";
    }else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {platform = @"iPhone 5";
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {platform = @"iPhone 5C";
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {platform = @"iPhone 5S";
    }else if ([platform isEqualToString:@"iPod4,1"]) {platform = @"iPod touch 4";return NO;
    }else if ([platform isEqualToString:@"iPod5,1"]) {platform = @"iPod touch 5";
    }else if ([platform isEqualToString:@"iPod3,1"]) {platform = @"iPod touch 3";return NO;
    }else if ([platform isEqualToString:@"iPod2,1"]) {platform = @"iPod touch 2";return NO;
    }else if ([platform isEqualToString:@"iPod1,1"]) {platform = @"iPod touch";return NO;
    }else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {platform = @"iPad 3";return NO;
    }else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {platform = @"iPad 2";return NO;
    }else if ([platform isEqualToString:@"iPad1,1"]) {platform = @"iPad 1";return NO;
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {platform = @"ipad mini";
    }else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {platform = @"ipad 3";return NO;
    }
    return YES;
}
#pragma mark 版本更新
- (void)upDataVersion{
    NSString *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *postdict = [[NSMutableDictionary alloc]init];
    [postdict setValue:@"ios" forKey:@"type"];
    [postdict setValue:version forKey:@"version"];
    [NetBase POST:MyFirstAPPUpdate parameters:postdict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MyappID"];
//    NSString *s = [NSString stringWithContentsOfURL:[NSURL URLWithString:APPStoreUpdate] encoding:NSUTF8StringEncoding error:nil];
//    NSString *pattern = [NSString stringWithFormat:@"softwareVersion\">(.*?)</span>"];//<span itemprop="softwareVersion">2.0.6</span>
    NSString *content = @"3.0";//[s firstMatchWithPattern:pattern];//build 版本号
    DLog(@"这是版本的信息：%lf===%lf==%lf===%lf",[content floatValue],[buildVersion floatValue],[[buildVersion substringFromIndex:2]floatValue],[[content substringFromIndex:2]floatValue]);
    if ([buildVersion floatValue] < [content floatValue]||([[buildVersion substringFromIndex:2]floatValue]<[[content substringFromIndex:2]floatValue])) {
        //提示用户到AppStore更新
        UIAlertView *notForceAlterView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本 %@",content] message:nil delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"立即更新", nil];
        notForceAlterView.tag=128;
        [notForceAlterView show];
    }

}
//- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
//    [viewController dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)openAppStore:(NSString *)appId{
//    //    NSString  *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
//    //    NSURL *url = [NSURL URLWithString:urlStr];
//    //    [[UIApplication sharedApplication]openURL:url];
//    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
//    storeProductVC.delegate = self;
//    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
//    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error){
//        if (result){
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storeProductVC animated:YES completion:nil];
//        }
//    }];
//}
//做ios版本之间的适配
//不同的ios版本,调用不同的方法,实现相同的功能
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size{
    CGSize s;
    if (Version7) {
        NSMutableDictionary  *mdic=[NSMutableDictionary dictionary];
        [mdic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        [mdic setObject:font forKey:NSFontAttributeName];
        s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:mdic context:nil].size;
    }else{
        DLog(@"sizeOfStr的版本低");
    }
    return s;
}
#pragma keyboard
- (void)keyboardDidShow:(NSNotification *)notification{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    if (!hideButton) {
        hideButton=[[UIButton alloc] initWithFrame:CGRectMake(keyboardBounds.size.width-50,keyboardBounds.origin.y-22,48, 23)];
        [hideButton setImage:[UIImage imageNamed:@"hidebutton.png"] forState:UIControlStateNormal];
        [hideButton addTarget:self action:@selector(resignAllTextField) forControlEvents:UIControlEventTouchUpInside];
    }
    [hideButton setFrame:CGRectMake(keyboardBounds.size.width-50,keyboardBounds.origin.y-22,48, 23)];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:hideButton];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [hideButton removeFromSuperview];
}
- (void)resignAllTextField{
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
    [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
        [window endEditing:YES];
    }];
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
