#import <UIKit/UIKit.h>
#import <XCategory/NSDictionary+expanded.h>
#import "CKRadialMenu.h"
@interface BaseTableViewOCCell : UITableViewCell
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UIImageView *picV;
@property(nonatomic,strong)UIView      *line;
@property(nonatomic,strong)UILabel     *title;
@property(nonatomic,strong)UILabel     *script;
+(id) getInstance;
+(NSString*)getTableCellIdentifier;
-(void)initUI;
-(void)setDataWithDict:(NSDictionary*)dict;
@end
@interface BaseCollectionViewOCCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UIImageView *picV;
@property(nonatomic,strong)UIView      *line;
@property(nonatomic,strong)UILabel     *title;
@property(nonatomic,strong)UILabel     *script;
+(NSString*)getTableCellIdentifier;
-(void)initUI;
-(void)setCollectionDataWithDic:(NSDictionary*)dict;
@end
@interface BaseOCViewController : UIViewController<CKRadialMenuDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) id  userInfo;
@property (nonatomic,strong) id  otherInfo;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;
- (void)showRadialMenu;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong)CKRadialMenu* radialView;
- (BaseOCViewController*)pushController:(Class)controller withInfo:(id)info;
- (BaseOCViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other;
- (BaseOCViewController*)pushController:(BaseOCViewController*)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBarHid:(BOOL)abool;
@end
