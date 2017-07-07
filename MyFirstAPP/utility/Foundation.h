
#import "Foundation_defines.h"

#define baseDomain   @"www.baidu.com"
#define basePort    @"80"
#define basePath     @"app"
#define basePicPath  @"www.baidu.com/"
#define BaseURL @"http://www.isolar88.com/app/upload/xuechao"
#define kTopHeight (kVersion7?64:44)
#define clearcolor [UIColor clearColor]
#define gradcolor RGBACOLOR(224, 225, 226, 1)
#define redcolor RGBACOLOR(229, 59, 25, 1)
#define blacktextcolor RGBACOLOR(33, 34, 35, 1)
#define gradtextcolor RGBACOLOR(116, 117, 118, 1)
#define Boardseperad 10
#define fontTitle Font(15)
#define fontnomal Font(13)
#define fontSmallTitle Font(14)
/******************登录注册*******************/
#define SENSMCODE @"user/sendMcode"//发送验证码
#define REGIST @"user/regist"//用户注册
#define LOGIN @"user/login"//登录
#define OTHWELOGIN @"user/tposlogin"//第三方登录
/******************编辑个人资料*******************/
#define GETPENSONSOUCE @"info/getuserinfo"//获取个人质料
#define EDITEMYSOUCE @"info/edtuserinfo"//编辑个人资料
#define CHANGELONGPWS @"info/changepwd"//修改密码
#define SUBMITCHANGW @"info/submitChange"//修改修改交易密码
#define FINSPSW @"user/findpwd"//找回密码
#define CHANGEBANGDING @"info/changemobile"//修改绑定手机
#define EDITEICON @"info/editphoto"//编辑头像
#define MyFirstAPPUpdate @"version/index"//版本更新


#define default_PageSize 10
#define default_StartPage 1
#define appVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Bundle version"]
#define Models_path @"/Users/xuechao/Desktop/MyFirstAPP/MyFirstAPP/Resources"
#define kVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
#define kVersion8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
#define isIpad      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define isIos7      ([[[UIDevice currentDevice] systemVersion] floatValue])

#define NetEngine [AFHTTPSessionManager manager] 
#define CN 1
#define UI_language(cn,us) CN?cn:us
#define UI_btn_back CN?@"返回":@"back"
#define UI_btn_search CN?@"搜索":@"Search"
#define UI_btn_upload CN?@"上传":@"Upload"
#define UI_btn_submit CN?@"提交":@"Submit"
#define UI_btn_cancel CN?@"取消":@"cancel"
#define UI_btn_confirm CN?@"确定":@"OK"
#define UI_btn_delete CN?@"删除":@"Delete"
#define UI_tips_load CN?@"正在加载...":@"Loading..."
#define alertErrorTxt @"服务器异常,请稍后再试"

#define DOCUMENTS_FOLDER [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"SpeechSoundDir"]//录音的存放文件夹
#define DOCUMENTS_CHAT_FOLDER [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"downAudio"]//语音聊天的录音存放文件夹
#define FILEPATH [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self fileNameString]]  //录音的路径
#define documentsDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"SpeechSoundDir"]//录音临时文件
#define K_alreadyNum @"K_alreadyNum"
#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define CACHESPATH  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define TEMPPATH NSTemporaryDirectory()

/* { thread } */
#define __async_opt__  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define __async_main__ dispatch_async(dispatch_get_main_queue()
//-------------wap------------------------
#define ZKWAPUrl @""
// WEBsocket
#define LikeWEBsocket @""

//合作身份者id，以2088开头的16位纯数字
#define PartnerID  @""
//收款支付宝账号
#define SellerID   @"zfb@"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @""

//支付宝公钥
#define AlipayPubKey    @""

#define alipayBackUrl @""//支付宝回掉路径
