//  TLDBFriendStore.h
//  Freedom
//  Created by Super on 16/3/22.
#import "TLDBBaseStore.h"
#import "TLUser.h"
@interface TLDBFriendStore : TLDBBaseStore
- (BOOL)updateFriendsData:(NSArray *)friendData
                   forUid:(NSString *)uid;
- (BOOL)addFriend:(TLUser *)user forUid:(NSString *)uid;
- (NSMutableArray *)friendsDataByUid:(NSString *)uid;
- (BOOL)deleteFriendByFid:(NSString *)fid forUid:(NSString *)uid;
@end
