//  TLExpressionCell.h
//  Freedom
//  Created by Super on 16/4/4.
#import "TLTableViewCell.h"
#import "TLEmojiGroup.h"
@protocol TLExpressionCellDelegate <NSObject>
- (void)expressionCellDownloadButtonDown:(TLEmojiGroup *)group;
@end
@interface TLExpressionCell : TLTableViewCell
@property (nonatomic, assign) id<TLExpressionCellDelegate> delegate;
@property (nonatomic, strong) TLEmojiGroup *group;
@end
