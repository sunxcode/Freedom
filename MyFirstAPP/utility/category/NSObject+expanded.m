

#import "NSObject+expanded.h"
#import "AppDelegate.h"
#import "WeixinData.h"
@implementation NSObject (expanded)
-(AppDelegate *)getAPPDelegate{
    return [UIApplication sharedApplication].delegate;
}
- (void)performSelector:(SEL)aSelector withBool:(BOOL)aValue
{
    BOOL myBoolValue = aValue; // or NO
    
    NSMethodSignature* signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: signature];
    [invocation setTarget: self];
    [invocation setSelector: aSelector];
    [invocation setArgument: &myBoolValue atIndex: 2];
    [invocation invoke];
}

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    for (id object in objects) {
        [invocation setArgument:(__bridge void *)(object) atIndex:++i];
    }
    [invocation invoke];
    
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}

- (id)performSelector:(SEL)aSelector withParameters:(void *)firstParameter, ... {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSUInteger length = [signature numberOfArguments];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    [invocation setArgument:&firstParameter atIndex:2];
    va_list arg_ptr;
    va_start(arg_ptr, firstParameter);
    for (NSUInteger i = 3; i < length; ++i) {
        void *parameter = va_arg(arg_ptr, void *);
        [invocation setArgument:&parameter atIndex:i];
    }
    va_end(arg_ptr);
    
    [invocation invoke];
    
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}
#pragma mark 操作数据库
-(void)addCoreData{
    WeixinData *weixin =[NSEntityDescription insertNewObjectForEntityForName:@"WeixinData" inManagedObjectContext:[self getAPPDelegate].managedObjectContext];
    weixin.title = @"王五";
    [[self getAPPDelegate] saveContext];
}
-(void)deleteCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"WeixinData"];
    NSArray *persons = [[self getAPPDelegate].managedObjectContext executeFetchRequest:request error:nil];
    for (WeixinData *p in persons) {
        if ([p.title isEqualToString:@"王五"]) {
            [[self getAPPDelegate].managedObjectContext deleteObject:p];
            [[self getAPPDelegate] saveContext];
        }
    }
}
-(void)reviseCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"WeixinData"];
    NSArray *persons = [[self getAPPDelegate].managedObjectContext executeFetchRequest:request error:nil];
    for (WeixinData *p in persons) {
        if ([p.title isEqualToString:@"王五"]) {
            p.title = @"赵四";
            [[self getAPPDelegate] saveContext];
        }
    }
}
-(void)searchCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"WeixinData"];
    NSArray *persons = [[self getAPPDelegate].managedObjectContext executeFetchRequest:request error:nil];
    for (WeixinData *p in persons) {
        NSLog(@"%@",p.title);
    }
}
+ (NSString *)getFilePath:(NSString *)fileNameAndType
{
    NSString *szFilename = [fileNameAndType stringByDeletingPathExtension];
    NSString *szFileext = [fileNameAndType pathExtension];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:szFilename ofType:szFileext];
    
    return path;
}

@end
