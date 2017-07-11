//
//  AppDelegate.h
//  MyFirstAPP
//
//  Created by 薛超 on 16/6/13.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PPRevealSideViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) UIManagedDocument *document;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)readData;
@property (strong, nonatomic) NSMutableArray *items;
@end

