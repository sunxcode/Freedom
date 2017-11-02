//
//  SWCommonViewController.h
//  新浪微博
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 xc. All rights reserved.
//  抽取公共方法:只是模型数据改变
//

#import <UIKit/UIKit.h>
#import "SWCommonGroup.h"
#import "SWCommonItem.h"
#import "SWCommonCell.h"
#import "SWCommonArrowItem.h"
#import "SWCommonSwitchItem.h"
#import "SWCommonLabelItem.h"
@interface SWCommonTableViewController : UITableViewController

- (NSMutableArray *)groups;
@end