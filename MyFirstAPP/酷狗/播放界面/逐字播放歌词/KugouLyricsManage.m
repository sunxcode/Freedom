//
//  KugouLyricsManage.m
//  我的酷狗
//
//  Created by 薛超 on 16/8/29.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "KugouLyricsManage.h"
#import <Foundation/Foundation.h>

@implementation LyricsAndTime
- (id)initWithLyrics:(NSString *)lyric andTime:(NSString *)time{
    self = [super init];
    if (self) {
        _lyric = lyric;
        _myTime = time;
    }
    return self;
}

- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"%@  %@",_myTime,_lyric];
    return str;
}

- (BOOL)islater:(LyricsAndTime *)obj
{
    return [self.myTime compare: obj.myTime]>0;
}

@end

@implementation KugouLyricsManage

- (id)init
{
    self = [super init];
    if (self) {
        _arr = [[NSMutableArray alloc] init];
        _path = [[NSString alloc] init];
    }
    return self;
}

- (void)readFile
{
    
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    NSArray *arr = [[NSArray alloc] init];
    
    arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
    //    for (id obj in arr) {
    //        NSLog(@"%@",obj);
    //    }
    //    NSLog(@"%@",arr);
    
    NSString *song = [arr[1] substringFromIndex:[arr[1]rangeOfString:@":"].location+1];
    NSString *singer = [arr[3] substringFromIndex:[arr[3]rangeOfString:@":"].location+1];
    _str = [NSString stringWithFormat:@"%@%@",song,singer];
    
    for (NSUInteger i = 9; i < [arr count]; i+=2) {
        NSUInteger x = 1;
        while ([arr[i+x] isEqualToString:@""]) {
            x += 2;
        }
        LyricsAndTime *obj = [[LyricsAndTime alloc] initWithLyrics:arr[i+x] andTime:arr[i]];
        [_arr addObject:obj];
    }
    
    //    for (id obj in _arr) {
    //        NSLog(@"%@",obj);
    //    }
    
}


- (void)sort
{
    [_arr sortUsingSelector:@selector(islater:)];
    
    //    for (id obj in _arr) {
    //        NSLog(@"%@",obj);
    //    }
}

- (void)play
{
    NSLog(@"%@",_str);
    float temp = 0;
    for (id obj in _arr) {
        NSLog(@"%@",obj);
        float x = [[obj myTime] intValue]*60 + [[[obj myTime] substringFromIndex:3] floatValue];
        sleep(x-temp);
        temp = x;
    }
}

@end
