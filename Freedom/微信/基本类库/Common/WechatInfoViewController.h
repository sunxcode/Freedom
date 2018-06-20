//  TLInfoViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "TLTableViewCell.h"
#import "WechartModes.h"
#import "WechatBaseViewController.h"
@protocol TLInfoButtonCellDelegate <NSObject>
- (void)infoButtonCellClicked:(TLInfo *)info;
@end
@interface WechatInfoButtonCell : TLTableViewCell
@property (nonatomic, assign) id<TLInfoButtonCellDelegate>delegate;
@property (nonatomic, strong) TLInfo *info;
@end
@interface WechatInfoCell : TLTableViewCell
@property (nonatomic, strong) TLInfo *info;
@end
@interface TLInfoHeaderFooterView : UITableViewHeaderFooterView
@end
@interface WechatInfoViewController : UITableViewController <TLInfoButtonCellDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@end
