//
//  WeixinData.h
//  
//
//  Created by 薛超 on 16/8/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeixinData : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSData *data;
@end

NS_ASSUME_NONNULL_END

