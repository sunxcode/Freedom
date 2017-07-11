//
//  LocalMusicCell.h
//  CLKuGou
//
//  Created by Darren on 16/7/31.
//  Copyright © 2016年 darren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalMusicCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *mainLable;
@property (weak, nonatomic) IBOutlet UILabel *subLable;
@property (weak, nonatomic) IBOutlet UILabel *timerLable;

@end
