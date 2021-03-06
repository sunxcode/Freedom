//  TLWebViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WXBaseViewController.h"
@interface WXWebViewController : WXBaseViewController <WKNavigationDelegate>
/// 是否使用网页标题作为nav标题，默认YES
@property (nonatomic, assign) BOOL useMPageTitleAsNavTitle;
/// 是否显示加载进度，默认YES
@property (nonatomic, assign) BOOL showLoadingProgress;
// 是否禁止历史记录，默认NO
@property (nonatomic, assign) BOOL disableBackButton;
@property (nonatomic, strong) NSString *url;
@end
