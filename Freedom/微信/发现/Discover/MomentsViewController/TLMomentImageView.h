//
//  TLMomentImageView.h
//  TLChat
//
//  Created by 李伯坤 on 16/4/23.
//  Copyright © 2016年 李伯坤. All rights reserved.
#import <UIKit/UIKit.h>
#import "TLMoment.h"

@protocol TLMomentMultiImageViewDelegate <NSObject>

- (void)momentViewClickImage:(NSArray *)images atIndex:(NSInteger)index;

@end


@protocol TLMomentDetailViewDelegate <TLMomentMultiImageViewDelegate>

@end


@protocol TLMomentViewDelegate <TLMomentDetailViewDelegate>

@end
@interface TLMomentBaseView : UIView

@property (nonatomic, assign) id<TLMomentViewDelegate> delegate;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *detailContainerView;

@property (nonatomic, strong) UIView *extensionContainerView;

@property (nonatomic, strong) TLMoment *moment;

@end
@interface TLMomentImageView : TLMomentBaseView

@end
