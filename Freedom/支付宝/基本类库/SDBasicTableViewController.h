//  SDBasicTableViewController.h
//  Freedom
//  Created by Super on 15-6-4.

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    SDBasicTableViewControllerRefeshModeNone                    = 0,
    SDBasicTableViewControllerRefeshModeHeaderRefresh           = 1 << 0,
    SDBasicTableViewControllerRefeshModeFooterRefresh           = 1 << 1
} SDBasicTableViewControllerRefeshMode;
@interface SDBasicTableViewControllerCell : UITableViewCell
@property (nonatomic, strong) NSObject *model;
@end
@interface SDBasicTableViewController : UITableViewController
@property (nonatomic, assign) NSInteger sectionsNumber;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) Class cellClass;
@property (nonatomic, copy) Class cellModelClass;
@property (nonatomic, assign) SDBasicTableViewControllerRefeshMode refreshMode;
// 如果需要刷新，子类须重写此方法
- (void)pullDownRefreshOperation;
@end
