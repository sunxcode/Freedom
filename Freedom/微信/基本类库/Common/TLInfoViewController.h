//
//  TLInfoViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/2/26.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTableViewCell.h"
#import "TLInfo.h"
@protocol TLInfoButtonCellDelegate <NSObject>

- (void)infoButtonCellClicked:(TLInfo *)info;

@end

@interface TLInfoButtonCell : TLTableViewCell

@property (nonatomic, assign) id<TLInfoButtonCellDelegate>delegate;

@property (nonatomic, strong) TLInfo *info;

@end
@interface TLInfoCell : TLTableViewCell

@property (nonatomic, strong) TLInfo *info;

@end
@interface TLInfoHeaderFooterView : UITableViewHeaderFooterView

@end
@interface TLInfoViewController : UITableViewController <TLInfoButtonCellDelegate>

@property (nonatomic, strong) NSMutableArray *data;

@end
