
#import <Foundation/Foundation.h>
@class AppDelegate;
@interface NSObject (expanded)
//perfrom for bool
- (void)performSelector:(SEL)aSelector withBool:(BOOL)aValue;
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;
- (id)performSelector:(SEL)aSelector withParameters:(void *)firstParameter, ...;
-(void)addCoreData;
-(void)deleteCoreData;
-(void)reviseCoreData;
-(void)searchCoreData;
-(AppDelegate*)getAPPDelegate;

@end
