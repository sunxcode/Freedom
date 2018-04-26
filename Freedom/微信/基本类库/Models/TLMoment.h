//  TLMoment.h
//  Freedom
// Created by Super
#import "TLMomentDetail.h"
#import "TLMomentExtension.h"
@interface TLMomentFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightDetail;
@property (nonatomic, assign) CGFloat heightExtension;
@end
@interface TLMoment : NSObject
@property (nonatomic, strong) NSString *momentID;
@property (nonatomic, strong) TLUser *user;
@property (nonatomic, strong) NSDate *date;
/// 详细内容
@property (nonatomic, strong) TLMomentDetail *detail;
/// 附加（评论，赞）
@property (nonatomic, strong) TLMomentExtension *extension;
@property (nonatomic, strong) TLMomentFrame *momentFrame;
@end
