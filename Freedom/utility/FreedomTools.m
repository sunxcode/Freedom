//  FreedomTools.m
//  Freedom
//  Created by htf on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "FreedomTools.h"
#import "TLUserHelper.h"
// 账号的存储路径
#define XFAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]
#import "SinaMode.h"
static UILabel *hLabel = nil;
@implementation FreedomTools
+ (CGFloat) getTextHeightOfText:(NSString *)text
                           font:(UIFont *)font
                          width:(CGFloat)width{
    if (hLabel == nil) {
        hLabel = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [hLabel setNumberOfLines:0];
    }
    hLabel.frameWidth = width;
    [hLabel setFont:font];
    [hLabel setText:text];
    return [hLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}
+ (void)createGroupAvatar:(TLGroup *)group finished:(void (^)(NSString *groupID))finished{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger usersCount = group.users.count > 9 ? 9 : group.users.count;
        CGFloat viewWidth = 200;
        CGFloat width = viewWidth / 3 * 0.85;
        CGFloat space3 = (viewWidth - width * 3) / 4;               // 三张图时的边距（图与图之间的边距）
        CGFloat space2 = (viewWidth - width * 2 + space3) / 2;      // 两张图时的边距
        CGFloat space1 = (viewWidth - width) / 2;                   // 一张图时的边距
        CGFloat y = usersCount > 6 ? space3 : (usersCount > 3 ? space2 : space1);
        CGFloat x = usersCount % 3 == 0 ? space3 : (usersCount % 3 == 2 ? space2 : space1);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
        [view setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.6]];
        __block NSInteger count = 0;        // 下载完成图片计数器
        for (NSInteger i = usersCount - 1; i >= 0; i--) {
            TLUser *user = [group.users objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
            [view addSubview:imageView];
            [imageView sd_setImageWithURL:TLURL(user.avatarURL) placeholderImage:[UIImage imageNamed:PuserLogo] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                count ++;
                if (count == usersCount) {     // 图片全部下载完成
                    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 2.0);
                    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
                    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    CGImageRef imageRef = image.CGImage;
                    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, CGRectMake(0, 0, view.frame.size.width * 2, view.frameHeight * 2));
                    UIImage *ansImage = [[UIImage alloc] initWithCGImage:imageRefRect];
                    NSData *imageViewData = UIImagePNGRepresentation(ansImage);
                    NSString *savedImagePath = [NSFileManager pathUserAvatar:group.groupAvatarPath];
                    [imageViewData writeToFile:savedImagePath atomically:YES];
                    CGImageRelease(imageRefRect);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (finished) {
                            finished(group.groupID);
                        }
                    });
                }
            }];
            if (i % 3 == 0) {   // 换行
                y += (width + space3);
                x = space3;
            }else if(i == 2 && usersCount == 3) {  // 换行，只有三个时
                y += (width + space3);
                x = space2;
            }else{
                x += (width + space3);
            }
        }
    });
}
+ (void)captureScreenshotFromView:(UIView *)view
                             rect:(CGRect)rect
                         finished:(void (^)(NSString *avatarPath))finished{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2.0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRef imageRef = image.CGImage;
        CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, CGRectMake(rect.origin.x * 2, rect.origin.y * 2, rect.size.width * 2, rect.size.height * 2));
        UIImage *ansImage = [[UIImage alloc] initWithCGImage:imageRefRect];
        NSData *imageViewData = UIImagePNGRepresentation(ansImage);
        NSString *imageName = [NSString stringWithFormat:@"%.0lf.png", [NSDate date].timeIntervalSince1970 * 10000];
        NSString *savedImagePath = [NSFileManager pathScreenshotImage:imageName];
        [imageViewData writeToFile:savedImagePath atomically:YES];
        CGImageRelease(imageRefRect);
        dispatch_async(dispatch_get_main_queue(), ^{
            finished(imageName);
        });
    });
}
+ (NSDate *)strToDate:(NSString *)str {
    NSAssert(str.length >0, @"str date error");
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:str];
    return inputDate;
}
+ (NSString *)getMinuteSecondWithSecond:(NSTimeInterval)time {
    
    int minute = (int)time / 60;
    int second = (int)time % 60;
    
    if (second > 9) { //2:10
        return [NSString stringWithFormat:@"%d:%d",minute,second];
    }
    
    //2:09
    return [NSString stringWithFormat:@"%d:0%d",minute,second];
}
+ (UIImage *)imageWithOriginalName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
+ (UIImage *)imageWithStretchableName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
+ (BOOL)isChinese:(NSString *)str {
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}
+ (void)show:(nullable NSString *)msg {
    UILabel *_msgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, -64, APPW, 64)];
    _msgLab.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    _msgLab.text = msg;
    _msgLab.textColor = [UIColor whiteColor];
    _msgLab.font = [UIFont boldSystemFontOfSize:18];
    _msgLab.textAlignment = NSTextAlignmentCenter;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_msgLab];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _msgLab.frame;
        frame.origin.y = 0;
        _msgLab.frame = frame;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_msgLab removeFromSuperview];
    });
}
+(FreedomTools *)sharedManager{
    static FreedomTools *shareUrl = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareUrl = [[self alloc]init];
    });
    return shareUrl;
}
-(NSString *)urlWithHomeData{
    NSString *urlStr = @"http://api.3g.tudou.com/v4/home?guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&ios=1&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=30&show_url=1&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1";
    return urlStr;
}
-(NSString *)urlWithclassifyData{
    NSString *urlStr = @"http://api.3g.tudou.com/v4_5/recommended_channels?excludeNew=0&guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=30&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1";
    
    return urlStr;
}
-(NSString *)urlWithDiscoverData{
    NSString *urlStr = @"http://discover.api.3g.tudou.com/v4_7/rec_discover?guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=30&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1";
    
    return urlStr;
}
-(NSString *)urlWithSubscribeData{
    NSString *urlStr = @"http://user.api.3g.tudou.com/v4_3/user/sub/update?guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&network=WIFI&operator=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=20&ty=0&u_item_size=3&update_time=0&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1";
    return urlStr;
}
-(NSString*)urlWithVideoDetailData:(NSString *)iid{
    NSString *urlStr = [NSString stringWithFormat:@"http://api.3g.tudou.com/v4/play/detail?guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&iid=%@&network=WIFI&operator=中国联通_46001&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pid=c0637223f8b69b02&show_playlist=1&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1",iid];
    
    
    return urlStr;
}
-(NSString *)urlWithVideo:(NSString *)iid{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.tudou.com/programs/view/html5embed.action?code=%@",iid];
    return urlStr;
}
-(NSString *)urlWithRecommentdata:(NSString *)iid{
    NSString *urlStr = [NSString stringWithFormat:@"http://rec.api.3g.tudou.com/v4/recommend/video?count=20&filterpay=0&guid=7066707c5bdc38af1621eaf94a6fe779&idfa=ACAF9226-F987-417B-A708-C95D482A732D&itemCode=%@&network=WIFI&ouid=10099212c9e3829656d4ea61e3858d53253b2f07&pg=1&pid=c0637223f8b69b02&pz=30&vdid=9AFEE982-6F94-4F57-9B33-69523E044CF4&ver=4.9.1",iid];
    return urlStr;
    
}
-(NSString *)urlWithJianShuData{
    NSString *urlStr = ResumeURL;
    return urlStr;
}
- (NSString *)version{
    if (_version == nil) {
        NSString *shortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *buildID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        _version = [NSString stringWithFormat:@"%@ (%@)", shortVersion, buildID];
    }
    return _version;
}
/*存储账号信息
 *
 *  @param account 账号模型*/
+ (void)saveAccount:(SinaAccount *)account{
    // 自定义对象的存储必须用NSKeyedArchiver
    [NSKeyedArchiver archiveRootObject:account toFile:XFAccountPath];
}
/*返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）*/
+ (SinaAccount *)account{
    
    // 加载模型
    SinaAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:XFAccountPath];
    
    /* 验证账号是否过期 */
    
    // 过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    // 获得过期时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    // 获得当前时间
    NSDate *now = [NSDate date];
    
    // 如果expiresTime <= now，过期
    /**
     NSOrderedAscending = -1L, 升序，右边 > 左边
     NSOrderedSame, 一样
     NSOrderedDescending 降序，右边 < 左边
     */
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending) { // 过期
        return nil;
    }
    
    return account;
}
+ (NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString{
    NSAssert(pattern != nil, @"%s: pattern 不可以为 nil", __PRETTY_FUNCTION__);
    NSAssert(findingString != nil, @"%s: findingString 不可以为 nil", __PRETTY_FUNCTION__);
    
    NSError *error = nil;
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:
                                   pattern options:NSRegularExpressionCaseInsensitive
                                                                         error:&error];
    
    // 查找匹配的字符串
    NSArray *result = [regExp matchesInString:findingString options:
                       NSMatchingReportCompletion range:
                       NSMakeRange(0, [findingString length])];
    
    if (error) {
        //  DLog(@"ERROR: %@", result);
        return nil;
    }
    
    NSUInteger count = [result count];
    // 没有查找到结果，返回空数组
    if (0 == count) {
        return [NSArray array];
    }
    
    // 将返回数组中的 NSTextCheckingResult 的实例的 range 取出生成新的 range 数组
    NSMutableArray *ranges = [[NSMutableArray alloc] initWithCapacity:count];
    for(NSInteger i = 0; i < count; i++)
    {
        @autoreleasepool {
            NSRange aRange = [[result objectAtIndex:i] range];
            [ranges addObject:[NSValue valueWithRange:aRange]];
        }
    }
    return ranges;
}
+ (NSMutableArray *)matchMobileLink:(NSString *)pattern{
    NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(\\(86\\))?(13[0-9]|15[0-35-9]|18[0125-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array=[regular matchesInString:pattern options:0 range:NSMakeRange(0, [pattern length])];
    
    for( NSTextCheckingResult * result in array){
        
        NSString * string=[pattern substringWithRange:result.range];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
        [linkArr addObject:dic];
    }
    return linkArr;
}
+ (NSMutableArray *)matchWebLink:(NSString *)pattern{
    // DLog(@"go here? go here? go here ?");
    
    NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array=[regular matchesInString:pattern options:0 range:NSMakeRange(0, [pattern length])];
    
    for( NSTextCheckingResult * result in array){
        
        NSString * string=[pattern substringWithRange:result.range];
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
        
        [linkArr addObject:dic];
    }
    // DLog(@"linkArr == %@",linkArr);
    return linkArr;
}
@end
