
#import <UIKit/UIKit.h>
#import "Utility.h"
#import "RHMethods.h"
#import "Foundation.h"
#import "NSDictionary+expanded.h"
@interface BaseViewController : UIViewController
@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) id  userInfo;
@property (nonatomic,strong) id  otherInfo;
@property (nonatomic,strong) NSString *strBack;
@property (nonatomic,assign) BOOL  hideTabbar;
@property (nonatomic,strong) UIButton *navleftButton;
@property (nonatomic,strong) UIButton *navrightButton;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)rootButtonClicked:(id)sender;
- (IBAction)backByButtonTagNavClicked:(UIButton*)sender;

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
-(UIView *)navbarTitle:(NSString *)title NavBGColor:(UIColor *)color NavBGImage:(NSString *)image hiddenLine:(BOOL)bLine;
- (UIView*)navbarTitle:(NSString*)title;
- (UIButton*)leftButton:(NSString*)title image:(NSString*)image sel:(SEL)sel;
- (UIButton*)rightButton:(NSString*)title image:(NSString*)image sel:(SEL)sel;
@end
