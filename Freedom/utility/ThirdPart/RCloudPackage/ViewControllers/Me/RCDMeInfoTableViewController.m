//
//  RCDMeInfoTableViewController.m
//  RCloudMessage
//
//  Created by litao on 15/11/4.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import "RCDMeInfoTableViewController.h"

#import "MBProgressHUD.h"
#import "RCDChangePasswordViewController.h"
#import "RCDChatViewController.h"
#import "RCDEditUserNameViewController.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDBaseSettingTableViewCell.h"

@interface RCDMeInfoTableViewController () {
    NSData *data;
    UIImage *image;
    MBProgressHUD *hud;
}

@end

@implementation RCDMeInfoTableViewController
- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.tableFooterView = [UIView new];
  self.tabBarController.navigationItem.rightBarButtonItem = nil;
  self.tabBarController.navigationController.navigationBar.tintColor =
      [UIColor whiteColor];
  self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xf0f0f6];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  self.navigationItem.title = @"个人信息";
    UIButton *buttonItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 6, 87, 23)];
    [buttonItem setImage:[UIImage imageNamed:@"navigator_btn_back"] forState:UIControlStateNormal];
    [buttonItem setTitle:@"我" forState:UIControlStateNormal];
    [buttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonItem addTarget:self action:@selector(cilckBackBtn:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonItem];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableCellWithIdentifier = @"RCDBaseSettingTableViewCell";
  RCDBaseSettingTableViewCell *cell = [self.tableView
                                       dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
  if (cell == nil) {
    cell = [[RCDBaseSettingTableViewCell alloc] init];
  }
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0: {
          NSString *portraitUrl = [defaults stringForKey:@"userPortraitUri"];
          if ([portraitUrl isEqualToString:@""]) {
            portraitUrl = [FreedomTools defaultUserPortrait:[RCIM sharedRCIM].currentUserInfo];
          }
          [cell setImageView:cell.rightImageView
                    ImageStr:portraitUrl
                   imageSize:CGSizeMake(65, 65)
                 LeftOrRight:1];
          cell.rightImageCornerRadius = 5.f;
          cell.leftLabel.text = @"头像";
          return cell;
        }
          break;
          
        case 1: {
          [cell setCellStyle:DefaultStyle_RightLabel];
          cell.leftLabel.text = @"昵称";
          cell.rightLabel.text = [defaults stringForKey:@"userNickName"];
          return cell;
        }
          break;
          
        case 2: {
          [cell setCellStyle:DefaultStyle_RightLabel_WithoutRightArrow];
          cell.leftLabel.text = @"手机号";
          cell.rightLabel.text = [defaults stringForKey:@"userName"];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
        }
          break;
        default:
          break;
      }
    }
      break;
      
    default:
      break;
  }
  
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height;
  switch (indexPath.section) {
    case 0:{
      switch (indexPath.row) {
        case 0:
          height = 88.f;
          break;
          
        default:
          height = 44.f;
          break;
      }
    }
      break;
      
    default:
      break;
  }
  return height;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 15.f;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 取消选中
  
  switch (indexPath.row) {
    case 0: {
      if ([self dealWithNetworkStatus]) {
        [self changePortrait];
      }
    }
      break;
      
    case 1: {
      if ([self dealWithNetworkStatus]) {
        RCDEditUserNameViewController *vc = [[RCDEditUserNameViewController alloc] init];
        [self.navigationController pushViewController:vc
                                             animated:YES];
      }
    }
      break;
    default:
      break;
  }
}

- (void)changePortrait {
  UIActionSheet *actionSheet =
      [[UIActionSheet alloc] initWithTitle:nil
                                  delegate:self
                         cancelButtonTitle:@"取消"
                    destructiveButtonTitle:@"拍照"
                         otherButtonTitles:@"我的相册", nil];
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    switch (buttonIndex) {
      case 0:
        if ([UIImagePickerController
             isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
          picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
          NSLog(@"模拟器无法连接相机");
        }
        [self presentViewController:picker animated:YES completion:nil];
        break;
        
      case 1:
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        break;
        
      default:
        break;
  }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [UIApplication sharedApplication].statusBarHidden = NO;

  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

  
  if ([mediaType isEqual:@"public.image"]) {
    //获取原图
    UIImage *originImage =
        [info objectForKey:UIImagePickerControllerOriginalImage];
    //获取截取区域
     CGRect captureRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
    //获取截取区域的图像
    UIImage *captureImage = [self getSubImage:originImage Rect:captureRect imageOrientation:originImage.imageOrientation];
    UIImage *scaleImage = [self scaleImage:captureImage toScale:0.8];
    data = UIImageJPEGRepresentation(scaleImage, 0.00001);
  }
  image = [UIImage imageWithData:data];
  [self dismissViewControllerAnimated:YES completion:nil];
  hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.color = [UIColor colorWithRGBHex:0x343637];
  hud.labelText = @"上传头像中...";
  [hud show:YES];

  [RCDHTTPTOOL uploadImageToQiNiu:[RCIM sharedRCIM].currentUserInfo.userId
      ImageData:data
      success:^(NSString *url) {
        [RCDHTTPTOOL
            setUserPortraitUri:url
                      complete:^(BOOL result) {
                        if (result == YES) {
                          [RCIM sharedRCIM].currentUserInfo.portraitUri = url;
                          RCUserInfo *userInfo =
                              [RCIM sharedRCIM].currentUserInfo;
                          userInfo.portraitUri = url;
                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                          [defaults setObject:url forKey:@"userPortraitUri"];
                          [defaults synchronize];
                          [[RCIM sharedRCIM]
                              refreshUserInfoCache:userInfo
                                        withUserId:[RCIM sharedRCIM]
                                                       .currentUserInfo.userId];
                          [[RCDataBaseManager shareInstance]
                              insertUserToDB:userInfo];
                          [[NSNotificationCenter defaultCenter]
                              postNotificationName:@"setCurrentUserPortrait"
                                            object:image];
                          dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                            //关闭HUD
                            [hud hide:YES];
                          });
                        }
                        if (result == NO) {
                          //关闭HUD
                          [hud hide:YES];
                          UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                        message:@"上传头像失败"
                                       delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
                          [alert show];
                        }
                      }];

      }
      failure:^(NSError *err) {
        //关闭HUD
        [hud hide:YES];
        UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:nil
                                       message:@"上传头像失败"
                                      delegate:self
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
        [alert show];
      }];
}

-(UIImage*)getSubImage:(UIImage *)originImage Rect:(CGRect)rect imageOrientation:(UIImageOrientation)imageOrientation
{
  CGImageRef subImageRef = CGImageCreateWithImageInRect(originImage.CGImage, rect);
  CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
  
  UIGraphicsBeginImageContext(smallBounds.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextDrawImage(context, smallBounds, subImageRef);
  UIImage* smallImage = [UIImage imageWithCGImage:subImageRef scale:1.f orientation:imageOrientation];
  UIGraphicsEndImageContext();
  return smallImage;
}

- (UIImage *)scaleImage:(UIImage *)tempImage toScale:(float)scaleSize {
  UIGraphicsBeginImageContext(CGSizeMake(tempImage.size.width * scaleSize,
                                         tempImage.size.height * scaleSize));
  [tempImage drawInRect:CGRectMake(0, 0, tempImage.size.width * scaleSize,
                                   tempImage.size.height * scaleSize)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}

-(void)cilckBackBtn:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)dealWithNetworkStatus {
  BOOL isconnected = NO;
  RCNetworkStatus networkStatus = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
  if (networkStatus == 0) {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:nil
                               message:@"当前网络不可用，请检查你的网络设置"
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil];
    [alert show];
    return isconnected;
  }
  return isconnected = YES;
}
@end
