//  TLConversationViewController.h
//  Freedom
// Created by Super
#import "WechatTableViewController.h"
#import "WechatFriendSearchViewController.h"
#import "TLChatViewController.h"
#define     HEIGHT_CONVERSATION_CELL        64.0f
#import "TLMessageManager.h"
#import "WechartModes.h"
@class WechatAddMenuView;
@protocol TLAddMenuViewDelegate <NSObject>
- (void)addMenuView:(WechatAddMenuView *)addMenuView didSelectedItem:(TLAddMenuItem *)item;
@end
@interface WechatAddMenuView : UIView
@property (nonatomic, assign) id<TLAddMenuViewDelegate>delegate;
/*显示AddMenu
 *
 *  @param view 父View*/
- (void)showInView:(UIView *)view;
/*是否正在显示*/
- (BOOL)isShow;
/*隐藏*/
- (void)dismiss;
@end
@interface TLConversationViewController : WechatTableViewController<TLMessageManagerConvVCDelegate, UISearchBarDelegate, TLAddMenuViewDelegate>
@property (nonatomic, strong) WechatFriendSearchViewController *searchVC;
@property (nonatomic, strong) NSMutableArray *data;
- (void)registerCellClass;
@end
