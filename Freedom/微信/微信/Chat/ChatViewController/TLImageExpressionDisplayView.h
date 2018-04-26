//  TLImageExpressionDisplayView.h
//  Freedom
//  Created by Super on 16/3/16.
#import <UIKit/UIKit.h>
#import "TLEmoji.h"
@interface TLImageExpressionDisplayView : UIView
@property (nonatomic, strong) TLEmoji *emoji;
@property (nonatomic, assign) CGRect rect;
- (void)displayEmoji:(TLEmoji *)emoji atRect:(CGRect)rect;
@end
