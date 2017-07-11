//
//  LocalMusicCell.m
//  CLKuGou
//
//  Created by Darren on 16/7/31.
//  Copyright © 2016年 darren. All rights reserved.
//

#import "LocalMusicCell.h"

@interface LocalMusicCell()

@end

@implementation LocalMusicCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *setId = @"songCell";
    LocalMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:setId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LocalMusicCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
