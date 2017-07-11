//  ViewController.m
//  AWCollectionViewDialLayoutDemo
#import "FirstViewController.h"
#import "XCollectionViewDialLayout.h"
#import "ElasticTransition.h"
#import "SettingsViewController.h"
#import "LibraryCollectionViewController.h"
#import "UIColor+expanded.h"
#import "AppDelegate.h"
#import "TotalData.h"
@interface CollectionViewCell1 : UICollectionViewCell{
    UIView *view;
    UIImageView *imageView;
    UILabel *nameLabel;
    NSMutableDictionary *thumbnailCache;
}
-(void)setDataWithDic:(NSDictionary*)dic andColor:(UIColor *)color;
@end
@implementation CollectionViewCell1
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, (H(self)-80)*0.5, 80, 80)];
        view.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithFrame:view.frame];
        imageView.layer.borderWidth = 2;
        imageView.layer.cornerRadius = 40;
        [view addSubview:imageView];
        [self.contentView addSubview:view];
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(XW(imageView),(H(self)-20)*0.5,200,20)];
        [self.contentView addSubview:nameLabel];
    }return self;
}
-(void)setDataWithDic:(NSDictionary*)dic andColor:(UIColor *)color{
    imageView.layer.borderColor = [color CGColor];
     nameLabel.text = [dic valueForKey:@"title"];
    NSString *imgURL = [dic valueForKey:@"icon"];
    [imageView setImage:nil];
    __block UIImage *imageProduct = [thumbnailCache objectForKey:imgURL];
    if(imageProduct){
        imageView.image = imageProduct;
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageNamed:imgURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [thumbnailCache setValue:image forKey:imgURL];
            });
        });
    }
    imageView.clipsToBounds = YES;
}
@end
@interface CollectionViewCell2:UICollectionViewCell{
    UILabel *nameLabel;
}
-(void)setDataWithDic:(NSDictionary*)dic andColor:(UIColor *)color;
@end
@implementation CollectionViewCell2
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80,0,200,40)];
        [self.contentView addSubview:nameLabel];
        nameLabel.font = Font(28);
    }return self;
}
-(void)setDataWithDic:(NSDictionary *)dic andColor:(UIColor *)color{
    nameLabel.text = [dic valueForKey:@"title"];
    nameLabel.textColor = color;
}
@end
#pragma mark ViewController
@interface FirstViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate>{
    __weak IBOutlet UICollectionView *collectionView;
    __weak IBOutlet UIBarButtonItem *editBtn;
    ElasticTransition *transition;
    UIScreenEdgePanGestureRecognizer *LibraryGR;
    UIScreenEdgePanGestureRecognizer *SettingsGR;
    
    UISearchBar *searchBar;
    NSArray *items;
    BOOL showingSettings;
    UIView *settingsView;
    UILabel *radiusLabel;
    UISlider *radiusSlider;
    UILabel *angularSpacingLabel;
    UISlider *angularSpacingSlider;
    UILabel *xOffsetLabel;
    UISlider *xOffsetSlider;
    UISwitch *exampleSwitch;
    XCollectionViewDialLayout *dialLayout;
}
@end
static NSString *cellId1 = @"cellId1";
static NSString *cellId2 = @"cellId2";

@implementation FirstViewController
@synthesize managedObjectContext = __managedObjectContext;
- (void)viewDidLoad{
    [super viewDidLoad];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth-110, 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    [self.view addSubview:searchBar];
    // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    transition = [[ElasticTransition alloc] init];
    transition.sticky           = YES;
    transition.showShadow       = YES;
    transition.panThreshold     = 0.55;
    transition.radiusFactor     = 0.3;
    transition.transformType    = ROTATE;
    transition.overlayColor     = [UIColor colorWithWhite:0 alpha:0.5];
    transition.shadowColor      = [UIColor colorWithWhite:0 alpha:0.5];
    // gesture recognizers
    SettingsGR = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [SettingsGR addTarget:self action:@selector(gotoSettings:)];
    SettingsGR.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:SettingsGR];
    
    LibraryGR = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [LibraryGR addTarget:self action:@selector(gotoLibrary:)];
    LibraryGR.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:LibraryGR];
    showingSettings = NO;
    [self buildSettings];
    [editBtn setTarget:self];
    [editBtn setAction:@selector(showSettingsView:)];
    [collectionView registerClass:[CollectionViewCell1 class] forCellWithReuseIdentifier:cellId1];
    [collectionView registerClass:[CollectionViewCell2 class] forCellWithReuseIdentifier:cellId2];
      [self readData];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
  
}
- (void)readData {
    AppDelegate *del = [UIApplication sharedApplication].delegate;
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
            AppDelegate *del = [UIApplication sharedApplication].delegate;
            NSEntityDescription *description = [NSEntityDescription entityForName:@"TotalData" inManagedObjectContext:del.managedObjectContext];
            for (NSString *line in lineArr) {
                NSArray *icons = [line componentsSeparatedByString:@"\t"];
                /*items[0],items[1], items[2], items[3], items[4], items[5]*/
                TotalData *icon = [[TotalData alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
                icon.title = icons[0];
                icon.icon = icons[1];
            }
            [del saveContext];
            //从数据库中读
            NSError *error = nil;
            NSArray *b = [del.managedObjectContext executeFetchRequest:request error:&error];
            if (error) {
                DLog(@"%@", error);
            } else {
                items = [NSArray arrayWithArray:b];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [collectionView reloadData];
                });
            }
        });
    } else {
         items = [NSArray arrayWithArray:a];
//        [collectionView reloadData];
    }
//     删除所有数据
//            for (TotalData *postcode in a) {
//                [del.managedObjectContext deleteObject:postcode];
//            }
//            [del saveContext];
}

#pragma mark 设置与收藏的跳转
-(void)gotoSettings:(UIPanGestureRecognizer*)pan{
    if (pan.state == UIGestureRecognizerStateBegan){
        transition.edge = LEFT;
        [transition startInteractiveTransitionFromViewController:self SegueIdentifier:@"settings" GestureRecognizer:pan];
    }else{
        [transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}

-(void)gotoLibrary:(UIPanGestureRecognizer*)pan{
    if (pan.state == UIGestureRecognizerStateBegan){
        transition.edge = RIGHT;
        [transition startInteractiveTransitionFromViewController:self SegueIdentifier:@"library" GestureRecognizer:pan];
    }else{
        [transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *vc = segue.destinationViewController;
    vc.transitioningDelegate = transition;
    vc.modalPresentationStyle = UIModalPresentationCustom;
}
#pragma mark 界面样式设置
-(void)buildSettings{
    settingsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+100, self.view.frame.size.width, self.view.frame.size.height-44)];
    [settingsView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    exampleSwitch =  [[UISwitch alloc]initWithFrame:CGRectMake(30, 30, 200, 20)];
    [exampleSwitch addTarget:self action:@selector(switchExample) forControlEvents:UIControlEventValueChanged];
    
    radiusLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, YH(exampleSwitch)+20, kScreenWidth-60, 20)];
    radiusSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, YH(radiusLabel)+10, W(settingsView)-60, 20)];
    [radiusSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    angularSpacingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, YH(radiusSlider)+20, 100, 20)];
    angularSpacingSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, YH(angularSpacingLabel)+10, W(settingsView)-60, 20)];
    [angularSpacingSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    xOffsetLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, YH(angularSpacingSlider)+20, 100, 20)];
    xOffsetSlider =  [[UISlider alloc]initWithFrame:CGRectMake(30, YH(xOffsetLabel)+10, W(settingsView)-60, 20)];;
    [xOffsetSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    [settingsView addSubviews:exampleSwitch,radiusLabel,radiusSlider,angularSpacingLabel,angularSpacingSlider,xOffsetLabel,xOffsetSlider,nil];
    [self.view addSubview:settingsView];
    [self switchExample];
    dialLayout = [[XCollectionViewDialLayout alloc] initWithRadius:radiusSlider.value * 1000 andAngularSpacing:angularSpacingSlider.value * 90 andCellSize:CGSizeMake(240, 100) andAlignment:WHEELALIGNMENTCENTER andItemHeight:100 andXOffset:xOffsetSlider.value * 320];
    [collectionView setCollectionViewLayout:dialLayout];
}

-(void)switchExample{
    radiusSlider.value = 0.3;
    angularSpacingSlider.value = 0.2;
    xOffsetSlider.value = 0.6;
    if(exampleSwitch.on){
        [dialLayout setCellSize:CGSizeMake(240, 100)];
        [dialLayout setWheelType:WHEELALIGNMENTLEFT];
    }else{
        [dialLayout setCellSize:CGSizeMake(260, 50)];
        [dialLayout setWheelType:WHEELALIGNMENTCENTER];
    }
    [self updateDialSettings];
    [collectionView reloadData];
}
-(void)updateDialSettings{
    CGFloat radius = radiusSlider.value * 1000;
    CGFloat angularSpacing = angularSpacingSlider.value * 90;
    CGFloat xOffset = xOffsetSlider.value * 320;
    [radiusLabel setText:[NSString stringWithFormat:@"弧度: %i", (int)radius]];
    [dialLayout setDialRadius:radius];
    [angularSpacingLabel setText:[NSString stringWithFormat:@"间距: %i", (int)angularSpacing]];
    [dialLayout setAngularSpacing:angularSpacing];
    [xOffsetLabel setText:[NSString stringWithFormat:@"偏移量: %i", (int)xOffset]];
    [dialLayout setXOffset:xOffset];
    [dialLayout invalidateLayout];
}
-(void)showSettingsView:(id)sender{
    CGRect frame = settingsView.frame;
    if(showingSettings){
        editBtn.title = @"编辑";
        frame.origin.y = self.view.frame.size.height+100;
    }else{
        editBtn.title = @"关闭";
        frame.origin.y = 44;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        transition.edge = BOTTOM;
        transition.startingPoint = CGPointMake(settingsView.frame.origin.x+settingsView.frame.size.width/2.0, settingsView.frame.origin.y);
        //[self performSegueWithIdentifier:@"navigation" sender:self];
        settingsView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    showingSettings = !showingSettings;
}

#pragma mark - UICollectionViewDelegate methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString* name = [items[indexPath.row] valueForKey:@"title"];
    [SVProgressHUD showSuccessWithStatus:name];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return items.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [items objectAtIndex:indexPath.item];
    UIColor *color =[UIColor randomColor];
    if(exampleSwitch.on){
        CollectionViewCell1 *cell = [cv dequeueReusableCellWithReuseIdentifier:cellId1 forIndexPath:indexPath];
        [cell setDataWithDic:dic andColor:color];
        return cell;
    }else{
        CollectionViewCell2 *cell = [cv dequeueReusableCellWithReuseIdentifier:cellId2 forIndexPath:indexPath];
        [cell setDataWithDic:dic andColor:color];
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"didEndDisplayingCell:%i", (int)indexPath.item);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(240, 100);
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}
#pragma mark others
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText.length) {
        [self readData];
        return;
    }
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TotalData"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"icon" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"title CONTAINS %@ OR icon CONTAINS[c] %@ OR icon MATCHES %@", searchText, searchText,@"[F-j]+"];
    NSError *error = nil;
    NSArray *b = [del.managedObjectContext executeFetchRequest:request error:&error];
    items = [[NSMutableArray alloc] initWithArray:b];
    [collectionView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBa{
    [searchBar resignFirstResponder];
}
#pragma mark - 键盘显示/隐藏
//  键盘显示
- (void)keyBoardWillShow:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        _tableView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
    }completion:^(BOOL finished) {
    }];
}
// 键盘隐藏
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        _tableView.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-20);
    }];
}

@end
