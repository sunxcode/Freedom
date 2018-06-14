
#import "Foundation_API.h"
#import "Foundation_enum.h"
#ifdef DEBUG
#define ELog(err) {if(err) NSLog(@"%@", err)}
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
//@weakobj(self)[self doSomething^{@strongobj(self)[self back];}];
#if __has_feature(objc_arc)
#define weakobj(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#define strongobj(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define weakobj(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#define strongobj(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#define ELog(err)
#define DLog(...)
#if __has_feature(objc_arc)
#define weakobj(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#define strongobj(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define weakobj(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#define strongobj(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
/**********************       系       统      **********************/
#define APPVersion        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Bundle version"]
#define IOSVersion        ([[[UIDevice currentDevice] systemVersion] floatValue])
#define Version7          ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
#define Version8          ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
#define isIpad            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define APPDelegate       [[UIApplication sharedApplication]delegate]
#define iPhone5           ([UIScreen mainScreen].bounds.size.height == 568)
#define CN 1
#define UI_language(cn,us) CN?cn:us
#define MAS_SHORTHAND// 定义这个常量,就可以在使用Masonry不必总带着前缀 `mas_`:
#define MAS_SHORTHAND_GLOBALS// 定义这个常量,以支持在 Masonry 语法中自动将基本类型转换为 object 类型:
/**********************       方        法      **********************/
#define S2N(x)            [NSNumber numberWithInt:[x intValue]]
#define I2N(x)            [NSNumber numberWithInt:x]
#define F2N(x)            [NSNumber numberWithFloat:x]
#define RViewsBorder(View,radius,width,color)\
[View.layer setCornerRadius:(radius)];[View.layer setMasksToBounds:YES];[View.layer setBorderWidth:(width)];[View.layer setBorderColor:[color CGColor]]
/**********************     网   络   资   源    **********************/
#define FileResource(s)   [[NSBundle mainBundle]pathForResource:s ofType:nil]
#define JSONWebResource(s) [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.isolar88.com/upload/xuechao/json/%@",s]]];
#define __async_opt__  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define __async_main__ dispatch_async(dispatch_get_main_queue()
#define NetBase         [AFHTTPSessionManager manager]
#define Net   ({AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];manager.responseSerializer = [AFJSONResponseSerializer serializer];\
              manager.requestSerializer=[AFHTTPRequestSerializer serializer];[manager.requestSerializer setValue:@"text/json"  forHTTPHeaderField:@"Accept"];\
              [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];\
              manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain", @"application/xml",\
              @"text/xml",@"text/html",@"text/javascript", @"application/x-plist",   @"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico",\
              @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];(manager);})
#define WS(weakSelf)      __weak __typeof(&*self)weakSelf = self;
/**********************     字     符    串     ***********************/
#define alertErrorTxt     @"服务器异常,请稍后再试"
/**********************       尺        寸      ***********************/
#define APPW              [UIScreen mainScreen].bounds.size.width
#define APPH              [UIScreen mainScreen].bounds.size.height
#define ApplicationH      [UIScreen mainScreen].applicationFrame.size.height
#define TopHeight         (Version7?64:44)
#define NavY              (Version7?20:0)
#define TabBarH           60
#define Boardseperad      10
#define W(obj)            (!obj?0:(obj).frame.size.width)
#define H(obj)            (!obj?0:(obj).frame.size.height)
#define X(obj)            (!obj?0:(obj).frame.origin.x)
#define Y(obj)            (!obj?0:(obj).frame.origin.y)
#define XW(obj)           (X(obj)+W(obj))
#define YH(obj)           (Y(obj)+H(obj))
#define CGRectMakeXY(x,y,size) CGRectMake(x,y,size.width,size.height)
#define CGRectMakeWH(origin,w,h) CGRectMake(origin.x,origin.y,w,h)
/***********************       字        体      ************************/
#define fontTitle         Font(15)
#define fontnomal         Font(13)
#define fontSmallTitle    Font(14)
#define BoldFont(x)       [UIFont boldSystemFontOfSize:x]
#define Font(x)           [UIFont systemFontOfSize:x]
/***********************       颜        色      ************************/
#define RGBCOLOR(r,g,b)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RandomColor       RGBCOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define clearcolor        [UIColor clearColor]
#define gradcolor         RGBACOLOR(224, 225, 226, 1)
#define redcolor          RGBACOLOR(229, 59, 25, 1)
#define yellowcolor       [UIColor yellowColor]
#define greencolor        [UIColor greenColor]
#define whitecolor        RGBACOLOR(256, 256,256,1)
#define blacktextcolor    RGBACOLOR(33, 34, 35, 1)
#define gradtextcolor     RGBACOLOR(116, 117, 118, 1)
#define graycolor         [UIColor grayColor]
/************************   文  件  与  文  件  夹  ***********************/
#define HOMEPATH          NSHomeDirectory()//主页路径
#define documentPath      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0]//Documents路径
#define cachePath         [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define tempPath          NSTemporaryDirectory()
#define DOCUMENTS_FOLDER  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define FOLDERPATH(s)     [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:s]
#define FILEPATH          [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self fileNameString]]
/************************      额  外  的  宏     ************************/
#define JFSearchHistoryPath [cachePath stringByAppendingPathComponent:@"hisDatas.data"]//搜索文件
#define     APP_CHANNEL         @"Github"
#define     DEBUG_LOCAL_SERVER      // 使用本地测试服务器
#ifdef  DEBUG_LOCAL_SERVER
#define     HOST_URL        @"http://127.0.0.1:8000/"            // 本地测试服务器
#else
#define     HOST_URL        @"http://121.42.29.15:8000/"         // 远程线上服务器
#endif
#define TableHeader 50
#define ShowImage_H 80
#define PlaceHolder @" "
#define PQRCode @"u_QRCode"
#define PuserLogo @"userLogo"
#define offSet_X 20
#define EmotionItemPattern    @"\\[em:(\\d+):\\]"
#define kDistance 20 //说说和图片的间隔
#define kReplyBtnDistance 30 //回复按钮距离
#define kReply_FavourDistance 8 //回复按钮到点赞的距离
#define AttributedImageNameKey      @"ImageName"
#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height
#define limitline 4
#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4] //点击背景  颜色
#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]//点击姓名颜色
#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))
#define kContentText1 @"思想不会流血，不会感到痛苦，思想不会死去"
#define kContentText2 @"这张面具之下，不是肉体，而是一种思想但思想是不怕子弹的"
#define kContentText3 @"Most people are so ungrateful to be alive. But not you. Not anymore. "
#define kContentText4 @"活着本来没有什么意义，但只要活着就会发现很多有趣的13688919929事，就像你发现了花，我又发现你一样[em:03:]。"
#define kContentText5 @"地狱的房间已满，于是，[em:02:][em:02:]死亡爬上了人间如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中"
#define kContentText6 @"如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中"
#define kShuoshuoText1 @"驱魔人 “你可知道邪恶深藏于你心深处，但我会始终在你的[em:02:]左右，握着我的手，我会让你看到神迹，抱紧信仰，除此你一无所有！”"
#define kShuoshuoText2 @"李太啊，我的饺子最好吃，劲道、柔软、不露馅[em:03:]揉面的时候要一直揉到面团表面象剥了壳的鸡蛋，吃起来一包鲜汁"
#define kShuoshuoText3 @"如果晚上月亮升起的时候，月光www.baidu.com照到我的门口，我希望[em:03:]月光www.baidu.com女神能满足我一个愿望，我想要一双人类的手。我想用我的双手把我的爱人紧紧地拥在怀中，哪怕只有一次。如果我从来没有品尝过温暖的感觉，也许我不会这样寒冷；如果我从没有感受过爱情的甜美，我也许就不会这样地痛苦。如果我没有遇到善良的佩格，如果我从来不曾离开过我的房间，我就不会知道我原来是这样的孤独"
#define kShuoshuoText4 @"人有的时候很脆弱，会遇到很多不如意18618881888的事，日积月累就会形成心结，就算想告诉亲戚朋友，他们也未必懂得怎样[em:03:]开解"
#define kShuoshuoText5 @"如果是像金钱这种东西被抢走的话，再抢[em:03:]回来就好了！但如果是人性或温暖的心的话……那就只有遇上心中同样是空虚的人，才有www.baidu.com办法帮你填补起内心的空洞"
#define kShuoshuoText6 @"双目瞪人玛[em:03:]丽肖,傀儡为子常怀抱,汝辈小儿需切记,梦中遇她莫尖叫"

#define     HEIGHT_TABBAR               49.0f
#define     HEIGHT_NAVBAR               44.0f
#define     NAVBAR_ITEM_FIXED_SPACE     5.0f
#define     BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)
#define     MAX_MESSAGE_WIDTH               APPW * 0.58
#define     TLURL(urlString)    [NSURL URLWithString:urlString]
#define     TLNoNilString(str)  (str.length > 0 ? str : @"")
#define     TLTimeStamp(date)   ([NSString stringWithFormat:@"%lf", [date timeIntervalSince1970]])
#define     HEIGHT_CHATBAR_TEXTVIEW         36.0f
#define     HEIGHT_MAX_CHATBAR_TEXTVIEW     111.5f
#define     HEIGHT_CHAT_KEYBOARD            215.0f
#define colorGrayLine RGBACOLOR(200, 200, 200, 1.0)
#define colorGrayBG RGBACOLOR(239.0, 239.0, 244.0, 1.0)
#define colorGreenDefault RGBACOLOR(2.0, 187.0, 0.0, 1.0f)
#define baseDomain   @"www.baidu.com"
#define basePort     @"80"
#define basePath     @"app"
#define basePicPath  @"www.baidu.com/"
#define BaseURL      @"http://www.isolar88.com/app/upload/xuechao"
#define FREEDOMItems @[@{@"icon":@"kugouIcon",@"title":@"酷狗",@"control":@"Kugou"},@{@"icon":@"juheIcon",@"title":@"聚合数据",@"control":@"JuheData"},@{@"icon":@"aiqiyiIcon",@"title":@"爱奇艺",@"control":@"Iqiyi"},@{@"icon":@"taobaoIcon",@"title":@"淘宝",@"control":@"Taobao"},@{@"icon":@"weiboIcon",@"title":@"新浪微博",@"control":@"Sina"},@{@"icon":@"zhifubaoIcon",@"title":@"支付宝",@"control":@"Alipay"},@{@"icon":@"jianliIcon",@"title":@"我的简历",@"control":@"Resume"},@{@"icon":@"database",@"title":@"我的数据库",@"control":@"MyDatabase"},@{@"icon":@"shengyibaoIcon",@"title":@"微能量",@"control":@"MicroEnergy"},@{@"icon":@"weixinIcon",@"title":@"微信",@"control":@"Wechart"},@{@"icon":@"dianpingIcon",@"title":@"大众点评",@"control":@"Dianping"},@{@"icon":@"toutiaoIcon",@"title":@"今日头条",@"control":@"Toutiao"},@{@"icon":@"books",@"title":@"书籍收藏",@"control":@"Books"},@{@"icon":@"ziyouzhuyi",@"title":@"个性特色自由主义",@"control":@"Freedom"},@{@"icon":@"yingyongIcon",@"title":@"个人应用",@"control":@"PersonalApply"}]

/******************           支      付     宝           *******************/
#define PartnerID  @""//合作身份者id，以2088开头的16位纯数字
#define SellerID   @"zfb@"//收款支付宝账号
#define MD5_KEY @""//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define AlipayPubKey    @""//支付宝公钥
#define alipayBackUrl @""//支付宝回掉路径
/******************           微             信           *******************/
// UMeng
#define     UMENG_APPKEY        @"56b8ba33e0f55a15480020b0"
// JSPatch
#define     JSPATCH_APPKEY      @"7eadab71a29a784e"
// 七牛云存储
#define     QINIU_APPKEY        @"28ed72E3r7nfEjApnsHWQhItdqyZqTLCtcfQZp9I"
#define     QINIU_SECRET        @"aRYPqQYF9rK9EVJfcu849VY0PAky2Sfj97Sp349S"
// Mob SMS
#define     MOB_SMS_APPKEY      @"1133dc881b63b"
#define     MOB_SMS_SECRET      @"b4882225b9baee69761071c8cfa848f3"
/******************           微             博           *******************/
/******************               shareSDK               *******************/
/******************           百      度    SDK           *******************/
/******************           科   大   讯   飞           *******************/
/******************           易            信           *******************/
/******************           蓝            牙           *******************/
