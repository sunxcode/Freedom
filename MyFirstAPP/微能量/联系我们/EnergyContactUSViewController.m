//
//  EnergyContactUSViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/9/5.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "EnergyContactUSViewController.h"
#import "EnergyContactDetailViewController.h"
@interface EnergyContactUSViewCell:UITableViewCell
-(void)setdatawithdict:(NSDictionary *)dict;
@end
@implementation EnergyContactUSViewCell{
    UILabel *titleLable;
    UIImageView *intoview;
    UIImageView *line;
    UIImageView *icon;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    intoview = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - Boardseperad - 10, (60 - 20)/2.0, 10, 20)];
    intoview.contentMode = UIViewContentModeScaleAspectFill;
    intoview.clipsToBounds = YES;
    intoview.image = [UIImage imageNamed:@"icon_jt"];
    [self addSubview:intoview];
    
    icon = [[UIImageView alloc]initWithFrame:CGRectMake(Boardseperad, Boardseperad, 50, 40)];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:icon];
    titleLable = [[UILabel alloc]initWithFrame:CGRectMake(XW(icon)+10, (60 - 20)/2.0, X(intoview) - 2*Boardseperad, 20)];
    titleLable.font = fontTitle;
    titleLable.textColor = blacktextcolor;
    [self addSubview:titleLable];
    
    line = [[UIImageView alloc]initWithFrame:CGRectMake(Boardseperad, 59, kScreenWidth - 2*Boardseperad, 1)];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.clipsToBounds = YES;
    line.image = [UIImage imageNamed:@"userLine"];
    [self addSubview:line];
}

-(void)setdatawithdict:(NSDictionary *)dict{
    titleLable.text = [dict valueForJSONKey:@"name"];
    [icon imageWithURL:[NSString stringWithFormat:@"/upload/%@",[dict valueForJSONStrKey:@"img"]] useProgress:NO useActivity:NO];
}

@end
@interface EnergyContactUSViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *refTableView;
    UILabel *label;
}
@end

@implementation EnergyContactUSViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadUI];
}
-(void)loadData{
    
}
-(void)loadUI{
    refTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, W(self.view), kScreenHeight - 64) style:UITableViewStylePlain];
    refTableView.backgroundColor = RGBCOLOR(246, 246, 246);
    refTableView.delegate = self;
    refTableView.dataSource = self;
    [self.view addSubview:refTableView];
    refTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
}

#pragma mark - tableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EnergyContactUSViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    if (cell == nil) {
        cell = [[EnergyContactUSViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setdatawithdict:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = nil;
    [self pushController:[EnergyContactDetailViewController class] withInfo:nil withTitle:[dict valueForJSONKey:@"name"] withOther:dict];
    
}

@end


