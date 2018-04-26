//  TLMenuViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "TLMenuItem.h"
@interface TLMenuCell : UITableViewCell
@property (nonatomic, strong) TLMenuItem *menuItem;
@end
@interface TLMenuViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSString *analyzeTitle;
@end
