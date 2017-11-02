
//
//  TLMomentExtensionView.m
//  TLChat
//
//  Created by libokun on 16/4/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLMomentExtensionView.h"
#import "TLMomentExtensionCommentCell.h"
#import "TLMomentExtensionLikedCell.h"

#define     EDGE_HEADER     5.0f

@interface TLMomentExtensionView ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TLMomentExtensionView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(EDGE_HEADER);
            make.left.and.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).priorityLow();
        }];
        
        [self registerCellForTableView:self.tableView];
    }
    return self;
}

- (void)setExtension:(TLMomentExtension *)extension
{
    _extension = extension;
    [self.tableView reloadData];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat startX = 20;
    CGFloat startY = 0;
    CGFloat endY = EDGE_HEADER;
    CGFloat width = 6;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, startX + width, endY);
    CGContextAddLineToPoint(context, startX - width, endY);
    CGContextClosePath(context);
    [[UIColor colorGrayForMoment] setFill];
    [[UIColor colorGrayForMoment] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - # Getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:[UIColor colorGrayForMoment]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setScrollsToTop:NO];
        [_tableView setScrollEnabled:NO];
    }
    return _tableView;
}

- (void)registerCellForTableView:(UITableView *)tableView
{
    [tableView registerClass:[TLMomentExtensionCommentCell class] forCellReuseIdentifier:@"TLMomentExtensionCommentCell"];
    [tableView registerClass:[TLMomentExtensionLikedCell class] forCellReuseIdentifier:@"TLMomentExtensionLikedCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}

#pragma mark - # Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = self.extension.likedFriends.count > 0 ? 1 : 0;
    section += self.extension.comments.count > 0 ? 1 : 0;
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.extension.likedFriends.count > 0) {
        return 1;
    }
    else {
        return self.extension.comments.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.extension.likedFriends.count > 0) {  // 点赞
        TLMomentExtensionLikedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMomentExtensionLikedCell"];
        [cell setLikedFriends:self.extension.likedFriends];
        return cell;
    }
    else {      // 评论
        TLMomentComment *comment = [self.extension.comments objectAtIndex:indexPath.row];
        TLMomentExtensionCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMomentExtensionCommentCell"];
        [cell setComment:comment];
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.extension.likedFriends.count > 0) {
        return self.extension.extensionFrame.heightLiked;
    }
    else {
        TLMomentComment *comment = [self.extension.comments objectAtIndex:indexPath.row];
        return comment.commentFrame.height;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
