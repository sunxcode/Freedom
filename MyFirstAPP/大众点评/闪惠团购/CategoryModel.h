//
//  CategoryModel.h
//  XTuan
//
//  Created by dengwei on 15/8/15.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseModel.h"

@interface CategoryModel : BaseModel

@property(nonatomic, copy)NSString *icon;
@property(nonatomic, strong)NSArray *subcategories;

@end
