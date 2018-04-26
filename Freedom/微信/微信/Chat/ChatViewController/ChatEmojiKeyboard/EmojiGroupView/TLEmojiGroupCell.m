//  TLEmojiGroupCell.m
//  Freedom
//  Created by Super on 16/2/19.
#import "TLEmojiGroupCell.h"
@interface TLEmojiGroupCell ()
@property (nonatomic, strong) UIImageView *groupIconView;
@end
@implementation TLEmojiGroupCell
- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *selectedView = [[UIView alloc] init];
        [selectedView setBackgroundColor:RGBACOLOR(245.0, 245.0, 247.0, 1.0)];
        [self setSelectedBackgroundView:selectedView];
        
        [self.contentView addSubview:self.groupIconView];
        [self p_addMasonry];
    }
    return self;
}
- (void)setEmojiGroup:(TLEmojiGroup *)emojiGroup{
    _emojiGroup = emojiGroup;
    [self.groupIconView setImage:[UIImage imageNamed:emojiGroup.groupIconPath]];
}
#pragma mark - Private Methods -
- (void) p_addMasonry{
    [self.groupIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.and.height.mas_lessThanOrEqualTo(30);
    }];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, colorGrayLine.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.frameWidth - 0.5, 5);
    CGContextAddLineToPoint(context, self.frameWidth - 0.5, self.frameHeight - 5);
    CGContextStrokePath(context);
}
#pragma mark - Getter -
- (UIImageView *)groupIconView{
    if (_groupIconView == nil) {
        _groupIconView = [[UIImageView alloc] init];
    }
    return _groupIconView;
}
@end
