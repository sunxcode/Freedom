//
//  XFComposeViewController.m
//  Freedom
//
//  Created by Super on 15/10/9.
#import "SinaComposeViewController.h"
#import "SinaAuthController.h"
#import "SinaEmotion.h"
#import <Foundation/Foundation.h>
@interface SinaComposeViewController ()<UITextViewDelegate,XFComposeToolbarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/** 输入控件 */
@property (nonatomic, weak) SinaEmotionTextView *textView;
/** 键盘顶部的工具条 */
@property (nonatomic, weak) SinaComposeToolbar *toolbar;
/** 相册（存放拍照或者相册中选择的图片） */
@property (nonatomic,weak)SinaComposePhotosView *photoView;
/** 表情键盘 */
@property (nonatomic, strong) SinaEmotionKeyboard *emotionKeyboard;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;
@end
@implementation SinaComposeViewController
- (SinaEmotionKeyboard *)emotionKeyboard{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[SinaEmotionKeyboard alloc] init];
        self.emotionKeyboard.frameWidth = self.view.frame.size.width;
        self.emotionKeyboard.frameHeight = 256;
    }
    return _emotionKeyboard;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏内容
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];

    NSString *name = [SinaAccount account].name;
    NSString *prefix = @"发微博";
    if (name) {
        UILabel *titleView = [[UILabel alloc]init];
        titleView.frameHeight = 100;
        titleView.frameWidth = 200;
        titleView.numberOfLines = 0;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.frameY = 50;

        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
        titleView.attributedText = attStr;
        self.navigationItem.titleView = titleView;
    }else{
        self.title = prefix;
    }
    //设置输入框
    SinaEmotionTextView *textView = [[SinaEmotionTextView alloc]init];
    textView.placeholder = @"分享新鲜事...";
    // 垂直方向上永远可以拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:textView];
    textView.delegate = self;
    self.textView = textView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:@"EmotionDidSelectNotification" object:nil];
    SinaComposeToolbar *toolbar = [[SinaComposeToolbar alloc]init];
    toolbar.frame = CGRectMake(0, self.view.frameHeight - toolbar.frameHeight, self.view.frame.size.width, 44);
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    //添加图片

    SinaComposePhotosView *photoView = [[SinaComposePhotosView alloc]init];
    photoView.frame = CGRectMake(photoView.frame.origin.x, 130, self.view.frame.size.width, 400);
    [self.textView addSubview:photoView];
    self.photoView = photoView;
    [self.textView becomeFirstResponder];
}
//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)emotionDidSelect:(NSNotification *)notification{
    XFEmotion *emotion = notification.userInfo[@"SelectEmotionKey"];
    [self.textView insertEmotion:emotion];
}
-(void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (self.switchingKeybaord) return;
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y > self.view.frameHeight) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolbar.frameY = self.view.frameHeight - self.toolbar.frameHeight;
        } else {
            self.toolbar.frameY = keyboardF.origin.y - self.toolbar.frameHeight;
        }
    }];
}
#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - XFComposeToolbarDelegate
-(void)composeToolbar:(SinaComposeToolbar *)toolbar didClickButton:(XFComposeToolbarButtonType)buttonType {
    switch (buttonType) {
        case XFComposeToolbarButtonTypeCamera: // 拍照
            [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];break;
        case XFComposeToolbarButtonTypePicture: // 相册
            [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];break;
        case XFComposeToolbarButtonTypeMention:break;
        case XFComposeToolbarButtonTypeTrend:break;
        case XFComposeToolbarButtonTypeEmotion:[self switchkeyBoard];break;
    }
}
//切换键盘
-(void)switchkeyBoard {
    if (self.textView.inputView == nil) {
        self.textView.inputView = self.emotionKeyboard;
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
    }else {
        self.textView.inputView = nil;
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    // 开始切换键盘
    self.switchingKeybaord = YES;
    // 退出键盘
    [self.textView endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //弹出键盘
        [self.textView becomeFirstResponder];
        
        // 结束切换键盘
        self.switchingKeybaord = NO;
    });
}
- (void)openImagePickerController:(UIImagePickerControllerSourceType)type {
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = type;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}
#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //添加图片
    [self.photoView addPhoto:image];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 * 发布带有图片的微博*/
- (void)sendWithImage{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [SinaAccount account].access_token;
    params[@"status"] = self.textView.fullText;
    // 3.发送请求
    [[AFHTTPSessionManager manager] POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接文件数据
        UIImage *image = [self.photoView.photos firstObject];
        NSData *imageData = UIImageJPEGRepresentation(image,1.0);
        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
}
/**
 * 发布没有图片的微博*/
- (void)sendWithNoImage{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [SinaAccount account].access_token;
    params[@"status"] = self.textView.fullText;
    [[AFHTTPSessionManager manager] POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
}
//发微博
-(void)send {
    if (self.photoView.photos.count) {
        [self sendWithImage];
    }else {
        [self sendWithNoImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
