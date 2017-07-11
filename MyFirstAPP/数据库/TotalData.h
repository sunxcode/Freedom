//
//  TotalData.h
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/12.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TotalData : NSManagedObject
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *icon;
@end

NS_ASSUME_NONNULL_END
