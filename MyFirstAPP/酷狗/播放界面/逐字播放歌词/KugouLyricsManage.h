//
//  KugouLyricsManage.h
//  我的酷狗
//
//  Created by 薛超 on 16/8/29.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LyricsAndTime : NSObject
@property NSString *lyric;
@property NSString *myTime;
- (id)initWithLyrics:(NSString *)lyric andTime:(NSString *)time;

- (NSString *)description;

- (BOOL)islater:(LyricsAndTime *)obj;

@end

@interface KugouLyricsManage : NSObject
@property NSMutableArray *arr;
@property NSString *str;
@property NSString *path;

- (id)init;

- (void)readFile;

- (void)sort;

- (void)play;

@end
