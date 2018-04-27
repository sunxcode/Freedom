//  SDAssetsTableViewController.m
//  Freedom
//  Created by Super on 15-6-4.

#import "SDAssetsTableViewController.h"
#import "SDAssetsTableViewControllerCellModel.h"
#import "SDYuEBaoTableViewController.h"
#import "SDAssetsTableViewControllerCellModel.h"
#import "SDBasicTableViewController.h"
@interface SDAssetsTableViewControllerCell : SDBasicTableViewControllerCell
@end
@implementation SDAssetsTableViewControllerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }return self;
}
- (void)setModel:(NSObject *)model{
    [super setModel:model];
    SDAssetsTableViewControllerCellModel *cellModel = (SDAssetsTableViewControllerCellModel *)model;
    self.textLabel.text = cellModel.title;
    self.imageView.image = [UIImage imageNamed:cellModel.iconImageName];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
@end
@implementation SDAssetsTableViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.sectionsNumber = 3;
    self.cellClass = [SDAssetsTableViewControllerCell class];
    [self setupModel];
    
    UIView *header = [[UIView alloc] init];
    
    self.tableView.tableHeaderView = header;
    
}
- (void)setupModel{
    // section 0 的model
    SDAssetsTableViewControllerCellModel *model01 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"余额宝" iconImageName:@"20000032Icon" destinationControllerClass:[SDYuEBaoTableViewController class]];
    SDAssetsTableViewControllerCellModel *model02 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"招财宝" iconImageName:@"20000059Icon" destinationControllerClass:[SDBasicTableViewController class]];
    
    SDAssetsTableViewControllerCellModel *model03 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"娱乐宝" iconImageName:@"20000077Icon" destinationControllerClass:[SDBasicTableViewController class]];
    
    // section 1 的model
    SDAssetsTableViewControllerCellModel *model11 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"芝麻信用分" iconImageName:@"20000118Icon" destinationControllerClass:[SDBasicTableViewController class]];
    
    SDAssetsTableViewControllerCellModel *model12 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"随身贷" iconImageName:@"20000180Icon" destinationControllerClass:[SDBasicTableViewController class]];
    
    SDAssetsTableViewControllerCellModel *model13 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"我的保障" iconImageName:@"20000110Icon" destinationControllerClass:[SDBasicTableViewController class]];
    
    // section 2 的model
    SDAssetsTableViewControllerCellModel *model21 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"爱心捐赠" iconImageName:@"09999978Icon" destinationControllerClass:[SDBasicTableViewController class]];
    self.dataArray = @[@[model01, model02, model03],
                       @[model11, model12, model13],
                       @[model21]
                       ];
}
#pragma mark - delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SDAssetsTableViewControllerCellModel *model = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
    UIViewController *vc = [[model.destinationControllerClass alloc] init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (section == self.dataArray.count - 1) ? 10 : 0;
}
@end
