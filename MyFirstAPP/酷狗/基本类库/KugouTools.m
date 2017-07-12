//
//  KugouTools.m
//  我的酷狗
//
//  Created by 薛超 on 16/8/29.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "KugouTools.h"

@implementation KugouTools

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.mediaItem forKey:@"mediaItem"];
}
- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        // 读取文件的内容
        self.mediaItem = [decoder decodeObjectForKey:@"mediaItem"];
    }return self;
}
@end
