//
//  XFMessageChartData.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/21.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "XFMessageChartData.h"

@implementation XFMessageChartData
+(NSArray *)getChartData{
    XFMessageChartData *m1=[[XFMessageChartData alloc]init];
    m1.content=@"你好啊，美女！约吗？❤️";
    m1.fromMe=YES;
    XFMessageChartData *m2=[[XFMessageChartData alloc]init];
    m2.content=@"约在哪里？你家我家还是如家？今天明天还是七天？/害羞";
    m2.fromMe=NO;
    XFMessageChartData *m3=[[XFMessageChartData alloc]init];
    m3.content=@"那就来我家吧！👌！";
    m3.fromMe=YES;
    XFMessageChartData *m4=[[XFMessageChartData alloc]init];
    m4.content=@"好的！";
    m4.fromMe=NO;
    return @[m1,m2,m3,m4];
    
    
    
    
    
    
    
    
}

@end
