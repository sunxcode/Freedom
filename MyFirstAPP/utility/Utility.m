
#import "Utility.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "JSONKit.h"
#import "NSDictionary+expanded.h"
//#import "DMHessian.h"
#import <arpa/inet.h>
#import "AFNetworking.h"
#import "AppDelegate.h"
//#import "LoginView.h"
//#import "XNavigationController.h"

#import "LoginViewController.h"
#import "CustomTabBar.h"
//#import "LogViewController.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//#import "ZKSqlData.h"

#import <CoreLocation/CoreLocation.h>
//#import "HomeView.h"

//客服
//#import "AppKeFuLib.h"

//////支付宝//支付宝
//#import "Order.h"
//#import "DataSigner.h"

#import "XwelcomView.h"

//振动
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
//#import "ManagerAccViewController.h"
//#import "APService.h"


//#import <iflyMSC/IFlyRecognizerViewDelegate.h>
//#import <iflyMSC/IFlyRecognizerView.h>

#define picMidWidth 200
#define picSmallWidth 100
@interface Utility ()<CLLocationManagerDelegate>{//<IFlyRecognizerViewDelegate>SRWebSocketDelegate
    UITextField *accountField,*passField;
    NSString *phoneNum;
    UIAlertView *alertview;
 //   IFlyRecognizerView     *_iflyRecognizerView;
    NSString *strIFlyType;
    
    CLLocationManager *locManager;
    
     UIAlertView *alertTempScorket;
    //HomeView *aHomeView;
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
    NSString *packPath;
    
    UIAlertView *alertMessage;
    
    XwelcomView *startView;
}
@property (nonatomic,strong) NSURL *phoneNumberURL;
@property (nonatomic,strong) Reachability *reachability;
//@property (nonatomic, strong) LoginView *loginView;
//@property (nonatomic, strong) RegisterView *registerView;

@end

@implementation Utility

static Utility *_utilityinstance=nil;
static dispatch_once_t utility;

+(id)Share
{
    dispatch_once(&utility, ^ {
        _utilityinstance = [[Utility alloc] init];
        _utilityinstance.deviceNum=[self getMacAddress].md5;
        
        
    });
	return _utilityinstance;
}

- (BOOL)offline
{
    return NO;//![[NetEngine Share] isReachable];
}

#pragma mark -
#pragma mark getAddressBy
-(NSString *)getAddressBy:(NSString *)description{
	NSArray *strArray = [description componentsSeparatedByString:@" "];
	
	return [strArray objectAtIndex:1];
}

#pragma mark -
#pragma mark validateEmail
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
#pragma mark validateTel
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
//    if (candidate.length>=5) {
//        NSString *str = [NSString stringWithFormat:@"%.0f",candidate.doubleValue];
//        return [str isEqualToString:candidate];
//    }else{
//        return NO;
//    }
}
#pragma ImagePeSize
-(CGFloat)percentage:(NSString*)per width:(NSInteger)width
{
    if (per) { 
        NSArray *stringArray = [per componentsSeparatedByString:@"*"];
        
        if ([stringArray count]==2) {
            CGFloat w=[[stringArray objectAtIndex:0] floatValue];
            CGFloat h=[[stringArray objectAtIndex:1] floatValue];
            if (w>=width) {
                return h*width/w;
            }else{
                return  h;
            }
        }
    }
    return width;
}

//判断ios版本AVAILABLE
- (BOOL)isAvailableIOS:(CGFloat)availableVersion
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=availableVersion) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark TimeTravel
- (NSString*)timeToNow:(NSString*)theDate
{
    if (!theDate) {
        return nil;
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *d=[dateFormatter dateFromString:theDate];
    if (!d) {
        return theDate;
    }
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=(now-late)>0 ? (now-late) : 0;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 分前", timeString];
        
    }else if (cha/3600>1 && cha/3600<24) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 小时前", timeString];
    }
    else
    {
       /* if (needYear) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        else
        {
            [dateFormatter setDateFormat:@"MM-dd"];
        }
        timeString=[dateFormatter stringFromDate:d];*/
        timeString = [NSString stringWithFormat:@"%.0f 天前",cha/3600/24];
    }
    
    return timeString;
}
+ (void)alertError:(NSString*)content
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:content];
    });
}
+ (void)alertSuccess:(NSString*)content
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:content];
    });
}
- (void)alert:(NSString*)content
{
    [self alert:content delegate:nil];
}
- (void)alert:(NSString*)content delegate:(id)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (alertview) {
            [alertview dismissWithClickedButtonIndex:-1 animated:NO];
        }
        alertview =  [[UIAlertView alloc] initWithTitle:UI_language(@"", @"tips") message:content delegate:delegate cancelButtonTitle:nil otherButtonTitles:UI_language(@"确定", @"OK"), nil] ;[alertview show];//UI_language(@"取消", @"cancel")
    });
}
/**
 *	保存obj的array到本地，如果已经存在会替换本地。
 *
 *	@param	obj	待保存的obj
 *	@param	key	保存的key
 */
+ (void)saveToArrayDefaults:(id)obj forKey:(NSString*)key
{
    [self saveToArrayDefaults:obj replace:obj forKey:key];
}
+ (void)saveToArrayDefaults:(id)obj replace:(id)oldobj forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults valueForKey:key];
    
    NSMutableArray *marray = [NSMutableArray array];
    if (!oldobj) {
        oldobj = obj;
    }
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

+ (BOOL)removeForArrayObj:(id)obj forKey:(NSString*)key
{
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
/**
 *	保存obj到本地
 *
 *	@param	obj	数据
 *	@param	key	键
 */
+ (void)saveToDefaults:(id)obj forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:obj forKey:key];
    [defaults synchronize];
}

+ (id)defaultsForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
+ (void)removeForKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+(id)uid
{
    return [[Utility Share] userId];
}
-(void)ShowMessage:(NSString *)title msg:(NSString *)msg
{
    title=title?title:@"";
    alertMessage=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertMessage show];
}
-(void)hiddenMessageAlert{
    if (alertMessage) {
        [alertMessage dismissWithClickedButtonIndex:0 animated:YES];
        alertMessage=nil;
    }
}

-(void)getUserIdByDeviceNum{
    //getgetUserIdByDeviceNum1_1
  /*  [NetEngine createSoapAction:[NSString stringWithFormat:getgetUserIdByDeviceNum1_1,[[Utility Share] deviceNum]] onCompletion:^(id jsonData, BOOL isCache) {
        DLog(@"jsonData:%@",jsonData);
        if ([[jsonData objectForJSONKey:@"status"] integerValue]) {
            [[Utility Share] setUserIdFromDeviceNum:[jsonData objectForJSONKey:@"status"]];
        }
    } onError:^(NSError *error) {
        DLog(@"______________error:%@",error);
    } useCache:NO useMask:SVProgressHUDMaskTypeNone];
    */
}

#pragma mark -
#pragma mark makeCall
- (NSString*) cleanPhoneNumber:(NSString*)phoneNumber
{
    return [[[[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]
              stringByReplacingOccurrencesOfString:@"-" withString:@""]
             stringByReplacingOccurrencesOfString:@"(" withString:@""]
            stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    //return number1;
}

- (void) makeCall:(NSString *)phoneNumber
{
    phoneNum=[self cleanPhoneNumber:phoneNumber];
    if ([phoneNum intValue]!=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拨打号码?"
                                                        message:phoneNum
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"拨打",nil];
        
        [alert show];
    }else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"无效号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil] show];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([alertView.title isEqualToString:@"拨打号码?"]) {//phoneCall AlertView
        if (buttonIndex==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNum]]];
        }
        phoneNum=nil;
	}
    else if (alertView.tag == 1001) {//版本验证
        UIView *notTouchView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        notTouchView.backgroundColor = [UIColor blackColor];
        notTouchView.alpha = 0.2;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:notTouchView];
    }
}


///改变时间格式yy/MM/dd HH:mm
- (NSString*)time_ChangeTheFormat:(NSString*)theDate{
    DLog(@"________%@",theDate);
    if (!theDate) {
        return @"";
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
//    NSDate *d=[dateFormatter dateFromString:theDate];
//    DLog(@"_______________%@",d);
//    if (!d) {
//        return @"";
//    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *aTime = [NSDate dateWithTimeIntervalSince1970:[theDate integerValue]];
    return [dateFormatter stringFromDate:aTime];
}
-(NSInteger )time_Age:(NSString *)theDate{
    if (!theDate) {
        return 0;
    }
    
    NSDate *d=[NSDate dateWithTimeIntervalSince1970:[theDate integerValue]];
    if (!d) {
        return 0;
    }
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    

    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha=(now-late);//>0 ? (now-late) : 0
  
    return cha/3600/24/365;//年
 
}
-(NSInteger)ACtimeToNow:(NSString*)theDate
{
    /*
     -1过期
     */
    
    
    if (!theDate) {
        return -1;
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
    NSDate *d=[dateFormatter dateFromString:theDate];
    if (!d) {
        return -1;
    }
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    // NSString *timeString=@"";
    
    NSTimeInterval cha=(now-late);//>0 ? (now-late) : 0
    //    if (cha==0) {
    //        return -1;
    //    }else{
    return -cha/3600/24;
    //}
    
    
    //    if (cha/3600<1) {
    //        timeString = [NSString stringWithFormat:@"%f", cha/60];
    //        timeString = [timeString substringToIndex:timeString.length-7];
    //        timeString=[NSString stringWithFormat:@"%@ 分前", timeString];
    //
    //    }else if (cha/3600>1 && cha/3600<24) {
    //        timeString = [NSString stringWithFormat:@"%f", cha/3600];
    //        timeString = [timeString substringToIndex:timeString.length-7];
    //        timeString=[NSString stringWithFormat:@"%@ 小时前", timeString];
    //    }
    //    else
    //    {
    //        /* if (needYear) {
    //         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //         }
    //         else
    //         {
    //         [dateFormatter setDateFormat:@"MM-dd"];
    //         }
    //         timeString=[dateFormatter stringFromDate:d];*/
    //        timeString = [NSString stringWithFormat:@"%.0f 天前",cha/3600/24];
    //    }
    //    
    //    return timeString;
}
-(NSString *)time_strDate:(NSString *)theDate{
     NSString *timeString=@"";
    
    if (!theDate) {
        return @"";
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];//@"yyyy-MM-dd HH:mm:ss"
    NSDate *d=[NSDate dateWithTimeIntervalSince1970:[theDate integerValue]];
    if (!d) {
        return theDate;
    }
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha=(now-late);//>0 ? (now-late) : 0
    if (cha/60<1) {
        timeString=@"刚刚";
    }else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 分前", timeString];

    }else if (cha/3600>1 && cha/3600<24) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 小时前", timeString];
    }
    else
    {
        timeString = [NSString stringWithFormat:@"%.0f 天前",cha/3600/24];
    }
    //

    return timeString;
}

- (NSString*)timeToNow_zk:(NSString*)theDate{
    if (!theDate) {
        return nil;
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];//@"yyyy-MM-dd HH:mm:ss"
    NSDate *d=[NSDate dateWithTimeIntervalSince1970:[theDate integerValue]];//[dateFormatter dateFromString:theDate];
    if (!d) {
        return theDate;
    }
    
    NSString *timeString=@"";
    
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dateOfCurrentString = [dateFormatter stringFromDate:d];
    NSString *dateOfYesterdayString = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]]];
 
    if ( [todayString isEqualToString:dateOfCurrentString]) {
        timeString=@"今天";
    }else if ([dateOfCurrentString isEqualToString:dateOfYesterdayString]){
        timeString=@"昨天";
    }
    else
    {
        
        [dateFormatter setDateFormat:@"MM/dd"];
        timeString=[dateFormatter stringFromDate:d];
    }
    
    return timeString;
}


//通过时间戳计算生日
- (NSString*)birthdayWithTime:(NSString *)timestamp
{
    
    NSString *year;
    NSRange rang = {0,4};
    if ([timestamp integerValue] >100000) {
        NSString *time = [self timeToTimestamp:timestamp];
        
        year = [time substringWithRange:rang];
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYYMMdd"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        NSString *year1 = [locationString substringWithRange:rang];
        NSString *birthday = [NSString stringWithFormat:@"%ld",[year1 integerValue]-[year integerValue]];
        return birthday;
        
    }
    else
    {
        
        return @"暂无年龄";
    }
    
    
}

//时间戳
-(NSString *)timeToTimestamp:(NSString *)timestamp{
    if (!timestamp) {
        return @"";
    }    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
     NSDate *aTime = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    
    NSString *str=[dateFormatter stringFromDate:aTime];
    return str;
}

//data-固定格式时间
-(NSString *)timeToFormatConversion:(NSString *)aDate{
    if (!aDate) {
        return @"";
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *aTime = [NSDate dateWithTimeIntervalSince1970:[aDate integerValue]];

    NSString *str=[dateFormatter stringFromDate:aTime];
    return str;
}


#pragma login
-(void)isLoginAccount:(NSString *)account pwd:(NSString *)password aLogin:(LoginSuc)aLoginSuc
{
    self.loginSuc = aLoginSuc;
    [self loginWithAccount:account pwd:password];
    
}

- (void)showLoginAlert:(BOOL)abool
{
    //againLogin
    
    
    UINavigationController *curNav = [[[[Utility Share] CustomTabBar_zk] viewControllers] objectAtIndex:[[[Utility Share] CustomTabBar_zk]selectedIndex]];
    //[curNav popToRootViewControllerAnimated:NO];
    
    LoginViewController *login=[[LoginViewController alloc]init];
    login.userInfo=@"againLogin";
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:login];
    [curNav presentViewController:nav animated:abool completion:nil];
    
   // DLog(@"__________%@",[[CustomTabBar Share] viewControllers]);
    
    
}

- (void)hiddenLoginAlert
{
    //   // [_loginView hidden];
    //    UINavigationController *curNav = [[[[Utility Share] CustomTabBar_zk] viewControllers] objectAtIndex:[[[Utility Share] CustomTabBar_zk]selectedIndex]];
    //    [curNav dismissViewControllerAnimated:YES completion:nil];
    ////    [[[Utility Share] CustomTabBar_zk] selectedTabIndex:@"0"];
    
    [self hiddenLoginAlertBack:NO];
    //[[[Utility Share] CustomTabBar_zk] selectedTabIndex:@"0"];
}

- (void)hiddenLoginAlertBack:(BOOL)back{
    
    UINavigationController *curNav = [[[[Utility Share] CustomTabBar_zk] viewControllers] objectAtIndex:[[[Utility Share] CustomTabBar_zk]selectedIndex]];
    [curNav dismissViewControllerAnimated:YES completion:^{
        if (back) {
            self.loginSuc?self.loginSuc(1):nil;
            self.loginSuc = nil;
        }
    }];
}



-(void)isLogin:(LoginSuc)aLoginSuc
{
    self.loginSuc = aLoginSuc;
    if ([_userId notEmptyOrNull] && [_userToken notEmptyOrNull]) {
        //登录过-验证token是否过期
        //        NSString *str = [NSString stringWithFormat:JXGGuserchklogin, [[Utility Share] userId], [[Utility Share] userToken]];
        //
        //        [NetEngine createGetAction_LJ:str onCompletion:^(id resData, BOOL isCache) {
        //            if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
        //                //没过期
        //                self.loginSuc?self.loginSuc(1):nil;
        //                self.loginSuc = nil;
        //            }else{  //过期
        //                [self clearUserInfoInDefault];
        //                [self showLoginAlert:YES];
        //                [SVProgressHUD showImage:nil status:[resData valueForJSONKey:@"info"]];
        //
        //            }
        //        }];
        
        
        //        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        //        [dict setValue:[self userId] forKey:@"uid"];
        //        [dict setValue:[self userToken] forKey:@"token"];
        //
        //        [NetEngine createPostAction:JXGGuserchklogin withParams:dict onCompletion:^(id resData, BOOL isCache) {
        //            DLog(@"__resData____%@",resData);
        //            if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
        //                //没过期
        //                self.loginSuc?self.loginSuc(1):nil;
        //                self.loginSuc = nil;
        //            }else if ([[resData valueForJSONKey:@"status"] isEqualToString:@"501"]) {
        //                //过期
        //                [self clearUserInfoInDefault];
        //                [self showLoginAlert:YES];
        //                [SVProgressHUD showErrorWithStatus:[resData valueForJSONKey:@"info"]];
        //            } else{
        //                [SVProgressHUD showErrorWithStatus:[resData valueForJSONKey:@"info"]];
        //            }
        //        }];
        
        self.loginSuc?self.loginSuc(1):nil;
        self.loginSuc = nil;
        
        
    }
    else
        [self showLoginAlert:YES];
}

-(BOOL)isLogin
{
    if ([_userId notEmptyOrNull]) {
        return YES;
    }
    else
        return NO;
}




#pragma mark 数据更新
-(void)saveUserInfoToDefault
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.userName forKey:default_userName];
    [defaults setValue:self.userPwd forKey:default_pwd];
    [defaults setValue:self.userLogo forKey:default_userLogo];
    [defaults setValue:self.userId forKey:default_userId];
    [defaults setValue:self.userToken forKey:default_userToken];
    [defaults setValue:self.userAccount forKey:default_userAccount];
    [defaults setValue:self.userAddress forKey:default_userAddress];
    [defaults setValue:self.userstatus forKey:default_userstatus];
    [defaults setValue:self.useriscards forKey:default_useriscard];
    [defaults setValue:self.userallmony forKey:default_userallmony];
    [defaults setValue:self.usercanusermony forKey:default_usercanusermony];
    [defaults setValue:self.userphone forKey:default_userphone];
    [defaults setValue:self.useridcard forKey:default_useridcard];
    
    
    
    [defaults setBool:self.isDefaultNOStartSystemShake forKey:default_setDefaultStartVibrate];
    [defaults setBool:self.isDefaultNOplaySystemSound forKey:default_setDefaultplaySystemSound];
    
    
    
    [defaults synchronize];
}
-(void)readUserInfoFromDefault
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self setUserPwd:[defaults valueForKey:default_pwd]];
    [self setUserName:[defaults valueForKey:default_userName]];
    [self setUserLogo:[defaults valueForKey:default_userLogo]];
    [self setUserToken:[defaults valueForKey:default_userToken]];
    [self setUserId:[defaults valueForKey:default_userId]];
    [self setUserAccount:[defaults valueForKey:default_userAccount]];
    [self setUserAddress:[defaults valueForKey:default_userAddress]];
    [self setUserstatus:[defaults valueForKey:default_userstatus]];
    [self setUseriscards:[defaults valueForKey:default_useriscard]];
    [self setUserallmony:[defaults valueForKey:default_userallmony]];
    [self setUsercanusermony:[defaults valueForKey:default_usercanusermony]];
    [self setUserphone:[defaults valueForKey:default_userphone]];
    [self setUseridcard:[defaults valueForKey:default_useridcard]];
    [self setIsDefaultNOStartSystemShake:[defaults boolForKey:default_setDefaultStartVibrate]];
    [self setIsDefaultNOplaySystemSound:[defaults boolForKey:default_setDefaultplaySystemSound]];
    
    self.isAlertViewFlag=YES;
}
-(void)clearUserInfoInDefault
{
    //
    self.userId=nil;
    self.userName=nil;
    self.userPwd=nil;
    self.userLogo=nil;
    self.userToken=nil;
    self.userstatus=nil;
    self.useriscards = nil;
    self.userallmony = nil;
    self.usercanusermony = nil;
    self.userphone = nil;
    self.useridcard = nil;
  //  self.userAccount=nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //消除用户手势
    [defaults removeObjectForKey:default_pwd];
    [defaults removeObjectForKey:default_userLogo];
    [defaults removeObjectForKey:default_userName];
    [defaults removeObjectForKey:default_userId];
    [defaults removeObjectForKey:default_userToken];
    [defaults removeObjectForKey:default_userAddress];
    [defaults removeObjectForKey:default_setDefaultStartVibrate];
    [defaults removeObjectForKey:default_setDefaultplaySystemSound];
    [defaults removeObjectForKey:default_userstatus];
    [defaults removeObjectForKey:default_useriscard];
    [defaults removeObjectForKey:default_userallmony];
    [defaults removeObjectForKey:default_usercanusermony];
    [defaults removeObjectForKey:default_userphone];
    [defaults removeObjectForKey:default_useridcard];
    [defaults synchronize];
    
    //消除用户资料
    [self removeSqlData];
    
}
//清除本地数据库
-(void)removeSqlData{
   // delete from tabname(表名)
   // [ZKSqlData deleteSqlData];
}

#pragma mark  zxh 登陆

-(void)loginWithAccount:(NSString *)account pwd:(NSString *)password
{
    
    if (![account notEmptyOrNull])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写账户"];
        return;
    }
    if (![password notEmptyOrNull])
    {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:account,@"mobile",password.md5,@"pwd",nil];
    [[AFHTTPSessionManager manager]POST:LOGIN parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"resData:%@",@"");
            NSDictionary *userDict = [responseObject objectForJSONKey:@"data"];
            [self setUserId:[userDict valueForJSONStrKey:@"uid"]];
            [self setUserToken:[userDict valueForJSONStrKey:@"token"]];
            [self setUserAccount:account];
            [self setUserPwd:password];
            [self setUserMobile:[userDict valueForJSONStrKey:@"mobile"]];
            [self setUserName:[userDict valueForJSONStrKey:@"realname"]];
            [self setUserstatus:[userDict valueForJSONStrKey:@"is_open"]];
            [self setUserLogo:[userDict valueForJSONStrKey:@"photo"]];
            [self setUseriscards:[userDict valueForJSONKey:@"iscards"]];
            [self setUserallmony:[userDict valueForJSONKey:@"AcctBal"]];
            [self setUsercanusermony:[userDict valueForJSONKey:@"AvlBal"]];
            [self setUseridcard:[userDict valueForJSONKey:@"idcard"]];
            [self setUserphone:[userDict valueForJSONStrKey:@"mobile"]];
            
            if (![[userDict valueForJSONStrKey:@"mobile"] isEqualToString:@"12345678910"]) {
                [[NSUserDefaults standardUserDefaults] setValue:[userDict valueForJSONStrKey:@"mobile"] forKey:@"guangfubaomobile"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self setUsertype:[userDict valueForJSONStrKey:@"utype"]];
            //[[Utility Share] hiddenLoginAlert];
            DLog(@"______token;%@",self.userToken);
            //            [self setUserBluetoothBinding:[[userDict valueForJSONStrKey:@"binding"] isEqualToString:@"1"]];// 绑定状态（1.已绑定  0.未绑定）
            [self saveUserInfoToDefault];
            [[Utility Share]upDataVersion];
            //[self loadUserData];
            //            [APService setAlias:[[Utility Share] userId] callbackSelector:@selector(setJpushAlias) object:nil];
            //            [self performSelector:@selector(WebSocketConnectServer) withObject:nil afterDelay:1.5];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"againLogin" object:nil];
            //            [[Utility Share] hiddenLoginAlert];
            [[Utility Share] hiddenLoginAlertBack:YES];
            //            self.loginSuc?self.loginSuc(1):nil;
            //            self.loginSuc = nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        [self clearUserInfoInDefault];

    }];
}
-(void)setJpushAlias{
    
}


//获取用户数据
-(void)loadUserData{
//    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
//    [dict setValue:@"member" forKey:@"controller"];
//    [dict setValue:@"getInfo" forKey:@"action"];
//    [dict setValue:self.userId forKey:@"uid"];
//    [dict setValue:self.userToken forKey:@"token"];
//    
//    //ACregister
//    [NetEngine createPostAction:XGJindex withParams:dict onCompletion:^(id resData, BOOL isCache) {
//        
//        DLog(@"resData:%@",resData);
//        if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
//            NSDictionary *dic=[resData objectForJSONKey:@"data"];
//            [self setUserName:[dic valueForJSONStrKey:@"realname"]];
//            [self setUserLogo:[dic valueForJSONStrKey:@"icon"]];
//            [self setUserAddress:[dic valueForJSONStrKey:@"address"]];
//            [self setUserGroupId:[dic valueForJSONStrKey:@"groupid"]];
//            [self setUserMobile:[dic valueForJSONStrKey:@"mobile"]];
//            
//            
//            /*
//             小区监控ip : cMonitorIp
//             
//             小区监控端口 : cMonitorPort
//             
//             小区监控用户名 : cMonitorUser
//             
//             小区监控密码 : cMonitorPass
//             
//             家庭监控ip : fMonitorIp
//             
//             家庭监控端口 : fMonitorPort
//             
//             家庭监控用户名 : fMonitorUser
//             
//             家庭监控密码 : fMonitorPass
//             */
//            
//            [self setUserXQAccount:[dic valueForJSONStrKey:@"cMonitorUser"]];
//            [self setUserXQIP:[dic valueForJSONStrKey:@"cMonitorIp"]];
//            [self setUserXQPwd:[dic valueForJSONStrKey:@"cMonitorPass"]];
//            [self setUserXQDK:[dic valueForJSONStrKey:@"cMonitorPort"]];
//            
//            
//            [self setUserJTAccount:[dic valueForJSONStrKey:@"fMonitorUser"]];
//            [self setUserJTIP:[dic valueForJSONStrKey:@"fMonitorIp"]];
//            [self setUserJTPwd:[dic valueForJSONStrKey:@"fMonitorPass"]];
//            [self setUserJTDK:[dic valueForJSONStrKey:@"fMonitorPort"]];
//            
//
//            
//            [self saveUserInfoToDefault];
//            
//            
//            
//        }else{
//            [SVProgressHUD showErrorWithStatus:[resData valueForJSONKey:@"info"]];
//        }
//        
//    }];
}
/*
 短信 - 读取用户的所有相关分类
 */
/*
-(void)Message_userType{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:self.userId,@"uid",self.userToken,@"token", nil];
    [NetEngine createPostAction:ZKmymsgtplcate withParams:dic onCompletion:^(id resData, BOOL isCache) {
        DLog(@"__resData____%@",resData);
        if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
            if (!_ZKMessageTypeArray_mode) {
                _ZKMessageTypeArray_mode=[[NSMutableArray alloc] init];
            }else{
                [_ZKMessageTypeArray_mode removeAllObjects];
            }
            [_ZKMessageTypeArray_mode addObjectsFromArray:[[resData objectForJSONKey:@"data"] objectForJSONKey:@"list"]];
        }else if ([[resData valueForJSONKey:@"status"] isEqualToString:@"501"]) {
            [SVProgressHUD showErrorWithStatus:[resData valueForJSONKey:@"info"] ];
        }else{
            [SVProgressHUD showErrorWithStatus:[resData valueForJSONKey:@"info"]];
        }
    }];
}
-(void)weixin_userType{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:self.userId,@"uid",self.userToken,@"token", nil];
    [NetEngine createPostAction:ZKWeixinCate withParams:dic onCompletion:^(id resData, BOOL isCache) {
        DLog(@"__resData____%@",resData);
        if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
            if (!_ZKWeixinTypeArray) {
                _ZKWeixinTypeArray=[[NSMutableArray alloc] init];
            }else{
                [_ZKWeixinTypeArray removeAllObjects];
            }
            [_ZKWeixinTypeArray addObjectsFromArray:[[resData objectForJSONKey:@"data"] objectForJSONKey:@"list"]];
        }else if ([[resData valueForJSONKey:@"status"] isEqualToString:@"501"]) {
            [SVProgressHUD showErrorWithStatus:[resData valueForJSONKey:@"info"] ];
        }else{
            [SVProgressHUD showErrorWithStatus:[resData valueForJSONKey:@"info"]];
        }
    }];
}
//文章
-(void)wenZhang_userType{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:self.userId,@"uid",self.userToken,@"token", nil];
   
    [[NetEngine soapShare] createAction:NETypeHttpPost withUrl:ZKwaparticleCate withParams:dic withFile:nil withCache:NO withMask:SVProgressHUDMaskTypeClear onCompletion:^(id resData, BOOL isCache) {
        DLog(@"__resData____%@",resData);
        if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
            if (!_ZKWaparticleTypeArray) {
                _ZKWaparticleTypeArray=[[NSMutableArray alloc] init];
            }else{
                [_ZKWaparticleTypeArray removeAllObjects];
            }
            [_ZKWaparticleTypeArray addObjectsFromArray:[[resData objectForJSONKey:@"data"] objectForJSONKey:@"list"]];
        }else if ([[resData valueForJSONKey:@"status"] isEqualToString:@"501"]) {
            [SVProgressHUD showErrorWithStatus:[resData valueForJSONKey:@"info"] ];
        }else{
            [SVProgressHUD showErrorWithStatus:[resData valueForJSONKey:@"info"]];
        }
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:alertErrorTxt];
    }];
    
}

   // 获取本地数据-客户/客户群组/同事通讯录
 
-(void)loadUserData{
    [self loadUserDataNetEngine];
    [self loadZKcustomerCate];
    
    [self colleagueCate];
    
    
    //获取同事通讯录
    [self colleague];
}

static int loadIndex1=0;
-(void)loadUserDataNetEngine{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:[[Utility Share]userId] forKey:@"uid"];
    [dic setValue:[[Utility Share]userToken] forKey:@"token"];
    //客户
    [NetEngine createHttpAction:ZKcustomer withCache:NO withParams:dic withMask:SVProgressHUDMaskTypeNil onCompletion:^(id resData, BOOL isCache) {
        DLog(@"__客户resData____%@",resData);
        if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (NSDictionary *d in [[resData objectForJSONKey:@"data"] objectForJSONKey:@"list"]) {
                    [ZKSqlData insertCustomer:d];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新已有
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
                });
            });
        }else{
            [self ShowMessage:nil msg:@"客户数据同步失败\n建议关闭应用重新登录"];
            //[self loadUserDataNetEngine];
        }
    } onError:^(NSError *error) {
        if (loadIndex1<3) {
            loadIndex1++;
            [self loadUserDataNetEngine];
            
        }
    }];
}
static int loadIndex2=0;
-(void)loadZKcustomerCate{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:[[Utility Share]userId] forKey:@"uid"];
    [dic setValue:[[Utility Share]userToken] forKey:@"token"];
    
    //客户群组
    [NetEngine createHttpAction:ZKcustomerCate withCache:NO withParams:dic withMask:SVProgressHUDMaskTypeNil onCompletion:^(id resData, BOOL isCache) {
        DLog(@"__客户群组resData_%@___%@",dic,resData);
        if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (NSDictionary *d in [[resData objectForJSONKey:@"data"] objectForJSONKey:@"list"]) {
                    [ZKSqlData insertCustomer_sort:d];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
        }else{
            [self ShowMessage:nil msg:@"客户群组数据同步失败\n建议关闭应用重新登录"];
           // [self loadZKcustomerCate];
        }
    } onError:^(NSError *error) {
        if (loadIndex2<3) {
            loadIndex2++;
            [self loadZKcustomerCate];
            
        }
    }];
}

static int loadIndex3=0;
//同事通讯录 - 部门分类  职位分类
-(void)colleagueCate{
    //
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:[[Utility Share]userId] forKey:@"uid"];
    [dic setValue:[[Utility Share]userToken] forKey:@"token"];
    [NetEngine createHttpAction:ZKcolleagueCate withCache:NO withParams:dic withMask:SVProgressHUDMaskTypeNil onCompletion:^(id resData, BOOL isCache) {
        DLog(@"__同事通讯录 - 部门分类resData____%@",resData);
        if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
            //数据库
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (NSDictionary *dd in [[resData objectForJSONKey:@"data"] objectForJSONKey:@"department"]) {
                    [ZKSqlData insertColleague_department:dd];
                }
                for (NSDictionary *dd in [[resData objectForJSONKey:@"data"] objectForJSONKey:@"position"]) {
                    [ZKSqlData insertColleague_position:dd];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
           
            
        }else{
            [self ShowMessage:nil msg:@"同事通讯录-部门分类、职位分类 数据同步失败\n建议关闭应用重新登录"];
        }
    } onError:^(NSError *error) {
        if (loadIndex3<3) {
            loadIndex3++;
            [self colleagueCate];
            
        }
    }];
}
static int loadIndex5=0;
//同事通讯录
-(void)colleague{
    //
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:[[Utility Share]userId] forKey:@"uid"];
    [dic setValue:[[Utility Share]userToken] forKey:@"token"];
    [NetEngine createHttpAction:ZKcolleague withCache:NO withParams:dic withMask:SVProgressHUDMaskTypeNil onCompletion:^(id resData, BOOL isCache) {
        DLog(@"__同事通讯录resData____%@",resData);
        if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
            //数据库
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (NSDictionary *dd in [[resData objectForJSONKey:@"data"] objectForJSONKey:@"list"]) {
                    [ZKSqlData insertColleague:dd];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
        }else{
            [self ShowMessage:nil msg:@"同事通讯录 数据同步失败\n建议关闭应用重新登录"];
        }
    } onError:^(NSError *error) {
        if (loadIndex5<3) {
            loadIndex5++;
            [self colleague];
            
        }
    }];
}

*/


-(void)registerWithAccount:(NSString *)account pwd:(NSString *)password authorCode:(NSString *)code
{
    if (![self validateTel:account])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号"];
        return;
    }
    if (![password notEmptyOrNull])
    {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    if (![code notEmptyOrNull])
    {
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        return;
    }
    
 /*
    [NetEngine createSoapAction:[NSString stringWithFormat:getregister1_1,account,password,[[Utility Share] deviceNum]] onCompletion:^(id jsonData, BOOL isCache) {
        NSString *statusStr = [jsonData valueForJSONKey:@"status"];
         if ([statusStr notEmptyOrNull]) {
             
//
//               0：参数异常
//               1：手机账号不正确(包括空和号码错误)
//               2：密码不能为空
//               3、用户已存在
//               4、发生异常
//               5、注册成功
//
             switch ([statusStr integerValue]) {
                 case 0:
                 {
                     [SVProgressHUD showErrorWithStatus:@"参数异常"];
                     break;
                 }
                 case 1:
                 {
                     [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号"];
                     break;
                 }
                 case 2:
                 {
                     [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
                     break;
                 }
                 case 3:
                 {
                     [SVProgressHUD showErrorWithStatus:@"用户已存在"];
                     break;
                 }
                 case 4:
                 {
                     [SVProgressHUD showErrorWithStatus:@"发生异常"];
                     break;
                 }
                 case 5:
                 {
                     [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                     [[Utility Share] loginWithAccount:account pwd:password];
                     break;
                 }
                 default:
                     break;
             }
         }else{
             [SVProgressHUD showErrorWithStatus:@"网络超时,请重新尝试."];
         }
       
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络超时,请重新尝试."];
    } useCache:NO useMask:SVProgressHUDMaskTypeBlack];
    */
//    [NetEngine createSoapAction:[NSString stringWithFormat:registerCodeURL,account,password,name,aCode,aIsMan?@"true":@"false"] onCompletion:^(id jsonData,BOOL isCache) {
//        NSString *statusStr = [jsonData valueForJSONKey:@"status"];
//        if ([statusStr notEmptyOrNull]) {
//            switch ([statusStr integerValue]) {
//                case 0:
//                    [SVProgressHUD showErrorWithStatus:@"请填写正确的信息"];
//                    break;
//                case 4:
//                    [SVProgressHUD showErrorWithStatus:@"验证码不正确,请填写正确的验证码或者点击重新获取。" ];
//                    break;
//                case 5:
//                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@已被注册",account] ];
//                    break;
//                case 6:
//                    [SVProgressHUD showErrorWithStatus:@"验证码不正确,请填写正确的验证码或者点击重新获取。" ];
//                    break;
//                case 7:
//                    [SVProgressHUD showErrorWithStatus:@"服务器异常"];
//                    break;
//                case 8://成功
//                  //  [self hiddenRegisterAlert];
//                    [self loginWithAccount:account pwd:password];
//                    break;
//                default:
//                    [SVProgressHUD showErrorWithStatus:@"请填写正确的信息"];
//                    break;
//            }
//        }
//        else
//        {
//            [SVProgressHUD showErrorWithStatus:@"网络超时,请重新尝试."];
//        }
//    } onError:^(NSError *error) {
//        
//    } useCache:NO useMask:SVProgressHUDMaskTypeBlack];
}

- (void)reloadIsPushEnable
{
   /* [NetEngine createSoapAction:[NSString stringWithFormat:isPushEnableURL,[[Utility Share] deviceNum]] onCompletion:^(id jsonData, BOOL isCache) {
        [[Utility Share] setIsPushEnable:[[jsonData valueForJSONKey:@"status"] isEqualToString:@"1"]];
    } onError:^(NSError *error) {
        
    } useCache:NO useMask:SVProgressHUDMaskTypeNone];
    */
}



-(void)renzhenghh{
    
    
    #pragma mark  认证简化
    
    UIAlertView *alertviewx = [[UIAlertView alloc]initWithTitle:@"提示" message: @"你还未认证,去认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alertviewx.tag=1199;
    [alertviewx show];
    
    
//    
//    [self.currentViewController pushController:[ManagerAccViewController class] withInfo:NSStringFromClass([self.currentViewController class]) withTitle:@"实名认证" withOther:nil];
    
    
    return;
    
}

#pragma mark alertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1199) {
        if (buttonIndex==1) {
        }
      return;
    }
    if (alertView==alertTempScorket) {
//      [ self WebSocketConnectServer];
    }else if (alertView.tag==101){
        if (buttonIndex==0) {
//            [self WebSocketLogin];
        }else{
            [[Utility Share] showLoginAlert:YES];
        }
    }else if (alertView.tag == 199) {
        // 强制更新
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:packPath]];
        exit(0);
    }else if (alertView.tag == 198){
        // 不强制更新
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:packPath]];
        }else{
            DLog(@"不更新");
        }
    }
}

+(NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        free(msgBuffer);
        //NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}


#pragma mark view
//类似qq聊天窗口的抖动效果
-(void)viewAnimations:(UIView *)aV{
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    CGAffineTransform translateTop =CGAffineTransformTranslate(CGAffineTransformIdentity,0.0,1);
    CGAffineTransform translateBottom =CGAffineTransformTranslate(CGAffineTransformIdentity,0.0,-1);
    
    aV.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{//UIViewAnimationOptionRepeat
        //[UIView setAnimationRepeatCount:2.0];
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
//        if(finished){
//            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                aV.transform =CGAffineTransformIdentity;//回到没有设置transform之前的坐标
//            } completion:NULL];
//        }else{
//            aV.transform = translateTop;
//            
//        }
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
- (UIView*)tipsView:(NSString*)str;
{
    UIView *v = [[UIView alloc] init];
   // UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_data_hint_ic.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 150, kScreenWidth-70,80)];
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
//圆角或椭圆
-(void)viewLayerRound:(UIView *)view borderWidth:(float)width borderColor:(UIColor *)color{
    // 必須加上這一行，這樣圓角才會加在圖片的「外側」
    view.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    view.layer.cornerRadius =H(view)/ 2.0;
    //边框
    view.layer.borderWidth=width;
    view.layer.borderColor =[color CGColor];
}

//#pragma mark - IFly
//-(void)iflyView:(NSString *)str{
//    strIFlyType=str;
//    if (!_iflyRecognizerView) {
//        /*
//         +++++++++++++++++++++语音+++++++++++++++++
//         */
//        //初始化语音识别控件
//        NSString *initString = [NSString stringWithFormat:@"appid=%@",APPID];
//        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:CGPointMake(160, kScreenHeight/2) initParam:initString];
//        _iflyRecognizerView.delegate = self;
//        //asr_ptt：默认为 1，当设置为 0 时，将返回无标点符号文本。
//        [_iflyRecognizerView setParameter:@"asr_ptt" value:@"0"];
//        [_iflyRecognizerView setParameter:@"domain" value:@"iat"];
//        [_iflyRecognizerView setParameter:@"asr_audio_path" value:@"asrview.pcm"];
//        //    [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil];   当你再不需要保存音频时，请在必要的地方加上这行。
//    }
//    [_iflyRecognizerView start];
//}
//#pragma mark - IFlyRecognizerViewDelegat
//- (void)onResult:(IFlyRecognizerView *)iFlyRecognizerView theResult:(NSArray *)resultArray
//{
//    NSMutableString *result = [[NSMutableString alloc] init];
//    NSDictionary *dic = [resultArray objectAtIndex:0];
//    for (NSString *key in dic) {
//        [result appendFormat:@"%@",key];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"ifly_ACZY_new_%@",strIFlyType] object:result];
//  //  self.searchMessageData.text = [NSString stringWithFormat:@"%@%@",self.searchMessageData.text,result];
//    [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil];
//   // [self.searchMessageData becomeFirstResponder];
//}
//
//- (void)onEnd:(IFlyRecognizerView *)iFlyRecognizerView theError:(IFlySpeechError *)error
//{
//    //    [self.view addSubview:_popView];
//    //    [_popView setText:[NSString stringWithFormat:@"识别结束,错误码:%d",[error errorCode]]];
//    if ([error errorCode]!=0) {
//       // [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"识别结束,错误码:%d",[error errorCode]]];
//    }
//    NSLog(@"errorCode:%d",[error errorCode]);
//    [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil];
//}



-(NSString *)VersionSelect{
     NSString *v = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return v;
}
-(void)VersionNew{
    [self upDataVersion];
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
//////////////数据格式化
//格式化电话号码
-(NSString *)ACFormatPhone:(NSString *)str{
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
///格式化手机号
-(NSString *)ACFormatMobile:(NSString *)str{
    if (str.length<10) {//含固定电话
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
-(NSString *)ACFormatIDC:(NSString *)str{
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

//// 格式化组织机构代码证
-(NSString *)ACFormatOCC:(NSString *)str{
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
-(NSString *)ACFormatPlate:(NSString *)str{
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
-(NSString *)ACFormatVin:(NSString *)str{
    if (str.length<17) {
        return str;
    }
    else
    {
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
//------数字格式化----------------
-(NSString*)ACFormatNumStr:(NSString*)nf
{
    float f=[nf floatValue];
    DLog(@"%f",f);//
//    NSNumberFormatter * formatter=[[NSNumberFormatter alloc]init];
//    formatter.numberStyle=kCFNumberFormatterDecimalStyle;
//    NSString *turnstr=[formatter stringFromNumber:[NSNumber numberWithFloat:f]];
//    NSRange range=[turnstr rangeOfString:@"."];
//    if (range.length==0) {
//        turnstr =[turnstr stringByAppendingString:@".00"];
//    }
//    DLog(@"turnstr=%@_________range.length:%d",turnstr,range.location);
//    if ([[turnstr substringWithRange:NSMakeRange(turnstr.length-2, 1)] isEqualToString:@"."]) {
//        turnstr=[turnstr stringByAppendingString:@"0"];
//    }
//    NSRange range2=[turnstr rangeOfString:@"."];
//    turnstr=[turnstr substringToIndex:range2.location+3];
    
    NSNumberFormatter * formatter=[[NSNumberFormatter alloc]init];
    formatter.numberStyle=kCFNumberFormatterCurrencyStyle;
    NSString *turnstr=[formatter stringFromNumber:[NSNumber numberWithFloat:f]];
  
    
    DLog(@"turnstr=%@_______",turnstr);
    
    turnstr=[turnstr substringFromIndex:1];
    
    DLog(@"turnstr=%@___asdfasdfas____",turnstr);
    return turnstr;
}

//格式化身份证号
-(NSString *)ACFormatIDC_DH:(NSString *)str{
    if (str.length==18) {
        NSString *s1=[str substringToIndex:3];
        NSString *s2=[str substringWithRange:NSMakeRange(3, 3)];
        NSString *s3=[str substringWithRange:NSMakeRange(6, 4)];
        NSString *s4=[str substringWithRange:NSMakeRange(10, 4)];
        NSString *s5=[str substringFromIndex:14];
        DLog(@"%@,%@,%@,%@,%@",s1,s2,s3,s4,s5);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",s1,s2,@"****",@"****",@"****"];
        return turntoCarIDString;
    }else if(str.length>=15){
        NSString *s1=[str substringToIndex:(str.length-8)];
        NSString *s4=[str substringWithRange:NSMakeRange((str.length-8), 4)];
        NSString *s5=[str substringFromIndex:(str.length-4)];
        DLog(@"%@,%@,%@",s1,s4,s5);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,@"****",@"****"];
        return turntoCarIDString;
    }else{
        return str;
    }
}
//格式化vin2
-(NSString *)ACFormatVin_DH:(NSString *)str{
    if (str.length<17) {
        return str;
    }
    else
    {
        NSString *s1=[str substringToIndex:4];
        NSString *s2=[str substringWithRange:NSMakeRange(4, 4)];
        NSString *s3=[str substringWithRange:NSMakeRange(8, 1)];
        NSString *s4=[str substringWithRange:NSMakeRange(9, 4)];
        NSString *s5=[str substringWithRange:NSMakeRange(13, 4)];
        DLog(@"%@,%@,%@,%@,%@",s1,s2,s3,s4,s5);
        NSString *turntoVinString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",s1,@"****",s3,@"****",s5];
        return turntoVinString;
    }
}

#pragma mark CLLocationManagerDelegate
-(void)loadUserLocation{
    
    //初始化位置管理器
    locManager = [[CLLocationManager alloc]init];
    //设置代理
    locManager.delegate = self;
    //设置位置经度
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置每隔-米更新位置
    locManager.distanceFilter = 1;
    //开始定位服务
    [locManager startUpdatingLocation];
    
    
    self.userlatitude=@"31.165367";
    self.userlongitude=@"121.407257";
}

//协议中的方法，作用是每当位置发生更新时会调用的委托方法
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //结构体，存储位置坐标
    CLLocationCoordinate2D loc = [newLocation coordinate];
    float longitude = loc.longitude;
    float latitude = loc.latitude;
   // DLog(@"longitude:%f,latitude:%f",longitude,latitude);
    self.userlatitude=[NSString stringWithFormat:@"%f",latitude];
    self.userlongitude=[NSString stringWithFormat:@"%f",longitude];
    
}

//当位置获取或更新失败会调用的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorMsg = nil;
    if ([error code] == kCLErrorDenied) {
        errorMsg = @"访问被拒绝";
    }
    if ([error code] == kCLErrorLocationUnknown) {
        errorMsg = @"获取位置信息失败";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Location"
                                                       message:errorMsg delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
    [alertView show];
}

/*
#pragma mark Alipay
-(void)showAlipay:(id)data{
    
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = [data valueForJSONStrKey:@"order_id"]; //订单ID（由商家自行制定）
    order.productName =@"贝邸中心商品";//[data valueForJSONStrKey:@"member_name"]; //商品标题
    order.productDescription =@"贝邸中心购物支付";//[data valueForJSONStrKey:@"tostr"]; //商品描述
    order.amount = [data valueForJSONStrKey:@"fee_amount"]; //商品价格
    order.notifyURL =[[data valueForJSONStrKey:@"notify_url"] notEmptyOrNull]?[data valueForJSONStrKey:@"notify_url"]:alipayBackUrl;  //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"AlipayBDwwlk";
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@____________\n\n_____%@\n\n",resultDic,[resultDic valueForJSONStrKey:@"memo"]);
            if ([[resultDic valueForJSONStrKey:@"resultStatus"] isEqualToString:@"9000"] && [[resultDic valueForJSONStrKey:@"success"] isEqualToString:@"true"])
            {
                //成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySDK_success" object:@"yes"];
                
            }
            else
            {
                //交易失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySDK_success" object:@"NO"];
            }
            
        }];
        
    }
    
    
}
 */

/*

#pragma mark websocket
-(void)WebSocketConnectServer{
    //启动socket
    self.srWebSocket=nil;
    self.srWebSocket = [[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:LikeWEBsocket]]];
    self.srWebSocket.delegate = self;
    
    [self.srWebSocket open];
}
-(void)WebSocketLogin{
    NSMutableDictionary *parmna = [NSMutableDictionary dictionary ];
    [parmna setValue:self.userId forKey:@"uid"];
    [parmna setValue:@"login" forKey:@"type"];
    [parmna setValue:self.userroom_id forKey:@"room_id"];
    [parmna setValue:self.userToken forKey:@"token"];
    
    [self.srWebSocket send:[parmna JSONString]];
}

//-(void)WebSocketLoginGroup:(NSString *)strIds{
//    NSMutableDictionary *parmna = [NSMutableDictionary dictionary ];
//    [parmna setValue:strIds forKey:@"uid"];
//    [parmna setValue:@"login" forKey:@"type"];
//    [parmna setValue:self.userToken forKey:@"token"];
//    
//    [self.srWebSocket send:[parmna JSONString]];
//}


-(void)WebSocketsend:(NSString *)strJson{
    if (self.srWebSocket.readyState==1) {
        
        [self.srWebSocket send:strJson];
        
    }else{
        
        [self alertConnectServer];
    }
}
-(void)websocketClose{
    if (self.srWebSocket.readyState==1) {
        
        [self.srWebSocket close];
    }
}

#pragma mark - SRWebSocketDelegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSDictionary *dic =  [message objectFromJSONString];
    DLog(@"_____%d",[[dic objectForJSONKey:@"msg"] isKindOfClass:[NSString class]]);
   
    if ([[dic valueForJSONStrKey:@"type"] isEqualToString:@"message"] && ![[dic valueForJSONStrKey:@"status"] boolValue] ){
        //token过期
        [SVProgressHUD showImage:nil status:@"登录过期，请重新登录"];
        [self clearUserInfoInDefault];
        
        [self performSelector:@selector(showwebScoketLogin) withObject:nil afterDelay:0.5];

        
    }else if ([[dic valueForJSONStrKey:@"type"] isEqualToString:@"say"]) {
            if (!self.isDefaultNOStartSystemShake && !self.isNOStartVibrate) {
                [self StartSystemShake];
                
            }
            if (!self.isDefaultNOplaySystemSound && !self.isNOplaySystemSound) {
                [self playSystemSound];
            }

            
            if ([[Utility Share] CustomTabBar_zk].currentSelectedIndex==3) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"webSocketMessage" object:nil userInfo:dic];
            }else{
                UITabBar *bar=[[Utility Share] CustomTabBar_zk].tabBar;
                UIView *vt=[bar viewWithTag:203];
                vt.hidden=NO;
            }
    }else if ([[dic valueForJSONStrKey:@"type"] isEqualToString:@"friendsnotice"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"friendsnotice" object:dic];
        UITabBar *bar=[[Utility Share] CustomTabBar_zk].tabBar;
        if ([[[Utility Share] CustomTabBar_zk] currentSelectedIndex] != 3) {
            
            UIView *vt=[bar viewWithTag:203];
            vt.hidden=NO;
        }else{
            UIView *vt=[bar viewWithTag:203];
            vt.hidden=YES;
        }
    }else if ([self.userId notEmptyOrNull] && ![[dic objectForJSONKey:@"status"] boolValue]&& [[dic objectForJSONKey:@"msg"] isKindOfClass:[NSString class]] && [[dic objectForJSONKey:@"msg"] isEqualToString:@"login failed"] ) {
//        UIAlertView *alret =[[UIAlertView alloc] initWithTitle:@"哎呀！服务器连接失败！" message:@"请检查网络是否正常，确定重新连接服务器" delegate:self cancelButtonTitle:@"重新连接" otherButtonTitles:@"重新登录", nil];
//        alret.tag=101;
//        [alret show];
    }
    NSLog(@"didReceiveMessage___%@",message);
}
-(void)showwebScoketLogin{
    [[Utility Share] showLoginAlert:YES];
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"webSocket.readyState：%d",webSocket.readyState);
    
    if (webSocket.readyState==1) {
        DLog(@"____________连接成功");
        if ([self.userId notEmptyOrNull]) {
            [self WebSocketLogin];
        }else{
            
            [SVProgressHUD showImage:nil status:@"登录失败，缺少必要参数，请重新登录"];
        }
    }else{
        if ([self.userId notEmptyOrNull] && webSocket.readyState!=SR_CLOSED) {
            
            [self alertConnectServer];
        }
    }
    
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    self.srWebSocket = nil;
    NSLog(@"失败___%@___",error);
    if ([self.userId notEmptyOrNull]) {
        [self alertConnectServer];
    }
    
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClea
{
    self.srWebSocket = nil;
    NSLog(@"didCloseWithCode");
    if ([self.userId notEmptyOrNull]) {
        [self alertConnectServer];
    }
}
-(void)alertConnectServer{
    if (alertTempScorket) {
        [alertTempScorket dismissWithClickedButtonIndex:0 animated:YES];
        alertTempScorket=nil;
    }
    
    alertTempScorket=[[UIAlertView alloc] initWithTitle:@"哎呀！服务器连接失败！" message:@"请检查网络是否正常，确定重新连接服务器" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertTempScorket show];
}
*/
#pragma mark image
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

//通过颜色来生成一个纯色图片
- (UIImage *)imageFromColor:(UIColor *)color rect:(CGSize )aSize{
    CGRect rect = CGRectMake(0, 0,aSize.width, aSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//
#pragma mark 振动
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

#pragma mark  启动过渡图片
-(void)showStartTransitionView{
    if (!startView) {
        startView=[[XwelcomView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    [startView show];
}
-(void)hiddenStartTransitionView{
    if (startView) {
        [startView hidden];
    }
}


#pragma mark 是否支持蓝牙协议4.0
//是否支持蓝牙协议4.0
- (BOOL)whetherToSupportBluetoothProtocol
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        
        return NO;
        
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        
        //        platform = @"iPhone 3G";
        
        return NO;
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        
        return NO;
        //        platform = @"iPhone 3GS";
        
    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        
        return NO;
        //     platform = @"iPhone 4";
        
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        
        platform = @"iPhone 4S";
        
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        
        platform = @"iPhone 5";
        
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        
        platform = @"iPhone 5C";
        
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
        
        platform = @"iPhone 5S";
        
    }else if ([platform isEqualToString:@"iPod4,1"]) {
        
        return NO;
        //     platform = @"iPod touch 4";
        
    }else if ([platform isEqualToString:@"iPod5,1"]) {
        
        platform = @"iPod touch 5";
        
    }else if ([platform isEqualToString:@"iPod3,1"]) {
        
        return NO;
        //     platform = @"iPod touch 3";
        
    }else if ([platform isEqualToString:@"iPod2,1"]) {
        
        return NO;
        //     platform = @"iPod touch 2";
        
    }else if ([platform isEqualToString:@"iPod1,1"]) {
        
        return NO;
        //     platform = @"iPod touch";
        
    } else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {
        
        return NO;
        //      platform = @"iPad 3";
        
    } else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        
        return NO;
        //     platform = @"iPad 2";
        
    }else if ([platform isEqualToString:@"iPad1,1"]) {
        
        return NO;
        //     platform = @"iPad 1";
        
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        
        platform = @"ipad mini";
        
    } else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        
        return NO;
        //     platform = @"ipad 3";
        
    }
    
    return YES;
}

- (void)upDataVersion
{
    NSString *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *postdict = [[NSMutableDictionary alloc]init];
    [postdict setValue:@"ios" forKey:@"type"];
    [postdict setValue:version forKey:@"version"];
    [NetEngine POST:MyFirstAPPUpdate parameters:postdict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"resData login:%@",responseObject);
        if ([[responseObject valueForJSONKey:@"status"] isEqualToString:@"200"]) {
            if ([version floatValue] < [[[responseObject valueForKey:@"data"] valueForJSONStrKey:@"version"] floatValue]) {
                // 更新包路径
                packPath = [[responseObject valueForKey:@"data"] valueForJSONStrKey:@"url"];
                DLog(@"packPath:%@",packPath);
                
                // 分为强制更新与不强制更新
                //                NSString *force = [userDict valueForJSONStrKey:@"active"];
                //                if ([force isEqualToString:@"1"]) {
                //                    // 强制更新
                //
                //                    UIAlertView *forceAlterView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本 %@",[userDict valueForJSONStrKey:@"version"]] message:[userDict valueForJSONStrKey:@"desc"] delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil, nil];
                //                    forceAlterView.tag=199;
                //                    [forceAlterView show];
                //                }else{
                // 不强制更新
                UIAlertView *notForceAlterView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本 %@",[[responseObject valueForKey:@"data"] valueForJSONStrKey:@"version"]] message:nil delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"立即更新", nil];
                notForceAlterView.tag=198;
                [notForceAlterView show];
                //                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
}
@end
