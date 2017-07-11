//
//  LocalMusicViewController.m
//  CLKuGou
//
//  Created by Darren on 16/7/31.
//  Copyright © 2016年 darren. All rights reserved.
//本地音乐播放列表而已

#import "LocalMusicViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "KugouTabBarController.h"
#import "LocalMusicCell.h"
#import <AVFoundation/AVFoundation.h>
#import "NSMutableArray+expanded.h"
@interface LocalMusicViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) MPMusicPlayerController *musicController;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *iconArr;// 头像
@property (nonatomic,strong) NSMutableArray *songArr;// 歌曲名
@property (nonatomic,strong) NSMutableArray *singerArr;// 歌手
@property (nonatomic,strong) NSArray *musicArr;// 歌曲
@property (nonatomic,strong) NSMutableArray *assetURLArr;// 对应的url地址
@property (nonatomic,strong) NSMutableArray *timerArr;// 时长
@property (nonatomic,strong) KugouTools *tools;
@end

@implementation LocalMusicViewController
#pragma 懒加载
- (NSMutableArray *)iconArr{if (_iconArr == nil) {_iconArr = [NSMutableArray array];}return _iconArr;}
- (NSMutableArray *)songArr{if (_songArr == nil) {_songArr = [NSMutableArray array];}return _songArr;}
- (NSMutableArray *)singerArr{if (_singerArr == nil) {_singerArr = [NSMutableArray array];}return _singerArr;}
- (NSMutableArray *)assetURLArr{if(_assetURLArr == nil) {_assetURLArr = [NSMutableArray array];}return _assetURLArr;}
- (NSMutableArray *)timerArr{if (_timerArr == nil) {_timerArr = [NSMutableArray array];}return _timerArr;}
//systemMusicPlayer应用停止后继续播放
// applicationMusicPlayer应用停止后停止播放
- (MPMusicPlayerController *)musicController{
    if (_musicController == nil) {
        _musicController  = [MPMusicPlayerController systemMusicPlayer];
        [_musicController beginGeneratingPlaybackNotifications];// 允许其添加通知，用来监听到MPMusicPlayerController
        //        [self addNoticefication];
    }return _musicController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的音乐";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *myencode = [def valueForKey:@"currentMusicInfo"];
    self.tools = (KugouTools *)[NSKeyedUnarchiver unarchiveObjectWithData:myencode];
    if (myencode) {
    } else {
        self.tools = [[KugouTools alloc] init];
    }
    [self setupLocalMusic];
    [self setupTableView];
}
- (void)setupLocalMusic{
    MPMediaQuery *everyMusic = [[MPMediaQuery alloc] init];
    self.musicArr = [everyMusic items];
    for (MPMediaItem *mediaItem in self.musicArr) {
        [self.songArr addSafeObject:mediaItem.title];
        [self.singerArr addSafeObject:mediaItem.albumArtist];
        [self.assetURLArr addSafeObject:mediaItem.assetURL];
        [self.timerArr addSafeObject:@(mediaItem.playbackDuration)];
        if (mediaItem.artwork) {
            UIImage *image = [mediaItem.artwork imageWithSize:CGSizeMake(50, 50)];
            [self.iconArr addSafeObject:image];
        } else {
            [self.iconArr addSafeObject:[UIImage imageNamed:@"placeHoder-128"]];
        }
    }
}
- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPW, APPH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    tableView.tableFooterView = [UIView new];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.singerArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocalMusicCell *cell = [LocalMusicCell cellWithTableView:tableView];
    cell.iconView.image = self.iconArr[indexPath.row];
    cell.iconView.layer.cornerRadius = cell.iconView.frameWidth*0.5;
    cell.iconView.layer.masksToBounds = YES;
    cell.mainLable.text = self.songArr[indexPath.row];
    cell.subLable.text = self.singerArr[indexPath.row];
    int second = [self.timerArr[indexPath.row] intValue];
    if (second < 60) {
        cell.timerLable.text = [NSString stringWithFormat:@"%d'",second];
    } else {
        int minus = second/60;
        cell.timerLable.text = [NSString stringWithFormat:@"%d:%d'",minus,second%60];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.tools.mediaItem = self.musicArr[indexPath.row];
    NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:self.tools];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:encodeData forKey:@"currentMusicInfo"];
    [def synchronize];
    
    // 把相关信息传递到tabbar
    KugouTabBarController *tabbar = (KugouTabBarController *)self.tabBarController;
    tabbar.coustomTabBar.assetUrl = self.assetURLArr[indexPath.row];
    tabbar.coustomTabBar.IconView.image = self.iconArr[indexPath.row];
    tabbar.coustomTabBar.songNameLable.text = self.songArr[indexPath.row];
    tabbar.coustomTabBar.singerLable.text = self.singerArr[indexPath.row];
}


//- (void)show{
//    if (_imagesPath) {
//        //单例方法,创建管理文件的单例方法
//        NSFileManager *fm = [NSFileManager defaultManager];
//        //深度遍历(会去遍历当前目录下的子目录里的文件)
//        NSArray *array = [fm subpathsOfDirectoryAtPath:_imagesPath error:nil];
//        NSMutableArray *images = [[NSMutableArray alloc] init];
//        NSString *strFullPath = nil;
//        for (NSString *str in array) {
//            if ([str hasSuffix:@"png"]) {
//                strFullPath = [NSString stringWithFormat:@"%@/%@",_imagesPath,str];
//                NSData *data = [NSData dataWithContentsOfFile:strFullPath];
//                UIImage *image = [[UIImage alloc] initWithData:data];
//                [images addObject:image];
//            }
//        }
//        NSLog(@"count = %d",images.count);
//        if (images.count != 0) {
//            self.animationImages = images;
//            self.animationDuration = _velocity;
//            [self startAnimating];
//        }
//    }
//}
//- (void)hide{
//    [self stopAnimating];
//}
@end
