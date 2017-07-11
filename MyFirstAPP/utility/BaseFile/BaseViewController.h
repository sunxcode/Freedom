
#import <UIKit/UIKit.h>
#import "Utility.h"
#import "RHMethods.h"
#import "Foundation.h"
#import "NSDictionary+expanded.h"
#import "TotalData.h"
#import "AppDelegate.h"
#import "CKRadialMenu.h"
@interface BaseViewController : UIViewController<CKRadialMenuDelegate>
@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) id  userInfo;
@property (nonatomic,strong) id  otherInfo;
@property (nonatomic,strong) NSString *strBack;
@property (nonatomic,assign) BOOL  hideTabbar;
@property (nonatomic,strong) UIButton *navleftButton;
@property (nonatomic,strong) UIButton *navrightButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong)CKRadialMenu* radialView;
- (void)readData;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)rootButtonClicked:(id)sender;
- (IBAction)backByButtonTagNavClicked:(UIButton*)sender;
- (void)addFloatView;
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info;
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title;
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other;
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBar:(BOOL)abool;

- (void)popController:(NSString*)controller withSel:(SEL)sel withObj:(id)info;
- (CGFloat)heightForLabel:(CGFloat)_width font:(UIFont*)_font text:(NSString*)_text floatLine:(CGFloat)_aLine;
- (CGFloat)heightForTextView:(CGFloat)_width font:(UIFont*)_font text:(NSString*)_text floatLine:(CGFloat)_aLine;

- (NSString*)navTitle;
- (UIButton*)backButton;
// updateDefaultNavView: 和navbarTitle： 不能同时存在
-(void)updateDefaultNavView:(NSString *)strTitle;
- (UIView*)navbarTitle:(NSString*)title;
-(UIView *)navbarTitle:(NSString *)title titleView:(UIView*)titleV titleFrame:(CGRect)frame NavBGColor:(UIColor *)color NavBGImage:(NSString *)image hiddenLine:(BOOL)bLine;
- (UIButton*)leftButton:(CGRect)frame title:(NSString*)title image:(NSString*)image round:(BOOL)round sel:(SEL)sel;
- (UIButton*)rightButton:(CGRect)frame title:(NSString*)title image:(NSString*)image round:(BOOL)round sel:(SEL)sel;
-(void)presentStoryboardWithStoryboardName:(NSString*)story andViewIdentifier:(NSString*)identifier;
-(void)showStoryboardWithStoryboardName:(NSString*)story andViewIdentifier:(NSString*)identifier;
+ (BaseViewController *) sharedViewController;
@end
