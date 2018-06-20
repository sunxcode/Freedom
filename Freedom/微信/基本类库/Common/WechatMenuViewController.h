//  TLMenuViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "WechartModes.h"
@interface WechatMenuCell : UITableViewCell
@property (nonatomic, strong) TLMenuItem *menuItem;
@end
@interface WechatMenuViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSString *analyzeTitle;
@end
