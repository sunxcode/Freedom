//  TLImageMessage.h
//  Freedom
// Created by Super
#import "TLMessage.h"
@interface TLImageMessage : TLMessage
@property (nonatomic, strong) NSString *imagePath;                  // 本地图片Path
@property (nonatomic, strong) NSString *imageURL;                   // 网络图片URL
@property (nonatomic, assign) CGSize imageSize;
@end
