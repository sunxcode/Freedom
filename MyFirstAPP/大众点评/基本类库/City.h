//
//  City.h
//  XTuan
//
//  Created by dengwei on 15/8/15.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseModel.h"
#import <CoreLocation/CoreLocation.h>

@interface City : BaseModel

/**
 *  分区
 */
@property(nonatomic, strong)NSArray *districts;

@property(nonatomic, assign)BOOL hot;

@property(nonatomic, assign)CLLocationCoordinate2D position;

@end
