//
//  DealModel.m
//  XTuan
//
//  Created by dengwei on 15/8/15.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "DealModel.h"
#import "NSString+DZ.h"
#import "RestrictionModel.h"
#import "NSObject+Value.h"
#import "BusinessModel.h"

@implementation DealModel

-(void)setList_price:(double)list_price
{
    _list_price = list_price;
    
    _list_price_text = [NSString stringWithDouble:list_price decimalsCount:2];
}

-(void)setCurrent_price:(double)current_price
{
    _current_price = current_price;
    
    _current_price_text = [NSString stringWithDouble:current_price decimalsCount:2];
}

-(void)setRestrictions:(RestrictionModel *)restrictions
{
    if ([restrictions isKindOfClass:[NSDictionary class]]) {
        _restrictions = [[RestrictionModel alloc] init];
        [_restrictions setValues:(NSDictionary *)restrictions];
    }else{
        _restrictions = restrictions;
    }
}

-(void)setBusinesses:(NSArray *)businesses
{
    NSDictionary *obj = [businesses lastObject];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *tmp = [NSMutableArray array];
        
        for (NSDictionary *dict in businesses) {
            BusinessModel *business = [[BusinessModel alloc]init];
            [business setValues:dict];
            [tmp addObject:business];
        }
        _businesses = tmp;
    }else{
        _businesses = businesses;
    }
}

//重写，默认比较内存地址
-(BOOL)isEqual:(DealModel *)other
{
    BOOL flag = NO;
    if (other.deal_id) {
        flag = [other.deal_id isEqualToString:_deal_id];
    }
    
    return flag;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.deal_id = [aDecoder decodeObjectForKey:@"_deal_id"];
        self.title = [aDecoder decodeObjectForKey:@"_title"];
        self.list_price = [aDecoder decodeDoubleForKey:@"_list_price"];
        self.image_url = [aDecoder decodeObjectForKey:@"_image_url"];
        self.desc = [aDecoder decodeObjectForKey:@"_desc"];
        self.current_price = [aDecoder decodeDoubleForKey:@"_current_price"];
        self.purchase_count = [aDecoder decodeIntForKey:@"_purchase_count"];
        self.purchase_deadline = [aDecoder decodeObjectForKey:@"_purchase_deadline"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [ aCoder encodeObject:_deal_id forKey:@"_deal_id"];
    [ aCoder encodeDouble:_list_price forKey:@"_list_price"];
    [ aCoder encodeObject:_title forKey:@"_title"];
    [ aCoder encodeObject:_image_url forKey:@"_image_url"];
    [ aCoder encodeObject:_desc forKey:@"_desc"];
    [ aCoder encodeDouble:_current_price forKey:@"_current_price"];
    [ aCoder encodeInt:_purchase_count forKey:@"_purchase_count"];
    [ aCoder encodeObject:_purchase_deadline forKey:@"_purchase_deadline"];
}

@end
