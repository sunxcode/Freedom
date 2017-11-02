//
//  TLSettingViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/2/7.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLSettingItem;
@protocol TLSettingSwitchCellDelegate <NSObject>
@optional
- (void)settingSwitchCellForItem:(TLSettingItem *)settingItem didChangeStatus:(BOOL)on;
@end
@interface TLSettingViewController : UITableViewController <TLSettingSwitchCellDelegate>

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSString *analyzeTitle;

@end
