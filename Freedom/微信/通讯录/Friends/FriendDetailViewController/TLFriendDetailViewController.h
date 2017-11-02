//
//  TLFriendDetailViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/2/26.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLInfoViewController.h"
#import "TLFriendDetailUserCell.h"

#define     HEIGHT_USER_CELL           90.0f
#define     HEIGHT_ALBUM_CELL          80.0f

@class TLUser;
@interface TLFriendDetailViewController : TLInfoViewController <TLFriendDetailUserCellDelegate>

- (void)registerCellClass;


@property (nonatomic, strong) TLUser *user;

@end
