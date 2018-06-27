//  XFOAuthController.m
//  Freedom
//  Created by Super on 15/9/20.
#import "SinaAuthController.h"
#import "SinaTabBarController.h"
@implementation SinaAccount
/*存储账号信息@param account 账号模型*/
+ (void)saveAccount:(SinaAccount *)account{
    // 自定义对象的存储必须用NSKeyedArchiver
    NSString *XFAccountPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"];
    [NSKeyedArchiver archiveRootObject:account toFile:XFAccountPath];
}
/*返回账号信息@return 账号模型（如果账号过期，返回nil）*/
+ (SinaAccount *)account{
    NSString *XFAccountPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"];
    SinaAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:XFAccountPath];
    long long expires_in = [account.expires_in longLongValue];
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    NSDate *now = [NSDate date];
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending) { // 过期
        return nil;
    }
    return account;
}
+(instancetype)accountWithDict:(NSDictionary *)dict {
    SinaAccount *account = [[self alloc]init];
    account.access_token = dict[@"access_token"];
    account.uid = dict[@"uid"];
    account.expires_in = dict[@"expires_in"];
    account.created_time = [NSDate date];
    return account;
}
/*当一个对象要归档进沙盒中时，就会调用这个方法 目的：在这个方法中说明这个对象的哪些属性要存进沙盒*/
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.created_time forKey:@"created_time"];
    [aCoder encodeObject:self.name forKey:@"name"];
}
/*当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法*  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）*/
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.created_time = [aDecoder decodeObjectForKey:@"created_time"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}
@end

@interface SinaAuthController ()<UIWebViewDelegate>
@end
@implementation SinaAuthController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc]init];
    webView.delegate = self;
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=568898243&redirect_uri=http://www.sharesdk.cn"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
//隐藏状态栏
-(BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark-webView的代理方法
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"正在加载..."];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //获得Url
    NSString *url = request.URL.absoluteString;
    //判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        //截取code=后面的参数
        int fromIndex = (int)(range.location + range.length);
        NSString *code = [url substringFromIndex:fromIndex];
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
        //禁止加载回调页面
        return NO;
    }
    return YES;
}
/*利用code（授权成功后的request token）换取一个accessToken @param code 授权成功后的request token*/
- (void)accessTokenWithCode:(NSString *)code{
    NSString *url = @"https://api.weibo.com/oauth2/access_token";
    //拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"568898243";
    params[@"client_secret"] = @"38a4f8204cc784f81f9f0daaf31e02e3";
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"http://www.sharesdk.cn";
    params[@"code"] = code;
    [[AFHTTPSessionManager manager] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        // 将返回的账号字典数据 --> 模型，存进沙盒
        SinaAccount *account = [SinaAccount accountWithDict:responseObject];
        //储存账号信息
        [SinaAccount saveAccount:account];
        // 切换窗口的根控制器
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        [window switchRootViewController];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"失========败%@",error);
    }];
}
@end
