//  AppDelegate.h
//  Freedom
//  Created by Super on 16/6/13.
//  Copyright © 2016年 Super. All rights reserved.
#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIBackgroundTaskIdentifier taskID;
    UIImageView *_launchView;
}
@property (strong, nonatomic) UIWindow *window;
@end
