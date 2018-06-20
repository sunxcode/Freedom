//  FreedomDetailViewController.h
//  Freedom
// Created by Super
#import "WechatSettingViewController.h"
#import "TLUserHelper.h"
@interface WeChatChatDetailViewController : WechatSettingViewController
@property (nonatomic, strong) TLUser *user;
@property (nonatomic,strong) UICollectionView *collectionView;
@end
