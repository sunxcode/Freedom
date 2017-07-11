//
//  AppDelegate.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/6/13.
//  Copyright © 2016年 薛超. All rights reserved.
#import "AppDelegate.h"
#import "TotalData.h"
#import "FirstViewController.h"
//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#import <ShareSDK/ShareSDK.h>
//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

//人人SDK头文件
#import <RennSDK/RennSDK.h>

//支付宝SDK
#import "APOpenAPI.h"

//易信SDK头文件
#import "YXApi.h"

@interface AppDelegate ()<WXApiDelegate>{
    NSMutableArray *items;
}

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
//    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
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
            }
            [self saveContext];
            NSError *error = nil;
            NSArray *b = [self.managedObjectContext executeFetchRequest:request error:&error];
            if (error) {
                NSLog(@"%@", error);
            } else {
                items = [[NSMutableArray alloc] initWithArray:b];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [collectionView reloadData];
                });
            }
        });
    } else {
        items = [[NSMutableArray alloc] initWithArray:a];
//        [collectionView reloadData];
    }
    // 删除所有数据
    //        for (PostCode *postcode in a) {
    //            [del.managedObjectContext deleteObject:postcode];
    //        }
    //        [del saveContext];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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


@end
