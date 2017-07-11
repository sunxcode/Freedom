//
//  City.m
//  XTuan
//
//  Created by dengwei on 15/8/15.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "City.h"
#import "District.h"
#import "NSObject+Value.h"

@implementation City

-(void)setDistricts:(NSArray *)districts
{
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in districts) {
        District *districts = [[District alloc] init];
        
        [districts setValues:dict];
        
        [arrayM addObject:districts];
    }
    
    _districts = arrayM;
    
}

@end
