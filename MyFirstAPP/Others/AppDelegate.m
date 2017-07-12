//
//  AppDelegate.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/6/13.
//  Copyright © 2016年 薛超. All rights reserved.
#import "AppDelegate.h"
#import "TotalData.h"
//#import "SliderViewController.h"
#import "FirstViewController.h"
#import "SettingsViewController.h"
#import "LibraryCollectionViewController.h"

#import "PlayAudioViewController.h"
//#import "TheAmazingAudioEngine.h"
#import <AVFoundation/AVFoundation.h>
//#import "LaunchViewController.h"
//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//#import <ShareSDK/ShareSDK.h>
//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
//#import "WXApi.h"

//新浪微博SDK头文件
//#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

//人人SDK头文件
//#import <RennSDK/RennSDK.h>

//支付宝SDK
//#import "APOpenAPI.h"

//易信SDK头文件
//#import "YXApi.h"

@interface AppDelegate ()
@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize audioController = _audioController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    _launchView  = [[UIImageView alloc] initWithFrame:self.window.bounds];
    _launchView.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    _launchView.alpha = 1;
    [self.window addSubview:_launchView];
    [self.window bringSubviewToFront:_launchView];
    
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
        _launchView.frame = CGRectMake(-80, -140, self.window.bounds.size.width+160, self.window.bounds.size.height+320); //最终位置
        _launchView.alpha = 0;
    } completion:^(BOOL finished) {
        [_launchView removeFromSuperview];
    }];

    FirstViewController *controller = (FirstViewController *)self.window.rootViewController;
    controller.managedObjectContext = self.managedObjectContext;
    //检查初次使用标识
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:@"hasRunBefore"] != YES) {
        [prefs setBool:YES forKey:@"hasRunBefore"];
        [prefs synchronize];
        [self readData];
    }
    //数据操作提交并检查错误
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Failed to add default Object with error: %@", [error domain]);
    return YES;
}
- (void)readData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TotalData"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"icon" ascending:NO]];
    NSError *error = nil;
    NSArray *a = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        DLog(@"%@", error);
    }
    if (!a || ([a isKindOfClass:[NSArray class]] && [a count] <= 0)) {
        // 添加数据到数据库
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *strPath = [[NSBundle mainBundle] pathForResource:@"icons" ofType:@"txt"];
            NSString *text = [NSString stringWithContentsOfFile:strPath encoding:NSUTF16StringEncoding error:nil];
            NSArray *lineArr = [text componentsSeparatedByString:@"\n"];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"TotalData" inManagedObjectContext:self.managedObjectContext];
            for (NSString *line in lineArr) {
                NSArray *icons = [line componentsSeparatedByString:@"\t"];
                /*items[0],items[1], items[2], items[3], items[4], items[5]*/
                TotalData *icon = [[TotalData alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
                icon.title = icons[0];
                icon.icon = icons[1];
                icon.control = icons[2];
            }
            [self saveContext];
            NSError *error = nil;
            NSArray *b = [self.managedObjectContext executeFetchRequest:request error:&error];
            if (error) {
                NSLog(@"%@", error);
            } else {
                self.items = [[NSMutableArray alloc] initWithArray:b];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [collectionView reloadData];
                });
            }
        });
    } else {
        self.items = [[NSMutableArray alloc] initWithArray:a];
//        [collectionView reloadData];
    }
    // 删除所有数据
//            for (TotalData *data in a) {
//                [self.managedObjectContext deleteObject:data];
//            }
//            [self saveContext];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // 设置音频会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

/**
 *  当app进入后台时调用
 */

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    taskID = [application beginBackgroundTaskWithExpirationHandler:nil];//模拟机可以后台 (在真机上不行)
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
    
    // 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay
    // 搞一个0kb的MP3文件，没有声音
    // 循环播放
    
    // 以前的后台模式只有3种
    // 保持网络连接
    // 多媒体应用
    // VOIP:网络电话
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application endBackgroundTask:taskID];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (BOOL)canResignFirstResponder{
    return YES;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    NSLog(@"remoteControlReceivedWithEvent");
    PlayAudioViewController *pbVC = [PlayAudioViewController shared];
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [pbVC play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [pbVC play];
                break;
            case UIEventSubtypeRemoteControlStop:
                [pbVC stop];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [pbVC rewind];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [pbVC fastForward];
                break;
            default:
                break;
        }
    }
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    //取消下载
    [mgr cancelAll];
    //清空缓存
    [mgr.imageCache clearMemory];
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)managedObjectContext{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyCoreData" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TotalData.sqlite"];
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"数据库初始化失败";
        dict[NSLocalizedFailureReasonErrorKey] = @"创建或加载数据库的时候出错";
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"未解决的错误 %@, %@", error, [error userInfo]);
        abort();
    }
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
//- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController *)controller directionsAllowedForPanningOnView:(UIView *)view {
//    return PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop | PPRevealSideDirectionBottom;
//}

@end
