//  TLDBManager.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface TLDBManager : NSObject
/*DB队列（除IM相关）*/
@property (nonatomic, strong) FMDatabaseQueue *commonQueue;
/*与IM相关的DB队列*/
@property (nonatomic, strong) FMDatabaseQueue *messageQueue;
+ (TLDBManager *)sharedInstance;
@end
