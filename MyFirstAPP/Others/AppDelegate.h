//
//  AppDelegate.h
//  MyFirstAPP
//
//  Created by 薛超 on 16/6/13.
//  Copyright © 2016年 薛超. All rights reserved.
#import <UIKit/UIKit.h>
@class AEAudioController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIBackgroundTaskIdentifier taskID;
    UIImageView *_launchView;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AEAudioController *audioController;
@property (readonly, strong, nonatomic) UIManagedDocument *document;
- (NSURL *)applicationDocumentsDirectory;
- (void)readData;
@property (strong, nonatomic) NSMutableArray *items;
@end

