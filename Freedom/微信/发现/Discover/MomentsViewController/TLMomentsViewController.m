//
//  TLMomentsViewController.m
//  TLChat
//
//  Created by 李伯坤 on 16/4/5.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLMomentsViewController.h"
#import "TLMoment.h"
#import "TLMomentDetailViewController.h"
#import "MWPhotoBrowser.h"
#import "TLMomentHeaderCell.h"
#import "TLMomentImagesCell.h"
#import "TLMomentsViewController.h"
#import "TLMomentViewDelegate.h"
@interface TLMomentsProxy : NSObject
- (NSArray *)testData;
@end
@implementation TLMomentsProxy

- (NSArray *)testData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Moments" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSArray *arr = [TLMoment mj_objectArrayWithKeyValuesArray:jsonArray];
    return arr;
}

@end
@interface TLMomentsViewController ()<TLMomentViewDelegate>

@property (nonatomic, strong) TLMomentsProxy *proxy;


- (void)loadData;


- (void)registerCellForTableView:(UITableView *)tableView;

@end

@implementation TLMomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"朋友圈"];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, 60.0f)]];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_camera"] style:UIBarButtonItemStylePlain actionBlick:^{
        
    }];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    [self registerCellForTableView:self.tableView];
    [self loadData];
}

#pragma mark - # Getter
- (TLMomentsProxy *)proxy
{
    if (_proxy == nil) {
        _proxy = [[TLMomentsProxy alloc] init];
    }
    return _proxy;
}
- (void)loadData
{
    self.data = [NSMutableArray arrayWithArray:self.proxy.testData];
    [self.tableView reloadData];
}
- (void)registerCellForTableView:(UITableView *)tableView
{
    [tableView registerClass:[TLMomentHeaderCell class] forCellReuseIdentifier:@"TLMomentHeaderCell"];
    [tableView registerClass:[TLMomentImagesCell class] forCellReuseIdentifier:@"TLMomentImagesCell"];
    [tableView registerClass:[TLTableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}

#pragma mark - # Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TLMomentHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMomentHeaderCell"];
        [cell setUser:[TLUserHelper sharedHelper].user];
        return cell;
    }
    
    TLMoment *moment = [self.data objectAtIndex:indexPath.row - 1];
    id cell;
    if (moment.detail.text.length > 0 || moment.detail.images.count > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TLMomentImagesCell"];
    }
    
    if (cell) {
        [cell setMoment:moment];
        [cell setDelegate:self];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 260.0f;
    }
    
    TLMoment *moment = [self.data objectAtIndex:indexPath.row - 1];
    return (int)moment.momentFrame.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        TLMoment *moment = [self.data objectAtIndex:indexPath.row - 1];
        TLMomentDetailViewController *detailVC = [[TLMomentDetailViewController alloc] init];
        [detailVC setMoment:moment];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//MARK: TLMomentViewDelegate
- (void)momentViewClickImage:(NSArray *)images atIndex:(NSInteger)index
{
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:images.count];
    for (NSString *imageUrl in images) {
        MWPhoto *photo = [MWPhoto photoWithURL:TLURL(imageUrl)];
        [data addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:data];
    [browser setDisplayNavArrows:YES];
    [browser setCurrentPhotoIndex:index];
    TLNavigationController *broserNavC = [[TLNavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:broserNavC animated:NO completion:nil];
}

@end
