//
//  JuheUserViewController.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/9/5.
//  Copyright © 2016年 薛超. All rights reserved.
//
#import "JuheUserViewController.h"
@interface JuheUserViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIView *headerView;
    UIScrollView *scrollerview;
    UITableView *tableView1;
    UIImageView *icon;
    UIButton *monybtn;
    NSArray *titlearr;
    NSArray *titlearr1;
    NSArray *imagearr;
    UILabel *nicknameLable;
    UIImagePickerController *ipc;
    UILabel*phonlb;
}
@end

@implementation JuheUserViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"个人中心"];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getnetdata];
    [self getuserinfo];
    [icon imageWithURL:[[Utility Share] userLogo] useProgress:NO useActivity:NO];
}

-(void)initUI{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame  = CGRectMake(kScreenWidth-90,kVersion7?0:0, 90, 40);
    [button setImage:[UIImage imageNamed:@"memNav06"] forState:UIControlStateNormal];
    button.tag = 14;
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:button];
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - kTopHeight - 49) style:UITableViewStyleGrouped];
    tableView1.backgroundColor = [UIColor whiteColor];
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, 110)];
    tableView1.tableHeaderView = headerView;
    [self.view addSubview:tableView1];
    
    icon = [[UIImageView alloc]initWithFrame:CGRectMake(2*Boardseperad, 15, 80, 80)];
    icon.layer.cornerRadius = H(icon)/2.0;
    icon.layer.masksToBounds = YES;
    icon.userInteractionEnabled = YES;
    [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconAction)]];
    [headerView addSubview:icon];
    
    UIButton *editebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editebtn.frame = CGRectMake(XW(icon) + 100, 0, 80, 80);
    editebtn.center = CGPointMake(editebtn.center.x, icon.center.y);
    [editebtn setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
    [editebtn addTarget:self action:@selector(editbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:editebtn];
    
    nicknameLable = [RHMethods labelWithFrame:CGRectMake(XW(icon)+20, 15, 80, 20) font:fontTitle color:blacktextcolor text:@""];
    //    nicknameLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nicknameLable];
    
    phonlb = [RHMethods labelWithFrame:CGRectMake(XW(icon)+20, YH(nicknameLable) + 10, 100, 20) font:fontTitle color:blacktextcolor text:@""];
    //    phonlb.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:phonlb];
    
    monybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    monybtn.frame = CGRectMake(XW(icon)+20, YH(phonlb)+10, kScreenWidth-140, 20);
    [monybtn setImage:[UIImage imageNamed:@"icon_jifen"] forState:UIControlStateNormal];
    monybtn.titleLabel.font = Font(13);
    [monybtn setTitleColor:gradtextcolor forState:UIControlStateNormal];
    [monybtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    monybtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:monybtn];
    titlearr = @[@"我的消息",@"邀请好友",@"我的提问",@"修改密码"];
    imagearr = @[@"memNav06",@"memNav07",@"wdtw",@"memNav08"];
    
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark - tableviewdelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch (indexPath.row) {
//        case 0:
//            //我的消息
//            [self pushController:[MyMSGViewController class] withInfo:nil withTitle:titlearr[indexPath.row]];
//            break;
//        case 1:
//            //邀请好友
//            [self pushController:[fendViewController class] withInfo:nil withTitle:titlearr[indexPath.row] withOther:nil];
//            break;
//        case 2:
//            //我的提问
//            [self pushController:[MyquestionViewController class] withInfo:nil withTitle:titlearr[indexPath.row] withOther:nil];
//            break;
//        case 3:
//            //修改密码
//            [self pushController:[ChagePswViewController class] withInfo:nil withTitle:titlearr[indexPath.row] withOther:nil];
//            break;
//        default:break;
//    }
//    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 190;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    titlearr1 = @[@"我的投资",@"我的钱袋",@"我的预约",@"交易大厅",@"我的收藏",@"我的购物车",@"我的订单",@"收货地址"];
    NSArray *imagearr1 = @[@"memNav01",@"memNav02",@"收藏3",@"memNav04",@"memNav03",@"购物车",@"我的订单",@"address"];
    CGFloat starx = 0.0;
    CGFloat stary = 0.0;
    CGFloat height = 0.0;
    CGFloat width = (kScreenWidth - 1)/4.0;
    for (int i = 0; i < titlearr1.count; i++) {
        UIButton *btn = [self createcustombtn:CGRectMake(starx, stary, width, width) withimage:imagearr1[i] withtitle:titlearr1[i]];
        btn.tag = 10 + i;
        [footView addSubview:btn];
        height = YH(btn);
        starx = XW(btn) + 0.5;
        if ((i + 1) % 4 == 0) {
            starx = 0.0;
            stary = YH(btn)+5;
        }
    }
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth , 1)];
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,190, kScreenWidth , 1)];
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,95, kScreenWidth , 1)];
    line.image =line2.image = line1.image = [UIImage imageNamed:@"userLine"];
    [footView addSubview:line];[footView addSubview:line1];[footView addSubview:line2];
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titlearr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    UIButton *quitebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitebtn.frame = CGRectMake((kScreenWidth - 100)/2.0,  2*Boardseperad, 100, 30);
    [quitebtn setTitle:@"退出登录" forState:UIControlStateNormal];
    quitebtn.titleLabel.font = fontTitle;
    [quitebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quitebtn.layer.cornerRadius = 5;
    quitebtn.layer.borderColor = [RGBACOLOR(242, 82, 32, 1) CGColor];
    quitebtn.backgroundColor = RGBACOLOR(242, 82, 32, 1);
    [quitebtn addTarget:self action:@selector(quitebtnAction) forControlEvents:UIControlEventTouchUpInside];
    quitebtn.layer.borderWidth = 1;
    [vie addSubview:quitebtn];
    UILabel *banbenhao = [[UILabel alloc]initWithFrame:CGRectMake(X(quitebtn), YH(quitebtn), W(quitebtn), 20)];
    banbenhao.text =[NSString stringWithFormat:@"版本:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"MyappID"]];;
    banbenhao.font = fontnomal;
    banbenhao.textColor = gradcolor;
    banbenhao.textAlignment = NSTextAlignmentCenter;
    [vie addSubview:banbenhao];
    return vie;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0,54, kScreenWidth , 1)];
        line.image = [UIImage imageNamed:@"userLine"];
        [cell addSubview:line];
        
    }
    cell.imageView.image = [UIImage imageNamed:imagearr[indexPath.row]];
    cell.textLabel.text = titlearr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 55;
}
#pragma mark 以下不要动了
-(UIButton *)createcustombtn:(CGRect)frame withimage:(NSString *)imagestr withtitle:(NSString *)title{
    UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
    [butt addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    butt.frame = frame;
    UIImage *image = [UIImage imageNamed:imagestr];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake((W(butt) - image.size.width)/2.0, (H(butt) - image.size.height - 5 - 20)/2.0, image.size.width, image.size.height)];
    imageview.image = image;
    [butt addSubview:imageview];
    UILabel *titleLable = [RHMethods labelWithFrame:CGRectMake(0, YH(imageview) + 5, W(butt), 20) font:fontTitle color:blacktextcolor text:title];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [butt addSubview:titleLable];
    return butt;
}

#pragma mark - loaddata
-(void)getnetdata{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"uid" forKey:@"uid"];
    [dict setObject:@"token" forKey:@"token"];
    [NetEngine POST:@"" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"获取数据成功"];
//            NSString *pricestr = @"0";
//            if ([[[resData valueForKey:@"data"] valueForJSONKey:@"AcctBal"] notEmptyOrNull]) {
//                pricestr = [[resData valueForKey:@"data"] valueForJSONKey:@"AcctBal"];
//            }
            NSString *monystr =@"sdjkfsdfkdj";// [[resData valueForKey:@"data"] valueForJSONKey:@"AcctBal"];
            [monybtn setTitle:[NSString stringWithFormat:@"账户余额: ¥%@",monystr] forState:UIControlStateNormal];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:monybtn.currentTitle];
            [str addAttribute:NSForegroundColorAttributeName value:redcolor range:NSMakeRange(6,monystr.length + 1)];
            [monybtn setAttributedTitle:str forState:UIControlStateNormal];
            [self getuserinfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [monybtn setTitle:@"账户余额: ¥0.00" forState:UIControlStateNormal];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:monybtn.titleLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:redcolor range:NSMakeRange(6,5)];
        [monybtn setAttributedTitle:str forState:UIControlStateNormal];
        //            [SVProgressHUD showErrorWithStatus:[resData valueForJSONKey:@"info"]];

    }];
    
}

-(void)getuserinfo{
    NSDictionary *dict = @{@"uid":@"uid",@"token":@"thetoken"};
    [NetEngine POST:@"" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        nicknameLable.text = [[resData valueForKey:@"data"] valueForJSONKey:@"realname"];
//        if (![nicknameLable.text notEmptyOrNull]) {
//            nicknameLable.text = [[resData valueForKey:@"data"] valueForJSONKey:@"nickname"];
//        }
//        phonlb.text=[[resData valueForKey:@"data"] valueForJSONKey:@"mobile"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        nicknameLable.text = @"";
        phonlb.text=@"";
    }];
  
}

#pragma mark - Action
-(void)editbtnAction{
    
}

-(void)btnAction:(UIButton *)btn{
//    NSInteger tag = btn.tag - 10;
//    switch (tag) {
//        case 0:
//            //我的投资
//            [self pushController:[MyInvestViewController class] withInfo:nil withTitle:titlearr1[tag]];
//            break;
//        case 1:
//            //我的钱袋
//            [self pushController:[MyMonyViewController class] withInfo:nil withTitle:titlearr1[tag]];
//            break;
//        case 2:
//            //我的预约
//            [self pushController:[MakePointViewController class] withInfo:nil withTitle:titlearr1[tag]];
//            break;
//        case 3:
//            //筹码交易
//            [self pushController:[TradeViewController class] withInfo:nil withTitle:titlearr1[tag]];
//            break;
//        case 4:
//            //我的收藏
//            [self pushController:[MyShoucangViewController class] withInfo:nil withTitle:titlearr1[tag] withOther:nil];
//            break;
//        case 5:
//            //我的购物车
//            [self pushController:[MyShoppingCarViewController class] withInfo:nil withTitle:titlearr1[tag] withOther:nil];
//            break;
//        case 6:
//            //我的订单
//            [self pushController:[MyOrderViewController class] withInfo:@"来自中心" withTitle:titlearr1[tag] withOther:nil];
//            break;
//        case 7:
//            //我的地址
//            [self pushController:[MyAddressViewController class] withInfo:@"来自中心" withTitle:titlearr1[tag]];
//            break;
//        default:
//            break;
//    }
}

-(void)quitebtnAction{
    [[Utility Share] setUserAccount:@"12345678910"];
    [[Utility Share] setUserPwd:@"123456"];
    [[Utility Share] setUserToken:@"1"];
    [[Utility Share] setUserId:@"1"];
    
    [[Utility Share] saveUserInfoToDefault];
    [[Utility Share] readUserInfoFromDefault];
    [SVProgressHUD showSuccessWithStatus:@"退出登录成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[Utility Share] CustomTabBar_zk]selectedTabIndex:@"0"];
        [[Utility Share] loginWithAccount:[[Utility Share] userAccount] pwd:[[Utility Share] userPwd]];
    });
}

-(void)iconAction{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    action.tag = 200;
    [action showInView:[UIApplication sharedApplication].keyWindow];
}
#pragma mark UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!ipc) {
        ipc=[[UIImagePickerController alloc]init];
    }
    if (buttonIndex==0) {
        //打开相册
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置是否可编辑
        ipc.allowsEditing = YES;
        ipc.delegate=self;
        [self presentViewController:ipc animated:YES completion:^{
            if (kVersion7) {
                [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
            }
        }];
    }else if (buttonIndex==1){
        //判断当前相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){// 打开相机
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            //设置是否可编辑
            ipc.allowsEditing = YES;
            ipc.delegate=self;
            //打开
            [self presentViewController:ipc animated:YES completion:^{
            }];
        }else{
            //如果不可用
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"设备不可用..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [alert show];
        }
        
    }
    
}

#pragma mark pickerC
//设备协议
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    float t_w=image.size.width>640?640:image.size.width;
    float t_h= t_w/image.size.width * image.size.height;
    
    //处理图片
    UIImage *imageTmpeLogo=[self imageWithImageSimple:image scaledToSize:CGSizeMake(t_w, t_h)];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[Utility Share] userId] forKey:@"uid"];
    [dict setObject:[[Utility Share] userToken] forKey:@"token"];
    //imgpath
    //处理图片
    NSData *imgData=UIImageJPEGRepresentation(imageTmpeLogo, 1.0);
    //BDuserupdateavatar
    NSString *fileName = @"icon";
    //  确定需要上传的文件(假设选择本地的文件)
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"png"];
    NSDictionary *parameters = @{@"name":@"额外的请求参数"};
    [NetEngine POST:EDITEICON parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  appendPartWithFileURL   //  指定上传的文件
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  指定上传文件的原始文件名
         *  mimeType                //  指定商家文件的MIME类型
         */
        [formData appendPartWithFileURL:filePath name:@"file" fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:@"image/png" error:nil];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"修改头像成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[Utility Share]setUserLogo:[[responseObject valueForKey:@"data"] valueForJSONKey:@"pic"]];
            [[Utility Share] saveUserInfoToDefault];
            [[Utility Share] readUserInfoFromDefault];
            NSString *str = [[Utility Share] userLogo];
            [icon imageWithURL:[[Utility Share] userLogo] useProgress:NO useActivity:NO];
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         DLog(@"获取服务器响应出错");
    }];
  
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self dismissViewControllerAnimated:YES completion:^{
        if (kVersion7) {
            [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        if (kVersion7) {
            [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
        }
    }];
}
//压缩图片
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
