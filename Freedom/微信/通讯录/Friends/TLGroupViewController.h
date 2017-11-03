//
//  TLGroupViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/7.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLTableViewController.h"
#import "TLGroup.h"

#import "TLTableViewCell.h"
@interface TLGroupSearchViewController : TLTableViewController <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *groupData;

@end
@interface TLGroupCell : TLTableViewCell

@property (nonatomic, strong) TLGroup *group;

@end
@interface TLGroupViewController : TLTableViewController

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) TLGroupSearchViewController *searchVC;

- (void)registerCellClass;

@end
