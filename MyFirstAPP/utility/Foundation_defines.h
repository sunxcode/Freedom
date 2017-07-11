

#ifdef _foundation_defines
#else
#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif

#define docPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define docDataPath [docPath stringByAppendingPathComponent:@"data.db"]
#define docDataInfoPath [docPath stringByAppendingPathComponent:@"Data/info"]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kApplicationFrameHeight [UIScreen mainScreen].applicationFrame.size.height

#define W(obj)   (!obj?0:(obj).frame.size.width)
#define H(obj)   (!obj?0:(obj).frame.size.height)
#define X(obj)   (!obj?0:(obj).frame.origin.x)
#define Y(obj)   (!obj?0:(obj).frame.origin.y)
#define XW(obj) (X(obj)+W(obj))
#define YH(obj) (Y(obj)+H(obj))
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]
#define Font(x) [UIFont systemFontOfSize:x]
#define NavY (kVersion7?20:0)
#define CGRectMakeXY(x,y,size) CGRectMake(x,y,size.width,size.height)
#define CGRectMakeWH(origin,w,h) CGRectMake(origin.x,origin.y,w,h)

#define S2N(x) [NSNumber numberWithInt:[x intValue]]
#define I2N(x) [NSNumber numberWithInt:x]
#define F2N(x) [NSNumber numberWithFloat:x]
#endif

/*******************淘宝定义的宏*****************/
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
// 定义这个常量,就可以在使用Masonry不必总带着前缀 `mas_`:
#define MAS_SHORTHAND
// 定义这个常量,以支持在 Masonry 语法中自动将基本类型转换为 object 类型:
#define MAS_SHORTHAND_GLOBALS
/**
 Synthsize a weak or strong reference.
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

/*******************我的网络资源文件*****************/
#define JSONResource(s) [[NSBundle mainBundle]pathForResource:s ofType:nil]
#define JSONWebResource(s) [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.isolar88.com/upload/xuechao/json/%@",s]]];
#define APPDelegate [UIApplication sharedApplication].delegate

/*******************通知处理*****************/
#define ServicePickViewSelected @"ServicePickViewSelected"
#define ServicePickViewSelectedKey @"ServicePickViewSelectedKey"

#define ServicePickViewCancleSelected @"ServicePickViewCancleSelected"
/*****服务日程界面**/
/*******************服务日程界面中选择日期的通知*****************/
#define DateDidSelected  @"DateDidSelected"

#define DateDidSelectedKey  @"DateDidSelectedKey"


/*****消息界面**/
/*******************新建分组中添加小组成员的通知*****************/
#define MessageAddFriendGroupSubControllerAddPerson @"MessageAddFriendGroupSubControllerAddPerson"











