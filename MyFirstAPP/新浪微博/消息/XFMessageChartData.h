//
//  XFMessageChartData.h
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/21.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFMessageChartData : NSObject
@property(nonatomic,strong)NSString *content;
@property(nonatomic)BOOL fromMe;
+(NSArray*)getChartData;
@end
