//
//  KugouTools.h
//  我的酷狗
//
//  Created by 薛超 on 16/8/29.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface KugouTools : NSObject

// 存储上一次播放歌曲的信息
@property (nonatomic,strong) MPMediaItem *mediaItem;
@end
