//  TLUserGroup.h
//  Freedom
//  Created by Super on 16/1/26.
#import <Foundation/Foundation.h>
#import "TLUser.h"
@interface TLUserGroup : NSObject
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, assign, readonly) NSInteger count;
- (id) initWithGroupName:(NSString *)groupName users:(NSMutableArray *)users;
- (void)addObject:(id)anObject;
- (id)objectAtIndex:(NSUInteger)index;
@end
