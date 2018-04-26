//  TLMineSettingViewController.m
//  Freedom
//  Created by Super on 16/2/8.
#import "TLMineSettingViewController.h"
#import "TLActionSheet.h"
#import "TLAccountAndSafetyViewController.h"
#import "TLNewMessageSettingViewController.h"
#import "TLPrivacySettingViewController.h"
#import "TLCommonSettingViewController.h"
#import "TLHelpAndFeedbackViewController.h"
#import "TLAboutViewController.h"
#import "WechartModes.h"
typedef void (^ CompleteBlock)(NSMutableArray *data);
@interface TLSettingHelper : NSObject
@property (nonatomic, strong) NSMutableArray *mineSettingData;
@end
@implementation TLSettingHelper
- (id) init{
    if (self = [super init]) {
        self.mineSettingData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    TLSettingItem *item1 = TLCreateSettingItem(@"账号与安全");
    if (/* DISABLES CODE */ (1)) {
        item1.subTitle = @"已保护";
        item1.rightImagePath = PprotectHL;
    }else {
        item1.subTitle = @"未保护";
        item1.rightImagePath = Pprotect;
    }
    TLSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[item1]);
    
    TLSettingItem *item2 = TLCreateSettingItem(@"新消息通知");
    TLSettingItem *item3 = TLCreateSettingItem(@"隐私");
    TLSettingItem *item4 = TLCreateSettingItem(@"通用");
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[item2, item3, item4]));
    
    TLSettingItem *item5 = TLCreateSettingItem(@"帮助与反馈");
    TLSettingItem *item6 = TLCreateSettingItem(@"关于微信");
    TLSettingGroup *group3 = TLCreateSettingGroup(nil, nil, (@[item5, item6]));
    
    TLSettingItem *item7 = TLCreateSettingItem(@"退出登录");
    item7.type = TLSettingItemTypeTitleButton;
    TLSettingGroup *group4 = TLCreateSettingGroup(nil, nil, @[item7]);
    
    [self.mineSettingData addObjectsFromArray:@[group1, group2, group3, group4]];
}
@end
@interface TLMineSettingViewController () <TLActionSheetDelegate>
@property (nonatomic, strong) TLSettingHelper *helper;
@end
@implementation TLMineSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置"];
    
    self.helper = [[TLSettingHelper alloc] init];
    self.data = self.helper.mineSettingData;
}
#pragma mark - 
//MARK: UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TLSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"账号与安全"]) {
        TLAccountAndSafetyViewController *accountAndSafetyVC = [[TLAccountAndSafetyViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:accountAndSafetyVC animated:YES];
    }else if ([item.title isEqualToString:@"新消息通知"]) {
        TLNewMessageSettingViewController *newMessageSettingVC = [[TLNewMessageSettingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newMessageSettingVC animated:YES];
    }else if ([item.title isEqualToString:@"隐私"]) {
        TLPrivacySettingViewController *privacySettingVC = [[TLPrivacySettingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:privacySettingVC animated:YES];
    }else if ([item.title isEqualToString:@"通用"]) {
        TLCommonSettingViewController *commonSettingVC = [[TLCommonSettingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:commonSettingVC animated:YES];
    }else if ([item.title isEqualToString:@"帮助与反馈"]) {
        TLHelpAndFeedbackViewController *helpAndFeedbackVC = [[TLHelpAndFeedbackViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:helpAndFeedbackVC animated:YES];
    }else if ([item.title isEqualToString:@"关于微信"]) {
        TLAboutViewController *aboutVC = [[TLAboutViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if ([item.title isEqualToString:@"退出登录"]) {
        TLActionSheet *actionSheet = [[TLActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
        [actionSheet show];
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
//MARK: TLActionSheetDelegate
- (void)actionSheet:(TLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
}
@end
