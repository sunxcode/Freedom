//
//  BooksViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/18.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BooksViewController.h"
#import "WXViewController.h"
#import "E_ScrollViewController.h"
#import "ContantHead.h"
@interface BooksViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_dataSourceArr;
}
@end

@implementation BooksViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"书籍📚阅读";
    _dataSourceArr = @[@"阅读器",@"朋友圈"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor yellowColor];
    UITableView *mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [_dataSourceArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BooksTableViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_dataSourceArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
        [self presentViewController:loginvctrl animated:NO completion:NULL];
    }else{
        WXViewController *wxVc = [WXViewController new];
        [self presentViewController:wxVc animated:YES completion:NULL];
    }
}

@end
