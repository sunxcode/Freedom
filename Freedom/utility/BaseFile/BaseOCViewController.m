
#import "BaseOCViewController.h"
#include <objc/runtime.h>
#import <SVProgressHUD/SVProgressHUD.h>
@implementation BaseTableViewOCCell
#pragma mark 初始化
///单例初始化，兼容nib创建
+(id) getInstance {
    BaseTableViewOCCell *instance = nil;
    @try {
        NSString *nibFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.nib",NSStringFromClass(self)]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:nibFilePath]) {
            id o = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
            if ([o isKindOfClass:self]) {
                instance = o;
            } else {
                instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
            }
        } else {
            instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
        }
    }
    @catch (NSException *exception) {
        instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
    }
    return instance;
}
+(NSString*) getTableCellIdentifier {
    return [[NSString alloc] initWithFormat:@"%@Identifier",NSStringFromClass(self)];
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)init {
    self = [super init];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(void)loadBaseTableCellSubviews{
    [self initUI];
    [self setUserInteractionEnabled:YES];
    [self.contentView setUserInteractionEnabled:YES];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)initUI{
    self.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    self.icon =[[UIImageView alloc]init];
    self.icon.contentMode = UIViewContentModeScaleToFill;
    self.title = [[UILabel alloc]init];
    self.title.font = [UIFont systemFontOfSize:15];
    self.title.numberOfLines = 0;
    self.script = [[UILabel alloc]init];
    self.script.font = [UIFont systemFontOfSize:13];
    self.script.textColor = self.title.textColor = [UIColor colorWithRed:33 green:34 blue:35 alpha:1];
    self.line = [[UIView alloc]init];
    //    [self addSubviews:self.icon,self.title,self.script,self.line,nil];
    NSLog(@"请子类重写这个方法");
}
-(void)setDataWithDict:(NSDictionary *)dict{
    NSLog(@"请子类重写这个方法");
}
@end

@implementation BaseCollectionViewOCCell
#pragma mark 初始化
+(NSString*) getTableCellIdentifier {
    return [[NSString alloc] initWithFormat:@"%@Identifier",NSStringFromClass(self)];
}
///单例初始化
-(id)init {
    self = [super init];
    if (self) {
        [self initUI];
    }return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }return self;
}
-(void)initUI{
    self.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    self.icon =[[UIImageView alloc]init];
    self.icon.contentMode = UIViewContentModeScaleToFill;
    self.title = [[UILabel alloc]init];
    self.title.font = [UIFont systemFontOfSize:15];
    self.title.numberOfLines = 0;
    self.script = [[UILabel alloc]init];
    self.script.font = [UIFont systemFontOfSize:13];
    self.script.textColor = self.title.textColor = [UIColor colorWithRed:33 green:34 blue:35 alpha:1];
    self.line = [[UIView alloc]init];
    //    [self addSubviews:self.icon,self.title,self.script,self.line,nil];
    NSLog(@"请子类重写这个方法");
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    NSLog(@"请子类重写这个方法");
}
@end

@interface BaseOCViewController ()
#pragma mark UItableViewDelegagte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
///子类重写
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
//子类重写
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath;
@end
@implementation BaseOCViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0,APPW, TopHeight)];
    [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:@"u_cellLeft"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"u_cellLeft"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor blackColor],[UIFont boldSystemFontOfSize:18.0f], nil] forKeys:[NSArray arrayWithObjects: NSForegroundColorAttributeName,NSFontAttributeName, nil]];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setClipsToBounds:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
}
#pragma mark - Methods
- (BaseOCViewController*)pushController:(Class)controller withInfo:(id)info{
    return [self pushController:controller withInfo:info withTitle:nil withOther:nil];
}
- (BaseOCViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other{
    DLog(@"\n跳转到 %@ 类",NSStringFromClass(controller));
    return [self pushController:[[controller alloc]init] withInfo:info withTitle:title withOther:other tabBarHid:YES];
}
- (BaseOCViewController*)pushController:(BaseOCViewController*)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBarHid:(BOOL)abool{
    DLog(@"\n跳转到 %@ 页面\nBase UserInfo:%@\nBase OtherInfo:%@",title,info,other);
    if ([(NSObject*)controller respondsToSelector:@selector(setUserInfo:)]) {
        controller.userInfo = info;
        controller.otherInfo = other;
    }
    controller.title = title;
    controller.hidesBottomBarWhenPushed=abool;
    [self.navigationController pushViewController:controller animated:YES];
    return controller;
}
#pragma mark UItableViewDelegagte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellName = @"cd";
    BaseTableViewOCCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSClassFromString(cellName) getTableCellIdentifier]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableView.tableHeaderView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.tableView.tableFooterView;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
#pragma mark  子类重写
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"请子类重写这个方法");
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    DLog(@"请子类重写这个方法");return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    DLog(@"请子类重写这个方法");return nil;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    // 2 添加一个置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        DLog(@"点击了置顶");
        [self.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    topRowAction.backgroundColor = [UIColor grayColor];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction,topRowAction];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [self.dataArray addObject:self.dataArray[indexPath.row]];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    DLog(@"请子类重写这个方法");
    [self.dataArray removeObjectAtIndex:sourceIndexPath.row];
    [self.dataArray insertObject:self.dataArray[sourceIndexPath.row] atIndex:destinationIndexPath.row];
}
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BaseCollectionViewOCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"" forIndexPath:indexPath];
    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
//子类重写
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"请子类重写这个方法");
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    DLog(@"请子类重写这个方法");
}
-(NSArray *)items{
    if(!_items){
        _items = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"FreedomItems" ofType:@"plist"]];
    }
    return _items;
}
-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier{
    DLog(@"代理通知发现点击了控制器%@", identifier);
    int a = [identifier intValue];
    [radialMenu didTapCenterView:nil];
    NSString *controlName = [self.items[a] valueForKey:@"control"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if([controlName isEqualToString:@"Sina"]){
        NSString *s =[NSString stringWithFormat:@"%@TabBarController",controlName];
        UIViewController *con = [[NSClassFromString(s) alloc]init];
        CATransition *animation = [CATransition animation];
        animation.duration = 1;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:con animated:NO completion:^{
        }];
        return;
    }
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:controlName bundle:nil];
    UIViewController *con = [StoryBoard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@TabBarController",controlName]];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    //    animation.type = kCATransitionReveal;
    //    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    //    [self presentViewController:con animated:NO completion:^{}];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    win.rootViewController = con;
    [win makeKeyAndVisible];
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

-(void)showRadialMenu{
    if(!self.radialView){
        self.radialView = [[CKRadialMenu alloc] initWithFrame:CGRectMake(APPW/2-25, APPH/2-25, 50, 50)];
        for(int i = 0;i<self.items.count;i++){
            UIImageView *a = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            a.image = [UIImage imageNamed:[self.items[i] valueForKey:@"icon"]];
            [self.radialView addPopoutView:a withIndentifier:[NSString stringWithFormat:@"%d",i]];
        }
        [self.radialView enableDevelopmentMode];
        self.radialView.distanceBetweenPopouts = 2*180/self.items.count;
        self.radialView.delegate = self;
        [self.view addSubview:self.radialView];
        self.radialView.center = self.view.center;
        UIWindow *win = [[UIApplication sharedApplication]keyWindow];
        [win addSubview:self.radialView];
        [win bringSubviewToFront:self.radialView];
    }else{
        [self.radialView removeFromSuperview];
        self.radialView = nil;
    }
    
}
#pragma mark 摇一摇
/** 开始摇一摇 */
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    [self showRadialMenu];
}
/** 摇一摇结束 */
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion != UIEventSubtypeMotionShake)return;
    DLog(@"结束摇一摇");
}
/** 摇一摇取消(被中断 比如突然来了电话 )*/
- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    DLog(@"取消摇一摇");
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
