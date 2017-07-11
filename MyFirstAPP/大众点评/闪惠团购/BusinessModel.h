//
//  BusinessModel.h
//  XTuan
//
//  Created by dengwei on 15/8/20.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//  商家模型

#import <Foundation/Foundation.h>

@interface BusinessModel : NSObject

@property(nonatomic, copy)NSString *city;
@property(nonatomic, copy)NSString *h5_url;
@property(nonatomic, assign)int ID;
@property(nonatomic, assign)double latitude;
@property(nonatomic, assign)double longitude;
@property(nonatomic, copy)NSString *name;

@end
