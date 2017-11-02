//
//  XFMessageChartViewController.m
//  Created by 薛超 on 16/8/21.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "XFMessageChartViewController.h"
#import "XFMessageChartData.h"
@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation MessageCell

@end
@interface XFMessageChartViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomlayoutConstraint;
@property(nonatomic,strong)NSMutableArray *allMessage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation XFMessageChartViewController
-(NSMutableArray *)allMessage{
    if(!_allMessage){
        _allMessage = [[XFMessageChartData getChartData]mutableCopy];
    }return _allMessage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //为了让tableView自适应高度，需要设置如下两个属性
    self.tableView.estimatedRowHeight=70;//预估值
    self.tableView.rowHeight=UITableViewAutomaticDimension;//由约束挤出来多大，行高就是多少。
    //设置tableView的内边距，使得内容向下错64个点。再到设置面板设置线为无，选中为no。
    // self.tableView.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    
}


//在view即将显示时添加对系统发出的键盘通知的监听。
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //为当前控制器注册键盘弹起和关闭通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OpenKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    
}


//在view即将消失时取消键盘通知的监听。
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

-(void)OpenKeyBoard:(NSNotification*)notification{
    //读取弹起的键盘的高度
    CGFloat keyboardHeight=[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.bottomlayoutConstraint.constant=keyboardHeight;
    //读取动画时长
    CGFloat duration=[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]floatValue];
    //读取动画种类
    NSInteger option=[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    [UIView animateWithDuration:duration
                          delay:0 options:option animations:^{
                              [self.view layoutIfNeeded];
                              NSLog(@"%@",notification.userInfo);
                              [self scrollToTableViewLastRow];
                          } completion:nil];
    
}
-(void)closeKeyboard:(NSNotification*)notification{
    //读取动画的时长
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //读取动画的种类
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    //修改底部输入视图的bottom约束
    self.bottomlayoutConstraint.constant=0;
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
    
}

- (IBAction)clickReturnKey:(UITextField *)sender {//点击右下角返回键，发消息，手键盘。
    //构建message对象
    NSString *newContent=self.textField.text;
    if(newContent.length==0){
        return;
    }
    XFMessageChartData *newMessage=[[XFMessageChartData alloc]init];
    newMessage.content=newContent;
    newMessage.fromMe=YES;
    
    
    //将新的message保存到模型
    [self.allMessage addObject:newMessage];
    self.textField.text=@"";
    
    //局部刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.allMessage.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}
//控制表视图滚动到最底部
-(void)scrollToTableViewLastRow{
    NSIndexPath *lastIndexPath=[NSIndexPath indexPathForRow:self.allMessage.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    //界面显示后，表格已经生成了，在滚动到底部
    [super viewDidAppear:animated];
    [self scrollToTableViewLastRow];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allMessage.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    XFMessageChartData *mssg=self.allMessage[indexPath.row];
    //显示内容
    cell.contentLabel.text=mssg.content;
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 90;
//}
@end
