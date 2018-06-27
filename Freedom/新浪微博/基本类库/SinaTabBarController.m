//  XFTabBarViewController.m
//  Freedom
//  Created by Super on 15/9/13.
#import "SinaTabBarController.h"
#import "SinaHomeViewController.h"
#import "SinaMessageViewController.h"
#import "SinaMeViewController.h"
#import "SinaDiscoverViewController.h"
#import "SinaNavigationController.h"
#import "SinaComposeViewController.h"
#import "SinaAuthController.h"
#import "SinaBaseViewController.h"
#import <objc/runtime.h>
#import <Availability.h>
#import <QuartzCore/QuartzCore.h>
#import <XCategory/UIImage+expanded.h>
#import <Accelerate/Accelerate.h>
@interface FXBlurView : UIView
@property (nonatomic, getter = isBlurEnabled) BOOL blurEnabled;
@property (nonatomic, getter = isDynamic) BOOL dynamic;
@property (nonatomic, assign) NSUInteger iterations;
@property (nonatomic, assign) NSTimeInterval updateInterval;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIView *underlyingView;
- (void)updateAsynchronously:(BOOL)async completion:(void (^)())completion;
- (void)clearImage;
@end
@interface FXBlurScheduler : NSObject
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, assign) NSUInteger viewIndex;
@property (nonatomic, assign) NSUInteger updatesEnabled;
@property (nonatomic, assign) BOOL blurEnabled;
@property (nonatomic, assign) BOOL updating;
@end
@interface FXBlurView ()
@property (nonatomic, assign) BOOL iterationsSet;
@property (nonatomic, assign) BOOL blurRadiusSet;
@property (nonatomic, assign) BOOL dynamicSet;
@property (nonatomic, assign) BOOL blurEnabledSet;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic, assign) BOOL needsDrawViewHierarchy;
- (UIImage *)snapshotOfUnderlyingView;
- (BOOL)shouldUpdate;
@end
@implementation FXBlurScheduler
+ (instancetype)sharedInstance{
    static FXBlurScheduler *sharedInstance = nil;
    if (!sharedInstance){
        sharedInstance = [[FXBlurScheduler alloc] init];
    }
    return sharedInstance;
}
- (instancetype)init{
    if ((self = [super init])){
        _updatesEnabled = 1;
        _blurEnabled = YES;
        _views = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)setBlurEnabled:(BOOL)blurEnabled{
    _blurEnabled = blurEnabled;
    if (blurEnabled){
        for (FXBlurView *view in self.views){
            [view setNeedsDisplay];
        }
        [self updateAsynchronously];
    }
}
- (void)setUpdatesEnabled{
    _updatesEnabled ++;
    [self updateAsynchronously];
}
- (void)setUpdatesDisabled{
    _updatesEnabled --;
}
- (void)addView:(FXBlurView *)view{
    if (![self.views containsObject:view]){
        [self.views addObject:view];
        [self updateAsynchronously];
    }
}
- (void)removeView:(FXBlurView *)view{
    NSUInteger index = [self.views indexOfObject:view];
    if (index != NSNotFound){
        if (index <= self.viewIndex){
            self.viewIndex --;
        }
        [self.views removeObjectAtIndex:index];
    }
}
- (void)updateAsynchronously{
    if (self.blurEnabled && !self.updating && self.updatesEnabled > 0 && [self.views count]){
        NSTimeInterval timeUntilNextUpdate = 1.0 / 60;
        //loop through until we find a view that's ready to be drawn
        self.viewIndex = self.viewIndex % [self.views count];
        for (NSUInteger i = self.viewIndex; i < [self.views count]; i++){
            FXBlurView *view = self.views[i];
            if (view.dynamic && !view.hidden && view.window && [view shouldUpdate]){
                NSTimeInterval nextUpdate = [view.lastUpdate timeIntervalSinceNow] + view.updateInterval;
                if (!view.lastUpdate || nextUpdate <= 0){
                    self.updating = YES;
                    [view updateAsynchronously:YES completion:^{
                        //render next view
                        self.updating = NO;
                        self.viewIndex = i + 1;
                        [self updateAsynchronously];
                    }];
                    return;
                }else{
                    timeUntilNextUpdate = MIN(timeUntilNextUpdate, nextUpdate);
                }
            }
        }
        self.viewIndex = 0;
        [self performSelector:@selector(updateAsynchronously)
                   withObject:nil
                   afterDelay:timeUntilNextUpdate
                      inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
    }
}
@end
@implementation FXBlurView
- (void)setUp{
    if (!_iterationsSet) _iterations = 3;
    if (!_blurRadiusSet);
    if (!_dynamicSet) _dynamic = YES;
    if (!_blurEnabledSet) _blurEnabled = YES;
    self.updateInterval = _updateInterval;
    self.layer.magnificationFilter = @"linear"; // kCAFilterLinear
    unsigned int numberOfMethods;
    Method *methods = class_copyMethodList([UIView class], &numberOfMethods);
    for (unsigned int i = 0; i < numberOfMethods; i++){
        Method method = methods[i];
        SEL selector = method_getName(method);
        if (selector == @selector(tintColor)){
            _tintColor = ((id (*)(id,SEL))method_getImplementation(method))(self, selector);
            break;
        }
    }
    free(methods);
}
- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])){
        [self setUp];
        self.clipsToBounds = YES;
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [self setUp];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)viewOrSubviewNeedsDrawViewHierarchy:(UIView *)view{
    if ([view isKindOfClass:NSClassFromString(@"SKView")] ||
        [view.layer isKindOfClass:NSClassFromString(@"CAEAGLLayer")] ||
        [view.layer isKindOfClass:NSClassFromString(@"AVPlayerLayer")] ||
        ABS(view.layer.transform.m34) > 0){
        return YES;
    }
    for (UIView *subview in view.subviews){
        if ([self viewOrSubviewNeedsDrawViewHierarchy:subview]){
            return YES;
        }
    }
    return  NO;
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    _needsDrawViewHierarchy = [self viewOrSubviewNeedsDrawViewHierarchy:newSuperview];
}
- (void)setIterations:(NSUInteger)iterations{
    _iterationsSet = YES;
    _iterations = iterations;
    [self setNeedsDisplay];
}
- (void)setBlurRadius:(CGFloat)blurRadius{
    _blurRadiusSet = YES;
}
- (void)setBlurEnabled:(BOOL)blurEnabled{
    _blurEnabledSet = YES;
    if (_blurEnabled != blurEnabled){
        _blurEnabled = blurEnabled;
        [self schedule];
        if (_blurEnabled){
            [self setNeedsDisplay];
        }
    }
}
- (void)setDynamic:(BOOL)dynamic{
    _dynamicSet = YES;
    if (_dynamic != dynamic){
        _dynamic = dynamic;
        [self schedule];
        if (!dynamic){
            [self setNeedsDisplay];
        }
    }
}
- (UIView *)underlyingView{
    return self.superview;
}
- (void)setUnderlyingView:(UIView *)underlyingView{
    _needsDrawViewHierarchy = [self viewOrSubviewNeedsDrawViewHierarchy:self.underlyingView];
    [self setNeedsDisplay];
}
- (CALayer *)underlyingLayer{
    return self.underlyingView.layer;
}
- (void)setUpdateInterval:(NSTimeInterval)updateInterval{
    _updateInterval = updateInterval;
    if (_updateInterval <= 0) _updateInterval = 1.0/60;
}
- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    [self setNeedsDisplay];
}
- (void)clearImage {
    self.layer.contents = nil;
    [self setNeedsDisplay];
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self.layer setNeedsDisplay];
}
- (void)didMoveToWindow{
    [super didMoveToWindow];
    [self schedule];
}
- (void)schedule{
    if (self.window && self.dynamic && self.blurEnabled){
        [[FXBlurScheduler sharedInstance] addView:self];
    }else{
        [[FXBlurScheduler sharedInstance] removeView:self];
    }
}
- (void)setNeedsDisplay{
    [super setNeedsDisplay];
    [self.layer setNeedsDisplay];
}
- (BOOL)shouldUpdate{
    __strong CALayer *underlyingLayer = [self underlyingLayer];
    return
    underlyingLayer && !underlyingLayer.hidden &&
    self.blurEnabled && [FXBlurScheduler sharedInstance].blurEnabled &&
    !CGRectIsEmpty([self.layer.presentationLayer ?: self.layer bounds]) && !CGRectIsEmpty(underlyingLayer.bounds);
}
- (void)displayLayer:(__unused CALayer *)layer{
    [self updateAsynchronously:NO completion:NULL];
}
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key{
    if ([key isEqualToString:@"blurRadius"]){
        //animations are enabled
        CAAnimation *action = (CAAnimation *)[super actionForLayer:layer forKey:@"backgroundColor"];
        if ((NSNull *)action != [NSNull null]){
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
            animation.fromValue = [layer.presentationLayer valueForKey:key];
            //CAMediatiming attributes
            animation.beginTime = action.beginTime;
            animation.duration = action.duration;
            animation.speed = action.speed;
            animation.timeOffset = action.timeOffset;
            animation.repeatCount = action.repeatCount;
            animation.repeatDuration = action.repeatDuration;
            animation.autoreverses = action.autoreverses;
            animation.fillMode = action.fillMode;
            //CAAnimation attributes
            animation.timingFunction = action.timingFunction;
            animation.delegate = action.delegate;
            return animation;
        }
    }
    return [super actionForLayer:layer forKey:key];
}
- (UIImage *)snapshotOfUnderlyingView{
    __strong CALayer *underlyingLayer = [self underlyingLayer];
    CGRect bounds = CGRectMake(0, 0, 100, 30);
    self.lastUpdate = [NSDate date];
    CGFloat scale = 0.5;
    if (self.iterations){
        CGFloat blockSize = 12.0/self.iterations;
        scale = 1.0/floor(1.0/scale);
    }
    CGSize size = bounds.size;
    if (self.contentMode == UIViewContentModeScaleToFill ||
        self.contentMode == UIViewContentModeScaleAspectFill ||
        self.contentMode == UIViewContentModeScaleAspectFit ||
        self.contentMode == UIViewContentModeRedraw){
        //prevents edge artefacts
        size.width = floor(size.width * scale) / scale;
        size.height = floor(size.height * scale) / scale;
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0 && [UIScreen mainScreen].scale == 1.0){
        //prevents pixelation on old devices
        scale = 1.0;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context){
        CGContextTranslateCTM(context, -bounds.origin.x, -bounds.origin.y);
        NSArray *hiddenViews = [self prepareUnderlyingViewForSnapshot];
        if (self.needsDrawViewHierarchy){
            __strong UIView *underlyingView = self.underlyingView;
            [underlyingView drawViewHierarchyInRect:underlyingView.bounds afterScreenUpdates:YES];
        }
        else
        {
            [underlyingLayer renderInContext:context];
        }
        [self restoreSuperviewAfterSnapshot:hiddenViews];
        UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snapshot;
    }
    return nil;
}
- (NSArray *)hideEmptyLayers:(CALayer *)layer{
    NSMutableArray *layers = [NSMutableArray array];
    if (CGRectIsEmpty(layer.bounds)){
        layer.hidden = YES;
        [layers addObject:layer];
    }
    for (CALayer *sublayer in layer.sublayers){
        [layers addObjectsFromArray:[self hideEmptyLayers:sublayer]];
    }
    return layers;
}
- (NSArray *)prepareUnderlyingViewForSnapshot{
    __strong CALayer *underlyingLayer = [self underlyingLayer];
    NSMutableArray *layers = [NSMutableArray array];
    if (index != NSNotFound){
        for (NSUInteger i = index; i < [underlyingLayer.sublayers count]; i++){
            CALayer *layer = underlyingLayer.sublayers[i];
            if (!layer.hidden){
                layer.hidden = YES;
                [layers addObject:layer];
            }
        }
    }
    //also hide any sublayers with empty bounds to prevent a crash on iOS 8
    [layers addObjectsFromArray:[self hideEmptyLayers:underlyingLayer]];
    return layers;
}
- (void)restoreSuperviewAfterSnapshot:(NSArray *)hiddenLayers{
    for (CALayer *layer in hiddenLayers){
        layer.hidden = NO;
    }
}
- (void)setLayerContents:(UIImage *)image{
    self.layer.contents = (id)image.CGImage;
    self.layer.contentsScale = image.scale;
}
- (void)updateAsynchronously:(BOOL)async completion:(void (^)())completion{
    if ([self shouldUpdate]){
        UIImage *snapshot = [self snapshotOfUnderlyingView];
        if (async){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *blurredImage = snapshot;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self setLayerContents:blurredImage];
                    if (completion) completion();
                });
            });
        }else{
            [self setLayerContents:snapshot];
            if (completion) completion();
        }
    }else if (completion){
        completion();
    }
}
@end
@interface SinaNewFeatureController : SinaBaseViewController
@end
@interface SinaNewFeatureController ()<UIScrollViewDelegate>
@property(nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic,weak) UIButton *shareBtn;
@end
@implementation SinaNewFeatureController
- (void)viewDidLoad {
    [super viewDidLoad];
    int KCount = 4;
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.frame = self.view.bounds;
    CGFloat scrollW = scrollView.frame.size.width;
    CGFloat scrollH = scrollView.frameHeight;
    scrollView.contentSize = CGSizeMake(scrollW * KCount, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    for (int i = 0; i < KCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * scrollW, 0, scrollW, scrollH)];
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d@2x",i+1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        if (i == KCount -1) {
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareBtn setImage:[UIImage imageNamed:@"u_gou_gray"] forState:UIControlStateNormal];
            [shareBtn setImage:[UIImage imageNamed:@"u_gou_g"] forState:UIControlStateSelected];
            [shareBtn setTitle:@"分享至微博" forState:UIControlStateNormal];
            [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
            shareBtn.center = CGPointMake(imageView.frame.size.width *0.24,imageView.frameHeight * 0.70);
            shareBtn.frameSize = CGSizeMake(200, 30);
            [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
            self.shareBtn = shareBtn;
            [imageView addSubview:shareBtn];
            UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [startBtn setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
            [startBtn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(235, 108, 1)] forState:UIControlStateHighlighted];
            [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
            [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            startBtn.frame = CGRectMake(APPW/4, APPH * 0.80, APPW/2, 40);
            [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:startBtn];
        }
    }
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = KCount;
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.center =CGPointMake(scrollW * 0.5, scrollH - 40) ;
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
}
//开始按钮
-(void)startClick {
    [self presentViewController:[[SinaTabBarController alloc]init] animated:YES completion:^{
    }];
}
//分享按钮
-(void)shareClick {
    self.shareBtn.selected = !self.shareBtn.isSelected;
}
//监听pageControl
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = (int)(page + 0.5);
}
@end

@class SinaTabBar;
@protocol XFTabBarDelegate <UITabBarDelegate>
@optional
- (void)tabBarDidClickPlusButton:(SinaTabBar *)tabBar;
@end
@interface SinaTabBar : UITabBar
@property(nonatomic,weak)id <XFTabBarDelegate> delegate;
@end
@interface SinaTabBar ()
@property (nonatomic, weak) UIButton *plusBtn;
@end
@implementation SinaTabBar
@dynamic delegate;
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个按钮到tabbar中
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.frameSize = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
        
    }
    return self;
    
}
-(void)plusClick {
    //通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
    
}
-(void)layoutSubviews {
    [super layoutSubviews];
    //设置加号的位置
    self.plusBtn.center = CGPointMake(APPW *0.5, 50 * 0.5);
    //设置其他tabbarButton的位置和尺寸
    CGFloat tabBarButtonW  = APPW / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.frame = CGRectMake(tabbarButtonIndex *tabBarButtonW, 0, tabBarButtonW, child.frameHeight);
            //增加索引
            tabbarButtonIndex ++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex ++;
            }
        }
    }
}
@end
@interface SinaTabBarController ()<XFTabBarDelegate>
@property (nonatomic,weak)UIButton *plus;
@property (nonatomic,weak)FXBlurView *blurView;
@property (nonatomic,weak)UIImageView *text;
@property (nonatomic,weak)UIImageView *ablum;
@property (nonatomic,weak)UIImageView *camera;
@property (nonatomic,weak)UIImageView *sign;
@property (nonatomic,weak)UIImageView *comment;
@property (nonatomic,weak)UIImageView *more;
@end
@implementation SinaTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置子控制器
    SinaHomeViewController *home = [[SinaHomeViewController alloc]init];
    [self addChildViewController:home title:@"首页" image:@"tabbar_home" selImage:@"tabbar_home_selected"];
    SinaMessageViewController *messageCenter = [[SinaMessageViewController alloc] init];
    [self addChildViewController:messageCenter title:@"消息" image:@"tabbar_message_center" selImage:@"tabbar_message_center_selected"];
    SinaDiscoverViewController *discover = [[SinaDiscoverViewController alloc] init];
    [self addChildViewController:discover title:@"发现" image:@"tabbar_discoverS" selImage:@"tabbar_discover_selectedS"];
    SinaMeViewController *profile = [[SinaMeViewController alloc] init];
    [self addChildViewController:profile title:@"我" image:@"tabbar_profile" selImage:@"tabbar_profile_selected"];
    //更换系统自带的tabbar
    SinaTabBar *tab = [[SinaTabBar alloc]init];
    tab.delegate = self;
    [self setValue:tab forKey:@"tabBar"];
    SinaAccount *account = [SinaAccount account];
    //设置根控制器
    if (account) {//第三方登录状态
        // 切换窗口的根控制器
        NSString *key = @"version";
        // 上一次的使用版本（存储在沙盒中的版本号）
        NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        // 当前软件的版本号（从Info.plist中获得）
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
            return;
        } else { // 这次打开的版本和上一次不一样，显示新特性
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:[[SinaNewFeatureController alloc] init] animated:YES completion:^{
            }];
            // 将当前的版本号存进沙盒
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else{
        NSDictionary *acont = @{@"access_token":@"2.00IjAFKG0H7CVc7e020836340bdlSS",
                                @"expires_in":@"2636676",
                                @"remind_in":@"2636676",
                                @"uid":@"5645754790"};
        account = [SinaAccount accountWithDict:acont];
        //储存账号信息
        [SinaAccount saveAccount:account];
        [self presentViewController:[[SinaAuthController alloc]init] animated:YES completion:^{
        }];
//        [UIApplication sharedApplication].delegate.window.rootViewController = [[XFOAuthController alloc]init];
    }
    
}
//添加子控制器
-(void)addChildViewController:(UIViewController *)childVc  title:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage {
    //设置子控制器的TabBarButton属性
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *AttrDic = [NSMutableDictionary dictionary];
    AttrDic[NSForegroundColorAttributeName] = [UIColor grayColor];
    [childVc.tabBarItem setTitleTextAttributes:AttrDic forState:UIControlStateNormal];
    NSMutableDictionary *selAttr = [NSMutableDictionary dictionary];
    selAttr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:selAttr forState:UIControlStateSelected];
       //让子控制器包装一个导航控制器
    SinaNavigationController *nav = [[SinaNavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
}
-(void)tabBarDidClickPlusButton:(SinaTabBar *)tabBar {
    FXBlurView *blurView = [[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    blurView.tintColor = [UIColor clearColor];
    self.blurView = blurView;
    [self.view addSubview:blurView];
    UIImageView *compose = [[UIImageView alloc]init];
    [compose setImage:[UIImage imageNamed:@"compose_slogan"]];
    compose.frame = CGRectMake(0, 100, self.view.frame.size.width, 48);
    compose.contentMode = UIViewContentModeCenter;
    [blurView addSubview:compose];
    UIView *bottom = [[UIView alloc]init];
    bottom.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.height, 44);
    bottom.backgroundColor = [UIColor whiteColor];
    //bottom.contentMode = UIViewContentModeCenter;
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];

    plus.frame = CGRectMake((self.view.bounds.size.width - 25) * 0.5, 8, 25, 25);
    [plus setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add"] forState:UIControlStateNormal];
    [bottom addSubview:plus];
    [UIView animateWithDuration:0.2 animations:^{
        
        plus.transform = CGAffineTransformMakeRotation(M_PI_4);
        self.plus = plus;
    }];
    [plus addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:bottom];
    UIImageView *text = [self btnAnimateWithFrame:CGRectMake(31, 500, 71, 100) imageName:@"tabbar_compose_idea" text:@"文字" animateFrame:CGRectMake(31, 280, 71, 100) delay:0.0];
    [self setAction:text action:@selector(compose)];
    self.text = text;
    UIImageView *ablum = [self btnAnimateWithFrame:CGRectMake(152, 500, 71, 100) imageName:@"tabbar_compose_photo" text:@"相册" animateFrame:CGRectMake(152, 280, 71, 100) delay:0.1];
    self.ablum = ablum;
    UIImageView *camera = [self btnAnimateWithFrame:CGRectMake(273, 500, 71, 100) imageName:@"tabbar_compose_camera" text:@"摄影" animateFrame:CGRectMake(273, 280, 71, 100) delay:0.15];
    self.camera = camera;
    UIImageView *sign = [self btnAnimateWithFrame:CGRectMake(31, 700, 71, 100) imageName:@"tabbar_compose_lbs" text:@"签到" animateFrame:CGRectMake(31, 410, 71, 100) delay:0.2];
    self.sign = sign;
    UIImageView *comment = [self btnAnimateWithFrame:CGRectMake(152, 700, 71, 100) imageName:@"tabbar_compose_review" text:@"评论" animateFrame:CGRectMake(152, 410, 71, 100) delay:0.25];
    self.comment = comment;
    UIImageView *more = [self btnAnimateWithFrame:CGRectMake(273, 700, 71, 100) imageName:@"tabbar_compose_more" text:@"更多" animateFrame:CGRectMake(273, 410, 71, 100) delay:0.3];
    self.more = more;
}
//按钮出来动画
-(UIImageView *)btnAnimateWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text animateFrame:(CGRect)aniFrame delay:(CGFloat)delay {
    UIImageView *btnContainer = [[UIImageView alloc]init];
    btnContainer.frame  = frame;
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [btnContainer addSubview:image];
    UILabel *word = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 71, 25)];
    [word setText:text];
    [word setTextAlignment:NSTextAlignmentCenter];
    [word setFont:[UIFont systemFontOfSize:15]];
    [word setTextColor:[UIColor grayColor]];
    [btnContainer addSubview:word];
    [self.blurView addSubview:btnContainer];
    [UIView animateWithDuration:0.5 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:0.05 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        btnContainer.frame  = aniFrame;
    } completion:^(BOOL finished) {
    }];
    return btnContainer;
}
//设置按钮方法
-(void)setAction:(UIImageView *)imageView action:(SEL)action{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:gesture];
}
//发文字微博
-(void)compose {
    [self closeClick];
    SinaComposeViewController *compose = [[SinaComposeViewController alloc]init];
    SinaNavigationController *nav = [[SinaNavigationController alloc]initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}
//关闭动画
-(void)btnCloseAnimateWithFrame:(CGRect)rect delay:(CGFloat)delay btnView:(UIImageView *)btnView{
    [UIView animateWithDuration:0.3 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:0.05 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        btnView.frame  = rect;
    } completion:^(BOOL finished) {
    }];
}
//关闭按钮
-(void)closeClick {
    [UIView animateWithDuration:0.6 animations:^{
        self.plus.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self btnCloseAnimateWithFrame:CGRectMake(273, 700, 71, 100) delay:0.1 btnView:self.more];
        [self btnCloseAnimateWithFrame:CGRectMake(152, 700, 71, 100) delay:0.15 btnView:self.comment];
        [self btnCloseAnimateWithFrame:CGRectMake(31, 700, 71, 100) delay:0.2 btnView:self.sign];
        [self btnCloseAnimateWithFrame:CGRectMake(273, 700, 71, 100) delay:0.25 btnView:self.camera];
        [self btnCloseAnimateWithFrame:CGRectMake(152, 700, 71, 100) delay:0.3 btnView:self.ablum];
        [self btnCloseAnimateWithFrame:CGRectMake(31, 700, 71, 100) delay:0.35 btnView:self.text];
    } completion:^(BOOL finished) {
        [self.text removeFromSuperview];
        [self.ablum removeFromSuperview];
        [self.camera removeFromSuperview];
        [self.sign removeFromSuperview];
        [self.comment removeFromSuperview];
        [self.more removeFromSuperview];
        [self.blurView removeFromSuperview];
    }];
}
@end
