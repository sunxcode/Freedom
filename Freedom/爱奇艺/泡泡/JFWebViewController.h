//  JFWebViewController.h
//  Freedom
//  Created by Freedom on 15/9/15.
#import <UIKit/UIKit.h>
#import "IqiyiBaseViewController.h"
@interface JFWebViewController : IqiyiBaseViewController
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) NSString *urlStr;
@end
