//
//  TLNewFriendViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/7.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLTableViewController.h"
@protocol TLAddThirdPartFriendCellDelegate <NSObject>

- (void)addThirdPartFriendCellDidSelectedType:(NSString *)thirdPartFriendType;

@end
@interface TLNewFriendViewController : TLTableViewController<UISearchBarDelegate, TLAddThirdPartFriendCellDelegate>

- (void)registerCellClass;

@end
