//  TabBarView.h
//  CLKuGou
//  Created by Darren on 16/7/30.
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface KugouTools : NSObject
// 存储上一次播放歌曲的信息
@property (nonatomic,strong) MPMediaItem *mediaItem;
@end
@interface TabBarView : UIView
+ (instancetype)show;
@property (weak, nonatomic) IBOutlet UIImageView *IconView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UILabel *songNameLable;
@property (weak, nonatomic) IBOutlet UILabel *singerLable;
@property (nonatomic,copy)  NSURL *assetUrl;
@end
