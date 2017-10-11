//
//  NSMutableArray+convenience.h
//
//  Created by in 't Veen Tjeerd on 5/10/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (add)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
- (void)addSafeObject:(id)key;
@end