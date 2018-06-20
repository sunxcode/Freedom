//  TLPrivacySettingViewController.m
//  Freedom
// Created by Super
#import "WXPrivacySettingViewController.h"
#import "WechartModes.h"
@interface WXPrivacySettingHelper : NSObject
@property (nonatomic, strong) NSMutableArray *minePrivacySettingData;
@end
@implementation WXPrivacySettingHelper
- (id) init{
    if (self = [super init]) {
        self.minePrivacySettingData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    TLSettingItem *item1 = TLCreateSettingItem(@"加我为好友时需要验证");
    item1.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group1 = TLCreateSettingGroup(@"通讯录", nil, @[item1]);
    
    TLSettingItem *item2 = TLCreateSettingItem(@"向我推荐QQ好友");
    item2.type = TLSettingItemTypeSwitch;
    TLSettingItem *item3 = TLCreateSettingItem(@"通过QQ号搜索到我");
    item3.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[item2, item3]));
    
    TLSettingItem *item4 = TLCreateSettingItem(@"可通过手机号搜索到我");
    item4.type = TLSettingItemTypeSwitch;
    TLSettingItem *item5 = TLCreateSettingItem(@"向我推荐通讯录好友");
    item5.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group3 = TLCreateSettingGroup(nil, @"开启后，为你推荐已经开通微信的手机联系人", (@[item4, item5]));
    
    TLSettingItem *item6 = TLCreateSettingItem(@"通过微信号搜索到我");
    item6.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group4 = TLCreateSettingGroup(nil, @"关闭后，其他用户将不能通过微信号搜索到你", @[item6]);
    
    TLSettingItem *item7 = TLCreateSettingItem(@"通讯录黑名单");
    TLSettingGroup *group5 = TLCreateSettingGroup(nil, nil, @[item7]);
    
    TLSettingItem *item8 = TLCreateSettingItem(@"不让他(她)看我的朋友圈");
    TLSettingItem *item9 = TLCreateSettingItem(@"不看他(她)的朋友圈");
    TLSettingGroup *group6 = TLCreateSettingGroup(@"朋友圈", nil, (@[item8, item9]));
    
    TLSettingItem *item10 = TLCreateSettingItem(@"允许陌生人查看十张照片");
    item10.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group7 = TLCreateSettingGroup(nil, nil, @[item10]);
    
    [self.minePrivacySettingData addObjectsFromArray:@[group1, group2, group3, group4, group5, group6, group7]];
}
@end
@interface WXPrivacySettingViewController ()
@property (nonatomic, strong) WXPrivacySettingHelper *helper;
@end
@implementation WXPrivacySettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"隐私"];
    
    self.helper = [[WXPrivacySettingHelper alloc] init];
    self.data = self.helper.minePrivacySettingData;
}
@end
