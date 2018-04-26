//  TLDBGroupStore.h
//  Freedom
//  Created by Super on 16/4/17.
#import "TLDBBaseStore.h"
@interface TLDBGroupStore : TLDBBaseStore
- (BOOL)updateGroupsData:(NSArray *)groupData
                   forUid:(NSString *)uid;
- (BOOL)addGroup:(TLGroup *)group forUid:(NSString *)uid;
- (NSMutableArray *)groupsDataByUid:(NSString *)uid;
- (BOOL)deleteGroupByGid:(NSString *)gid forUid:(NSString *)uid;
@end
