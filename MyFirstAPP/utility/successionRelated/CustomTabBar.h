

#import <UIKit/UIKit.h>
@interface CustomTabBar : UITabBarController
+(id)creatCustomTabBarWithDictionary:(NSArray*)dict;
- (void)selectedTabIndex:(NSInteger)index;
@end

