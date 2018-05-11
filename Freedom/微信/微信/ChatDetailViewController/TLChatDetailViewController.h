//  FreedomDetailViewController.h
//  Freedom
// Created by Super
#import "TLSettingViewController.h"
#import "TLUserHelper.h"
@interface TLChatDetailViewController : TLSettingViewController
@property (nonatomic, strong) TLUser *user;
@property (nonatomic,strong) UICollectionView *collectionView;
@end
