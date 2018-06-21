//  TLMyQRCodeViewController.m
//  Freedom
//  Created by Super on 16/3/4.
#import "WXMyQRCodeViewController.h"
#import "WXScanningViewController.h"
#import "WXQRCodeViewController.h"
#define         ACTIONTAG_SHOW_SCANNER          101
#import "WXActionSheet.h"
#import "WXUserHelper.h"
@interface WXMyQRCodeViewController () <WXActionSheetDelegate>
@property (nonatomic, strong) WXQRCodeViewController *qrCodeVC;
@end
@implementation WXMyQRCodeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
    [self.navigationItem setTitle:@"我的二维码"];
    
    [self.view addSubview:self.qrCodeVC.view];
    [self addChildViewController:self.qrCodeVC];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_more"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    [self setUser:[WXUserHelper sharedHelper].user];
}
- (void)setUser:(WXUser *)user{
    _user = user;
    self.qrCodeVC.avatarURL = user.avatarURL;
    self.qrCodeVC.username = self.user.showName;
    self.qrCodeVC.subTitle = self.user.detailInfo.location;
    self.qrCodeVC.qrCode = self.user.userID;
    self.qrCodeVC.introduction = @"扫一扫上面的二维码图案，加我微信";
}
#pragma mark - Delegate
//MARK: TLActionSheetDelegate
- (void)actionSheet:(WXActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == ACTIONTAG_SHOW_SCANNER && buttonIndex == 2) {
        WXScanningViewController *scannerVC = [[WXScanningViewController alloc] init];
        [scannerVC setDisableFunctionBar:YES];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:scannerVC animated:YES];
    }else if (buttonIndex == 1) {
        [self.qrCodeVC saveQRCodeToSystemAlbum];
    }
}
#pragma mark - Event Response
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    WXActionSheet *actionSheet;
    if ([self.navigationController findViewController:@"TLScanningViewController"]) {
        actionSheet = [[WXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"换个样式", @"保存图片", nil];
    }else{
        actionSheet = [[WXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"换个样式", @"保存图片", @"扫描二维码", nil];
        actionSheet.tag = ACTIONTAG_SHOW_SCANNER;
    }
    [actionSheet show];
}
#pragma mark - Getter
- (WXQRCodeViewController *)qrCodeVC{
    if (_qrCodeVC == nil) {
        _qrCodeVC = [[WXQRCodeViewController alloc] init];
    }
    return _qrCodeVC;
}
@end
