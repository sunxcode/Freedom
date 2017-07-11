//
//  CitySection.m
//  XTuan
//
//  Created by dengwei on 15/8/15.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "CitySection.h"
#import "City.h"
#import "NSObject+Value.h"

@implementation CitySection

-(void)setCities:(NSMutableArray *)cities
{
    
    // 当cities为空或者里面装的是模型数据，就直接赋值
    id obj = [cities lastObject];
    if (![obj isKindOfClass:[NSDictionary class]]){
        _cities = cities;
        return;
    }
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in cities) {
        
        if ([dict isKindOfClass:[City class]]) {
            _cities = cities;
            return;
        }
        
        City *city = [[City alloc] init];
        
        [city setValues:dict];
        
        [arrayM addObject:city];
    }
    
    _cities = arrayM;

}

@end
