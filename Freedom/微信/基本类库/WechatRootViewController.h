//  TLRootViewController.h
//  Freedom
// Created by Super
#import "TLTabBarController.h"

@interface TLNavigationController : UINavigationController
@end
@interface WechatRootViewController : TLTabBarController
+ (WechatRootViewController *) sharedRootViewController;
/*获取tabbarController的第Index个VC（不是navController）
 *
 *  @return navController的rootVC*/
- (id)childViewControllerAtIndex:(NSUInteger)index;
@end
