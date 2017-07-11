
#import "BaseViewController.h"
#import "Reachability.h"
#include <objc/runtime.h>
#import "UIControl+Addition.h"
static BaseViewController *BVC = nil;
@interface BaseViewController (){
    BOOL boolNavTitleAnimate;
    BOOL boolDefaultNavTitleAnimate;
    
}
@property (nonatomic,strong) UILabel *sizeLabel;
@property (nonatomic,strong) UITextView *sizeTextView;
@property (nonatomic,strong) UIView *DefaultNavView;
@end
@implementation BaseViewController
+ (BaseViewController *) sharedViewController{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        BVC = [[BaseViewController alloc] init];
    });
    return BVC;
}
- (id)initWithNavStyle:(NSInteger)style{
    self = [super init];
    if (self) {
        // Custom initialization
    }return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[Utility Share]setCurrentViewController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)name:kReachabilityChangedNotification object:nil];
    if (kVersion7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    
    self.navView.backgroundColor = [UIColor whiteColor];
    if (kVersion7) {
        self.automaticallyAdjustsScrollViewInsets=NO;
        self.navigationController.navigationBarHidden = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.navigationController.navigationBar setBarTintColor:gradcolor];
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.view setBackgroundColor:gradcolor];
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor],[UIFont boldSystemFontOfSize:18.0f], nil] forKeys:[NSArray arrayWithObjects: NSForegroundColorAttributeName,NSFontAttributeName, nil]];
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }else{
        self.navigationController.navigationBarHidden = YES;
    }
    [self.view setClipsToBounds:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClicked:)];
     self.navigationItem.leftBarButtonItem=backItem;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (kVersion7) {
        CGFloat topBarOffset = [[self performSelector:@selector(topLayoutGuide)] length];
        DLog(@"topBarOffset:%f",topBarOffset);
        self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else{
    }
}
-(void)updateDefaultNavView:(NSString *)strTitle{
    if(!self.DefaultNavView){
        self.DefaultNavView = [[UIView alloc] initWithFrame:CGRectMake(70, 0, kScreenWidth-140, 44)];
        [self.DefaultNavView setBackgroundColor:[UIColor clearColor]];
        if (strTitle.length) {
            UIView *nV=[[UIView alloc]initWithFrame:self.DefaultNavView.bounds];
            nV.backgroundColor=[UIColor clearColor];
            nV.clipsToBounds=YES;
            nV.tag=202;
            CAGradientLayer* gradientMask = [CAGradientLayer layer];
            gradientMask.bounds = nV.layer.bounds;
            gradientMask.position = CGPointMake([nV bounds].size.width / 2, [nV bounds].size.height / 2);
            NSObject *transparent = (NSObject*) [[UIColor clearColor] CGColor];
            NSObject *opaque = (NSObject*) [[UIColor blackColor] CGColor];
            gradientMask.startPoint = CGPointMake(0.0, CGRectGetMidY(nV.frame));
            gradientMask.endPoint = CGPointMake(1.0, CGRectGetMidY(nV.frame));
            float fadePoint = (float)10/nV.frame.size.width;
            [gradientMask setColors: [NSArray arrayWithObjects: transparent, opaque, opaque, transparent, nil]];
            [gradientMask setLocations: [NSArray arrayWithObjects:
                                         [NSNumber numberWithFloat: 0.0],
                                         [NSNumber numberWithFloat: fadePoint],
                                         [NSNumber numberWithFloat: 1 - fadePoint],
                                         [NSNumber numberWithFloat: 1.0],
                                         nil]];
            nV.layer.mask = gradientMask;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W(self.DefaultNavView), 44)];
            label.backgroundColor = [UIColor clearColor];
            label.font = BoldFont(18);
            label.textColor  = [UIColor whiteColor];
            label.shadowOffset = CGSizeMake(0, 0);
            label.text = strTitle;
            label.tag = 201;
            label.textAlignment = NSTextAlignmentCenter;
            [nV addSubview:label];
            [self.DefaultNavView addSubview:nV];
        }
        self.navigationItem.titleView=self.DefaultNavView;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UILabel *label = (UILabel*)[self.DefaultNavView viewWithTag:201];
    [label.layer removeAllAnimations];
    CGRect frame=CGRectMake(10, 0, W(self.DefaultNavView)-20,44);
    label.frame=frame;
    label.text = strTitle;
    CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    boolDefaultNavTitleAnimate=NO;
    if (frame.size.width<size.width) {
        frame.size.width=size.width;
        label.frame=frame;
        [self performSelector:@selector(startDefaultNavTitleAnimate) withObject:nil afterDelay:5.0];
    }
}
-(UIView *)navbarTitle:(NSString *)title titleView:(UIView *)titleV titleFrame:(CGRect)frame NavBGColor:(UIColor *)color NavBGImage:(NSString *)image hiddenLine:(BOOL)bLine{
    if(!self.navView){
        self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kVersion7?64:44)];
        UIImageView *imageview = [RHMethods imageviewWithFrame:CGRectMake(0, kVersion7?0:-20, kScreenWidth, 64) defaultimage:@""];
        imageview.tag=103;
        [imageview setContentMode:UIViewContentModeScaleAspectFill];
        [self.navView addSubview:imageview];
        
        UIView *viewLine=[[UIView alloc]initWithFrame:CGRectMake(0, H(self.navView)-1, W(self.navView), 0.5)];
        viewLine.backgroundColor=RGBACOLOR(0, 0, 0, 0.2);
        viewLine.tag=104;
        [self.navView addSubview:viewLine];
        self.navView.clipsToBounds = NO;
        if (title.length) {
            UIView *nV=[[UIView alloc]initWithFrame:CGRectMake(60, kVersion7?20:0, kScreenWidth-120, 44)];
            nV.backgroundColor=[UIColor clearColor];
            nV.clipsToBounds=YES;
            nV.tag=102;
            CAGradientLayer* gradientMask = [CAGradientLayer layer];
            gradientMask.bounds = nV.layer.bounds;
            gradientMask.position = CGPointMake([nV bounds].size.width / 2, [nV bounds].size.height / 2);
            NSObject *transparent = (NSObject*) [[UIColor clearColor] CGColor];
            NSObject *opaque = (NSObject*) [[UIColor blackColor] CGColor];
            gradientMask.startPoint = CGPointMake(0.0, CGRectGetMidY(nV.frame));
            gradientMask.endPoint = CGPointMake(1.0, CGRectGetMidY(nV.frame));
            float fadePoint = (float)10/nV.frame.size.width;
            [gradientMask setColors: [NSArray arrayWithObjects: transparent, opaque, opaque, transparent, nil]];
            [gradientMask setLocations: [NSArray arrayWithObjects:
                                         [NSNumber numberWithFloat: 0.0],
                                         [NSNumber numberWithFloat: fadePoint],
                                         [NSNumber numberWithFloat: 1 - fadePoint],
                                         [NSNumber numberWithFloat: 1.0],
                                         nil]];
            nV.layer.mask = gradientMask;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-140, 44)];
            label.backgroundColor = [UIColor clearColor];
            label.font = BoldFont(18);
            label.textColor  = [UIColor blackColor];
            label.shadowOffset = CGSizeMake(0, 0);
            label.text = title;
            label.tag = 101;
            label.textAlignment = NSTextAlignmentCenter;
            [nV addSubview:label];
            [self.navView addSubview:nV];
        }
        [self.view addSubview:self.navView];
    }
    UIView *vLine=[self.navView viewWithTag:104];
    vLine.hidden=bLine;
    if (CGRectEqualToRect(frame,CGRectNull)||CGRectEqualToRect(frame, CGRectZero)){
        frame = CGRectMake(10, NavY, kScreenWidth-140, 44);
    }
    if (color) {
        [self.navView setBackgroundColor:color];
    }
    if (image){
        UIImageView *imageV=(UIImageView *)[self.navView viewWithTag:103];
        imageV.image=[UIImage imageNamed:image];
    }
    if (titleV){
        titleV.frame = frame;
        [self.navView addSubview:titleV];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UILabel *label = (UILabel*)[self.navView viewWithTag:101];
    [label.layer removeAllAnimations];
    label.frame=frame;
    label.text = title;
    CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    boolNavTitleAnimate=NO;
    if (frame.size.width<size.width) {
        frame.size.width=size.width;
        label.frame=frame;
        [self performSelector:@selector(startNavTitleAnimate) withObject:nil afterDelay:5.0];
    }
    return self.navView;
}
- (UIView*)navbarTitle:(NSString*)title{
    [self navbarTitle:title titleView:nil titleFrame:CGRectNull NavBGColor:[UIColor whiteColor] NavBGImage:nil hiddenLine:NO];
    return self.navView;
}
-(void)startDefaultNavTitleAnimate{
    boolDefaultNavTitleAnimate=YES;
    UILabel *label = (UILabel*)[self.DefaultNavView viewWithTag:201];
    CGRect frame=label.frame;
    frame.origin.x=-frame.size.width;
    UIView *nBGv=[self.DefaultNavView viewWithTag:202];
    [UIView animateWithDuration:5.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        label.frame = frame;
    } completion:^(BOOL finished) {
        if (boolDefaultNavTitleAnimate) {
            [self EntertainingDiversionsAnimation:10.8 aView:label subView:nBGv];
        }
    }];
}
-(void)startNavTitleAnimate{
    boolNavTitleAnimate=YES;
    UILabel *label = (UILabel*)[self.navView viewWithTag:101];
    CGRect frame=label.frame;
    frame.origin.x=-frame.size.width;
    UIView *nBGv=[self.navView viewWithTag:102];
    [UIView animateWithDuration:5.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        label.frame = frame;
    } completion:^(BOOL finished) {
        if (boolNavTitleAnimate) {
            [self EntertainingDiversionsAnimation:10.8 aView:label subView:nBGv];
        }
    }];
}
-(void)EntertainingDiversionsAnimation:(NSTimeInterval)interval aView:(UIView *)av subView:(UIView *)sv{
    CGRect frame =av.frame;
    frame.origin.x=sv.frame.size.width;
    av.frame=frame;
    frame.origin.x=-frame.size.width;
    [UIView animateWithDuration:interval
                          delay:0.0
                        options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear
                     animations:^{
                         av.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


- (UIButton*)backButton{
    return [self backButton:self];
}
- (UIButton*)backButton:(BaseViewController*)target{
    UIButton *button = (UIButton*)[self.navView viewWithTag:100];
    if (button) {
        return button;
    }
    button = [[UIButton alloc] initWithFrame:CGRectMake(10,kVersion7?20:0, 100, 44)];
    [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = Font(15);
    button.tag = 100;
    [button removeAllTargets];
    [button addTarget:target action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [target.navView addSubview:button];
    return button;
}
-(UIButton *)leftButton:(CGRect)frame title:(NSString *)title image:(NSString *)image round:(BOOL)round sel:(SEL)sel{
    if (!self.navleftButton) {
        self.navleftButton = [[UIButton alloc] initWithFrame:frame];
    }
    if(image){
        [self.navleftButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [self.navleftButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    }
    if(round){
        [self.navleftButton setImageEdgeInsets:UIEdgeInsetsZero];
        self.navleftButton.layer.cornerRadius = frame.size.width/2;
        self.navleftButton.layer.masksToBounds = YES;
    }
    if(title){
        [self.navleftButton setTitle:title forState:UIControlStateNormal];
        [self.navleftButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [self.navleftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -47, 0, 0)];
        [self.navleftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -47, 0, 0)];
        self.navleftButton.titleLabel.font = Font(15);
    }
    [self.navleftButton removeAllTargets];
    if(sel)[self.navleftButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.navleftButton];
    return self.navleftButton;
}
-(UIButton *)rightButton:(CGRect)frame title:(NSString *)title image:(NSString *)image round:(BOOL)round sel:(SEL)sel{
    if (!self.navrightButton) {
        self.navrightButton = [[UIButton alloc] initWithFrame:frame];
    }
    if(image){
        [self.navrightButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [self.navrightButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    }
    if(round){
        [self.navrightButton setImageEdgeInsets:UIEdgeInsetsZero];
        self.navrightButton.layer.cornerRadius = frame.size.width/2;
        self.navleftButton.layer.masksToBounds = YES;
    }
    if(title){
        [self.navrightButton setTitle:title forState:UIControlStateNormal];
        [self.navrightButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        if (image) {
            [self.navrightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            [self.navrightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        }else{
            [self.navrightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        self.navrightButton.titleLabel.font = Font(15);
        
    }
    [self.navrightButton removeAllTargets];
    self.navrightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    if(sel)[self.navrightButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.navrightButton];
    return self.navrightButton;
}

- (void)setTitle:(NSString *)title{
    for (UIView *view in self.navView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            ((UILabel*)view).text = title;
            break;
        }
    }
    [super setTitle:title];
}
- (NSString*)navTitle{
    UILabel *label = (UILabel*)[self.navView viewWithTag:101];
    if (label) {
        return label.text;
    }
    return @"";
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - Methods
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info{
    return [self pushController:controller withInfo:info withTitle:nil withOther:nil tabBar:YES];
}
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title{
    return [self pushController:controller withInfo:info withTitle:title withOther:nil tabBar:YES];
}
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other{
   return [self pushController:controller withInfo:info withTitle:title withOther:other tabBar:YES];
}
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBar:(BOOL)abool{
#pragma mark  zxh 框架修改 跳转
    DLog(@"\n跳转到 %@ 页面 %@",title,NSStringFromClass(controller));
    DLog(@"\nBase UserInfo:%@",info);
    DLog(@"\nBase OtherInfo:%@",other);
    BaseViewController *base = [[controller alloc] init];
    if ([(NSObject*)base respondsToSelector:@selector(setUserInfo:)]) {
        base.userInfo = info;
        base.otherInfo = other;
    }
    base.hidesBottomBarWhenPushed=abool;
    [self.navigationController pushViewController:base animated:YES];
        if ([(NSObject*)base respondsToSelector:@selector(setUserInfo:)]) {
            [base navbarTitle:title];
            if (base.navleftButton) {
                [base.navView addSubview:base.navleftButton];
            }else{
                [base backButton:base];
            }
            if (base.navrightButton) {
                [base.navView addSubview:base.navrightButton];
            }
        }
    return base;
}
//不需要Base来配置头部
- (BaseViewController*)pushController:(Class)controller withOnlyInfo:(id)info{
    DLog(@"Base UserInfo:%@",info);
    BaseViewController *base = [[controller alloc] init];
    if ([(NSObject*)base respondsToSelector:@selector(setUserInfo:)]) {
        base.userInfo = info;
    }
    [self.navigationController pushViewController:base animated:YES];
    return base;
}
- (void)lj_popController:(id)controller{
    //Class cls = NSClassFromString(controller);
    if ([controller isKindOfClass:[UIViewController class]]) {
        [self.navigationController popToViewController:controller animated:YES];
    }else{
        DLog(@"popToController NOT FOUND.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)popController:(NSString*)controllerstr withSel:(SEL)sel withObj:(id)info{
#pragma mark  zxh 框架修改 跳转
    DLog(@"\n返回到 %@ 页面",controllerstr);
    if ([info isKindOfClass:[NSDictionary class]]) {
        DLog(@"\nBase UserInfo:%@",info);
    }
    for (id controller in self.navigationController.viewControllers) {
        if ([NSStringFromClass([controller class]) isEqualToString:controllerstr]) {
            if ([(NSObject*)controller respondsToSelector:sel]) {
                [controller performSelector:sel withObject:info afterDelay:0.01];
            }
            [self lj_popController:controller];
            break;
        }
    }
}
- (void)popController:(NSString*)controller{
    Class cls = NSClassFromString(controller);
    if ([cls isSubclassOfClass:[UIViewController class]]) {
        [self.navigationController popToViewController:(UIViewController*)cls animated:YES];
    }else{
        DLog(@"popToController NOT FOUND.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *	根据文字计算Label高度
 *	@param	_width	限制宽度
 *	@param	_font	字体
 *	@param	_text	文字内容
 *	@param	_aLine	文字内容换行行间距
 *	@return	Label高度
 */
- (CGFloat)heightForLabel:(CGFloat)_width font:(UIFont*)_font text:(NSString*)_text floatLine:(CGFloat)_aLine{
    if (!self.sizeLabel) {
        self.sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    }
    self.sizeLabel.numberOfLines = 0;
    self.sizeLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    [self.sizeLabel setLineBreakMode:NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping];
    self.sizeLabel.font = _font;
    if (_text) {
        self.sizeLabel.text = _text;
        if (_aLine) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_text];
            NSMutableParagraphStyle *paragraphStyleT = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyleT setLineSpacing:_aLine];//调整行间距
            paragraphStyleT.lineBreakMode = NSLineBreakByWordWrapping;
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleT range:NSMakeRange(0, [_text length])];
            self.sizeLabel.attributedText = attributedString;
        }
        return [self.sizeLabel sizeThatFits:CGSizeMake(_width, MAXFLOAT)].height;
    }else{
        return 0;
    }
}
- (CGFloat)heightForTextView:(CGFloat)_width font:(UIFont*)_font text:(NSString*)_text floatLine:(CGFloat)_aLine{
    if (!self.sizeTextView) {
        self.sizeTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        [self.view addSubview:self.sizeTextView];
        self.sizeTextView.alpha=0.0;
    }
    [self.sizeTextView setEditable:NO];
    self.sizeTextView.frame=CGRectMake(X(self.sizeTextView), Y(self.sizeTextView), _width, 20);
    self.sizeTextView.font = _font;
    if (_text) {
        self.sizeTextView.text = _text;
        if (_aLine) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineSpacing = _aLine;
            NSDictionary *attributes = @{ NSFontAttributeName:_font, NSParagraphStyleAttributeName:paragraphStyle};
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            self.sizeTextView.attributedText =[[NSAttributedString alloc]initWithString:_text attributes:attributes];
             if (kVersion7) {
                CGSize size = [_text boundingRectWithSize:CGSizeMake(_width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
                DLog(@"TextView的高度:%f",size.height);
                return  size.height;
            }else{
                return self.sizeTextView.contentSize.height-16;
            }
        }
        return [self.sizeTextView sizeThatFits:CGSizeMake(_width, MAXFLOAT)].height;
    }else{
        return 0;
    }
}
#pragma mark - Actions
- (IBAction)backByButtonTagNavClicked:(UIButton*)sender{
    NSArray *controllers = [(UITabBarController*)[(UIWindow*)[[UIApplication sharedApplication] windows][0] rootViewController] viewControllers];
    if (controllers.count>sender.tag) {
        [controllers[sender.tag] popViewControllerAnimated:YES];
    }else{
        DLog(@"Nav Not Found.");
    }
}
- (IBAction)backButtonClicked:(id)sender{
    [SVProgressHUD dismiss];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)rootButtonClicked:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -Notify
-(void) reachabilityChanged:(NSNotification*) notification{
    if ([(Reachability*)[notification object] currentReachabilityStatus] == ReachableViaWiFi) {
        NSLog(@"网络状态改变了.");
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addFloatView{
    
}
- (void)readData {
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TotalData"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"icon" ascending:NO]];
    NSError *error = nil;
    NSArray *a = [del.managedObjectContext executeFetchRequest:request error:&error];
    DLog(@"%@", error);
    if (!a || ([a isKindOfClass:[NSArray class]] && [a count] <= 0)) {
        // 添加数据到数据库
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *strPath = [[NSBundle mainBundle] pathForResource:@"icons" ofType:@"txt"];
            NSString *text = [NSString stringWithContentsOfFile:strPath encoding:NSUTF16StringEncoding error:nil];
            NSArray *lineArr = [text componentsSeparatedByString:@"\n"];
            AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"TotalData" inManagedObjectContext:del.managedObjectContext];
            for (NSString *line in lineArr) {
                NSArray *icons = [line componentsSeparatedByString:@"\t"];
                /*items[0],items[1], items[2], items[3], items[4], items[5]*/
                TotalData *icon = [[TotalData alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
                icon.title = icons[0];
                icon.icon = icons[1];
                DLog(@"%@===%@",icons,icons[2]);
                icon.control = icons[2];
            }
            [del saveContext];
            //从数据库中读
            NSError *error = nil;
            NSArray *b = [del.managedObjectContext executeFetchRequest:request error:&error];
            if (error) {
                DLog(@"%@", error);
            } else {
                self.items = [NSArray arrayWithArray:b];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [collectionView reloadData];
                });
            }
        });
    } else {
        self.items = [NSArray arrayWithArray:a];
        //        [collectionView reloadData];
    }
    //     删除所有数据
//                for (TotalData *postcode in a) {
//                    [del.managedObjectContext deleteObject:postcode];
//                }
//                [del saveContext];
}

-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier{
    DLog(@"代理通知发现点击了控制器%@", identifier);
    int a = [identifier intValue];
    [radialMenu didTapCenterView:nil];
    DLog(@"%@",self.items);
    NSString *s =[NSString stringWithFormat:@"%@ViewController",[self.items[a] valueForKey:@"control"]];
    UIViewController *con = [[NSClassFromString(s) alloc]init];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
//    animation.type = kCATransitionReveal;
//    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:con animated:NO completion:^{
    }];
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",[self.items[a] valueForKey:@"title"]]];
    
    //    常见变换类型（type）
    //    kCATransitionFade//淡出
    //    kCATransitionMoveIn//覆盖原图
    //    kCATransitionPush  //推出
    //    kCATransitionReveal//底部显出来
    //SubType:
    //    kCATransitionFromRight
    //    kCATransitionFromLeft// 默认值
    //    kCATransitionFromTop
    //    kCATransitionFromBottom
    //(type):
    //    pageCurl   向上翻一页
    //    pageUnCurl 向下翻一页
    //    rippleEffect 滴水效果
    //    suckEffect 收缩效果
    //    cube 立方体效果
    //    oglFlip 上下翻转效果
}
#pragma mark 推出故事板
-(void)showStoryboardWithStoryboardName:(NSString*)story andViewIdentifier:(NSString*)identifier{
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:story bundle:nil];
    [self showViewController:[StoryBoard instantiateViewControllerWithIdentifier:identifier] sender:self];
}
-(void)presentStoryboardWithStoryboardName:(NSString*)story andViewIdentifier:(NSString*)identifier{
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:story bundle:nil];
    UIViewController *dvc = [StoryBoard instantiateViewControllerWithIdentifier:identifier];
    dvc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:dvc animated:YES completion:NULL];
}
-(void)showRadialMenu{
    [self readData];
    self.radialView = [[CKRadialMenu alloc] initWithFrame:CGRectMake(10, kScreenHeight-100, 50, 50)];
    for(int i = 0;i<self.items.count;i++){
        UIImageView *a = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        a.image = [UIImage imageNamed:[self.items[i] valueForKey:@"icon"]];
        [self.radialView addPopoutView:a withIndentifier:[NSString stringWithFormat:@"%d",i]];
    }
    [self.radialView enableDevelopmentMode];
    self.radialView.delegate = self;
    [self.view addSubview: self.radialView];
}
@end
