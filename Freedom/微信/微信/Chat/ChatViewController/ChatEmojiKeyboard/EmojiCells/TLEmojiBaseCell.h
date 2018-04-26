//  TLEmojiBaseCell.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "TLEmoji.h"
@interface TLEmojiBaseCell : UICollectionViewCell
@property (nonatomic, strong) TLEmoji *emojiItem;
@property (nonatomic, strong) UIImageView *bgView;
/*选中时的背景图片，默认nil*/
@property (nonatomic, strong) UIImage *highlightImage;
@property (nonatomic, assign) BOOL showHighlightImage;
@end
