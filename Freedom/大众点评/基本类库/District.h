//
//  District.h
//  XTuan
//
//  Created by dengwei on 15/8/15.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//  代表一个区

#import "BaseModel.h"

@interface District : BaseModel

/**
 *  街道
 */
@property(nonatomic, strong)NSArray *neighborhoods;

@end
