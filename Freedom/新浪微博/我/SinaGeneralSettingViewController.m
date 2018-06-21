//  SWGeneralSettingViewController.m
//  Freedom
//  Created by Super on 15-3-15.
#import "SinaGeneralSettingViewController.h"
@interface SinaGeneralSettingViewController ()
@end
@implementation SinaGeneralSettingViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupGroups];
}
/*初始化模型数据*/
- (void)setupGroups{
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
}
- (void)setupGroup0{
    // 1.创建组
    SinaCommonGroup *group = [SinaCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    SinaCommonLabelItem *readMdoe = [SinaCommonLabelItem itemWithTitle:@"阅读模式"];
    readMdoe.text = @"有图模式";
    SinaCommonLabelItem *readMdoe1 = [SinaCommonLabelItem itemWithTitle:@"字号大小"];
    readMdoe1.text = @"中";
    SinaCommonLabelItem *readMdoe2 = [SinaCommonLabelItem itemWithTitle:@"显示备注"];
    readMdoe2.text = @"是";
    
    group.items = @[readMdoe,readMdoe1,readMdoe2];
}
- (void)setupGroup1{
    SinaCommonGroup *group = [SinaCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    SinaCommonLabelItem *readMdoe = [SinaCommonLabelItem itemWithTitle:@"图片浏览设置"];
    readMdoe.text = @"自适应";
    SinaCommonLabelItem *readMdoe1 = [SinaCommonLabelItem itemWithTitle:@"视频自动播放"];
    readMdoe1.text = @"仅WiFi";
    
    group.items = @[readMdoe,readMdoe1];
}
- (void)setupGroup2{
    SinaCommonGroup *group = [SinaCommonGroup group];
    [self.groups addObject:group];
    SinaCommonLabelItem *readMdoe1 = [SinaCommonLabelItem itemWithTitle:@"声音"];
    readMdoe1.text = @"开";
    group.items = @[readMdoe1];
}
- (void)setupGroup3{
    SinaCommonGroup *group = [SinaCommonGroup group];
    [self.groups addObject:group];
    SinaCommonLabelItem *readMdoe1 = [SinaCommonLabelItem itemWithTitle:@"多语言环境"];
    readMdoe1.text = @"跟随系统";
    group.items = @[readMdoe1];
}
@end
