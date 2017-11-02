//
//  SWCommonCell.m
//  新浪微博
//
//  Created by apple on 15-3-15.
//  Copyright (c) 2015年 xc. All rights reserved.
//


#import "SWCommonCell.h"
#import "SWCommonItem.h"
#import "SWCommonArrowItem.h"
#import "SWCommonSwitchItem.h"
#import "SWCommonLabelItem.h"
#import "NSString+expanded.h"
@interface SWCommonCell()
/**
 *  箭头
 */
@property (strong, nonatomic) UIImageView *rightArrow;
/**
 *  开关
 */
@property (strong, nonatomic) UISwitch *rightSwitch;
/**
 *  标签
 */
@property (strong, nonatomic) UILabel *rightLabel;
/**
 *  提醒数字
 */
@property (strong, nonatomic) UIButton *bageView;
@property (nonatomic, copy) NSString *badgeValue;
@end

@implementation SWCommonCell
#pragma mark - 懒加载右边的view
- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PcellRight]];
    }
    return _rightArrow;
}

- (UISwitch *)rightSwitch
{
    if (_rightSwitch == nil) {
        self.rightSwitch = [[UISwitch alloc] init];
    }
    return _rightSwitch;
}

- (UILabel *)rightLabel
{
    if (_rightLabel == nil) {
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rightLabel;
}

- (UIButton *)bageView
{
    if (_bageView == nil) {
        self.bageView = [[UIButton alloc] init];
        self.bageView.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.bageView setBackgroundImage:[UIImage resizableImageWithName:@"main_badge@2x"] forState:UIControlStateNormal];
    }
    return _bageView;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    SWCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SWCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置标题的字体
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        
        // 去除cell的默认背景色
        self.backgroundColor = [UIColor clearColor];
        
        // 设置背景view
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
        
    }
    return self;
}

#pragma mark - 调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整子标题的x
    self.detailTextLabel.frameX = CGRectGetMaxX(self.textLabel.frame) + 5;
}
#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows
{
    // 1.取出背景view
    UIImageView *bgView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
    
    
    bgView.image = [UIImage imageWithColor:whitecolor];
    selectedBgView.image = [UIImage imageWithColor:RGBCOLOR(241, 241, 241)];
}

- (void)setItem:(SWCommonItem *)item
{
    _item = item;
    
    // 1.设置基本数据
    self.imageView.image = [UIImage imageNamed:item.icon];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    
    // 2.设置右边的内容
    if (item.badgeValue) { // 紧急情况：右边有提醒数字
//        // 按钮的高度就是背景图片的高度
//        self.bageView.height = self.bageView.currentBackgroundImage.size.height;
//        // 设置文字
//        [self.bageView setTitle:item.badgeValue forState:UIControlStateNormal];
//        
//        // 根据文字计算自己的尺寸
//        CGSize titleSize = [item.badgeValue sizeWithFont:self.bageView.titleLabel.font maxSize:CGSizeMake(0x1.fffffep+127f, 0x1.fffffep+127f)];
//        CGFloat bgW = self.bageView.currentBackgroundImage.size.width;
//        if (titleSize.width < bgW) {
//            self.bageView.width = bgW;
//        } else {
//            self.bageView.width = titleSize.width + 10;
//        }
        
        self.accessoryView = self.bageView;
    } else if ([item isKindOfClass:[SWCommonArrowItem class]]) {
        self.accessoryView = self.rightArrow;
    } else if ([item isKindOfClass:[SWCommonSwitchItem class]]) {
        self.accessoryView = self.rightSwitch;
    } else if ([item isKindOfClass:[SWCommonLabelItem class]]) {
        SWCommonLabelItem *labelItem = (SWCommonLabelItem *)item;
        // 设置文字
        self.rightLabel.text = labelItem.text;
        // 根据文字计算尺寸
        self.rightLabel.frameSize = [labelItem.text sizeOfFont:self.rightLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.accessoryView = self.rightLabel;
    } else { // 取消右边的内容
        self.accessoryView = nil;
    }
}
@end
