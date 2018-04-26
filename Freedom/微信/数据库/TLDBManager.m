//  TLDBManager.m
//  Freedom
// Created by Super
#import "TLDBManager.h"
#import "TLUserHelper.h"
static TLDBManager *manager;
@implementation TLDBManager
+ (TLDBManager *)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSString *userID = [TLUserHelper sharedHelper].userID;
        manager = [[TLDBManager alloc] initWithUserID:userID];
    });
    return manager;
}
- (id)initWithUserID:(NSString *)userID{
    if (self = [super init]) {
        NSString *commonQueuePath = [NSFileManager pathDBCommon];
        self.commonQueue = [FMDatabaseQueue databaseQueueWithPath:commonQueuePath];
        NSString *messageQueuePath = [NSFileManager pathDBMessage];
        self.messageQueue = [FMDatabaseQueue databaseQueueWithPath:messageQueuePath];
    }
    return self;
}
- (id)init{
    DLog(@"TLDBManager：请使用 initWithUserID: 方法初始化");
    return nil;
}
@end
