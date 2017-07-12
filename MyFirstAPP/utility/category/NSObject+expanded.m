

#import "NSObject+expanded.h"
#import "AppDelegate.h"
#import "WeixinData.h"

#import <objc/message.h>
#import <objc/runtime.h>
@implementation NSObject (expanded)
-(AppDelegate *)getAPPDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication]delegate];
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
- (void)setValues:(NSDictionary *)values
{
    Class c = [self class];
    
    while (c) {
        // 1.获得所有的成员变量
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        
        for (int i = 0; i<outCount; i++) {
            Ivar ivar = ivars[i];
            
            // 2.属性名
            NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
            
            // 删除最前面的_
            [name replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
            
            // 3.取出属性值
            NSString *key = name;
            //DLog(@"%@",key);
            if ([key isEqualToString:@"desc"]) {
                key = @"description";
            }
            if ([key isEqualToString:@"ID"]) {
                key = @"id";
            }
            id value = values[key];
            if (!value) continue;
            
            // 4.SEL
            // 首字母
            NSString *cap = [name substringToIndex:1];
            // 变大写
            cap = cap.uppercaseString;
            // 将大写字母调换掉原首字母
            [name replaceCharactersInRange:NSMakeRange(0, 1) withString:cap];
            // 拼接set
            [name insertString:@"set" atIndex:0];
            // 拼接冒号:
            [name appendString:@":"];
            SEL selector = NSSelectorFromString(name);
            
            // 5.属性类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            
            if ([type hasPrefix:@"@"]) { // 对象类型
                objc_msgSend(self, selector, value);
            } else  { // 非对象类型
                if ([type isEqualToString:@"d"]) {
                    objc_msgSend(self, selector, [value doubleValue]);
                } else if ([type isEqualToString:@"f"]) {
                    objc_msgSend(self, selector, [value floatValue]);
                } else if ([type isEqualToString:@"i"]) {
                    objc_msgSend(self, selector, [value intValue]);
                }  else {
                    objc_msgSend(self, selector, [value longLongValue]);
                }
            }
        }
        
        c = class_getSuperclass(c);
    }
}

@end
