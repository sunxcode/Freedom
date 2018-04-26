//  TLMomentDetail.h
//  Freedom
// Created by Super
@interface TLMomentDetailFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightText;
@property (nonatomic, assign) CGFloat heightImages;
@end
@interface TLMomentDetail : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) TLMomentDetailFrame *detailFrame;
@end
