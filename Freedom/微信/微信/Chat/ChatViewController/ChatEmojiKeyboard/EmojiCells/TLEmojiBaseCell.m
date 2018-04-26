//  TLEmojiBaseCell.m
//  Freedom
// Created by Super
#import "TLEmojiBaseCell.h"
@implementation TLEmojiBaseCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)setShowHighlightImage:(BOOL)showHighlightImage{
    if (showHighlightImage) {
        [self.bgView setImage:self.highlightImage];
    }else{
        [self.bgView setImage:nil];
    }
}
#pragma mark - Getter -
- (UIImageView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] init];
        [_bgView.layer setMasksToBounds:YES];
        [_bgView.layer setCornerRadius:5.0f];
    }
    return _bgView;
}
@end
