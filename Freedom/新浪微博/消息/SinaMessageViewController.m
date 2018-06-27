//  XFMessageViewController.m
//  Freedom
//  Created by Super on 15/9/13.
#import "SinaMessageViewController.h"
@interface SinaMessageViewController ()
@property(nonatomic,strong) UISearchBar *searchBar;
@end
@implementation SinaMessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.frameWidth = APPW;
    _searchBar.frameHeight = 40;
    _searchBar.placeholder = @"大家都在搜：男模遭趴光";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH - TopHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    if(indexPath.row==0){
        UITableViewCell *d = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [d.contentView addSubview:self.searchBar];
        return d;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"微博小秘书%ld",(long)indexPath.row];
    cell.detailTextLabel.text = @"今晚我想去你那里，等着我。详情请点击查看！";
    cell.imageView.image = [UIImage imageNamed:@"movie"];
    return cell;
}
@end
