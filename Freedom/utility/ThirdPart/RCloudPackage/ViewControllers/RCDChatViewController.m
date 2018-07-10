//
//  RCDChatViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
#import "RCDAddFriendViewController.h"
#import "RCDChatViewController.h"
#import "RCDChatViewController.h"
#import "RCDContactSelectedTableViewController.h"
#import "RCDDiscussGroupSettingViewController.h"
#import "RCDGroupSettingsTableViewController.h"
#import "RCDHttpTool.h"
#import "RCDPersonDetailViewController.h"
#import "RCDPrivateSettingViewController.h"
#import "RCDPrivateSettingsTableViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDRoomSettingViewController.h"
#import "RCloudModel.h"
#import "RCDataBaseManager.h"
#import "RCDataBaseManager.h"
#import "RealTimeLocationViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDReceiptDetailsTableViewController.h"
#import <RongContactCard/RongContactCard.h>
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import <UIKit/UIKit.h>
@protocol RealTimeLocationStatusViewDelegate <NSObject>
- (void)onJoin;
- (void)onShowRealTimeLocationView;
- (RCRealTimeLocationStatus)getStatus;
@end
@interface RealTimeLocationStatusView : UIView
@property(nonatomic, weak) id<RealTimeLocationStatusViewDelegate> delegate;
- (void)updateText:(NSString *)statusText;
- (void)updateRealTimeLocationStatus;
@property(nonatomic) BOOL isExpended;
@property(nonatomic, strong) UILabel *statusLabel;
@property(nonatomic, strong) UIImageView *locationIcon;
@property(nonatomic, strong) UIImageView *moreIcon;
@property(nonatomic, strong) UILabel *expendLabel;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *joinButton;
@end
@implementation RealTimeLocationStatusView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTaped:)];
    [self addGestureRecognizer:tap];
}
- (void)onTaped:(id)sender {
    if ([self.delegate getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        self.isExpended = !self.isExpended;
    } else if ([self.delegate getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE) {
        self.hidden = YES;
    } else {
        [self.delegate onShowRealTimeLocationView];
    }
}
- (void)updateText:(NSString *)statusText {
    self.statusLabel.text = statusText;
}
- (void)updateRealTimeLocationStatus {
    switch ([self.delegate getStatus]) {
        case RC_REAL_TIME_LOCATION_STATUS_IDLE:
            self.hidden = YES;
            self.isExpended = NO;
            break;
        case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
            self.hidden = NO;
            self.isExpended = NO;
            [self setBackgroundColor:[UIColor colorWithRed:((float)0x11) / 255 green:((float)0x40) / 255 blue:((float)0x60) / 255 alpha:0.7]];
            break;
        case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
        case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
            self.hidden = NO;
            self.isExpended = NO;
            [self setBackgroundColor:[UIColor colorWithRed:((float)0x69) / 255 green:((float)0xb8) / 255 blue:((float)0xee) / 255 alpha:0.7]];
            break;
        default:break;
    }
}
- (void)onCanelPressed:(id)sender {
    self.isExpended = NO;
}
- (void)onJoinPressed:(id)sender {
    self.isExpended = NO;
    [self.delegate onJoin];
}
- (void)setIsExpended:(BOOL)isExpended {
    if (!self.hidden) {
        if (!isExpended) {
            [self showStatus];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.1f];
            self.frame = CGRectMake(0, 62, self.frame.size.width, 38);
            [UIView commitAnimations];
        } else {
            [self showExtendedView];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.1f];
            self.frame = CGRectMake(0, 62, self.frame.size.width, 85);
            [UIView commitAnimations];
        }
    }
    _isExpended = isExpended;
}
- (void)showStatus {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self addSubview:self.statusLabel];
    [self addSubview:self.locationIcon];
    [self addSubview:self.moreIcon];
}
- (void)showExtendedView {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self addSubview:self.expendLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.joinButton];
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, self.frame.size.width - 60, 40)];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
    }
    return _statusLabel;
}
- (UIImageView *)locationIcon {
    if (!_locationIcon) {
        _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 10, 14)];
        [_locationIcon setImage:[UIImage imageNamed:@"white_location_icon"]];
    }
    return _locationIcon;
}
- (UIImageView *)moreIcon {
    if (!_moreIcon) {
        _moreIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 20, 13, 10, 14)];
        [_moreIcon setImage:[UIImage imageNamed:@"location_arrow"]];
    }
    return _moreIcon;
}
- (UILabel *)expendLabel {
    if (!_expendLabel) {
        _expendLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, self.frame.size.width - 48, 60)];
        _expendLabel.textAlignment = NSTextAlignmentCenter;
        _expendLabel.textColor = [UIColor whiteColor];
        [_expendLabel setText:@"加"@"入位置共享，聊天中其他人也能看到你的位置，确定加入"@"？"];
        _expendLabel.numberOfLines = 0;
    }
    return _expendLabel;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(79, 52, 50, 25)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"location_share_button"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"location_share_button_hover"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(onCanelPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 50 - 79, 52, 50, 25)];
        [_joinButton setTitle:@"加入" forState:UIControlStateNormal];
        [_joinButton setBackgroundImage:[UIImage imageNamed:@"location_share_button"] forState:UIControlStateNormal];
        [_joinButton setBackgroundImage:[UIImage imageNamed:@"location_share_button_hover"] forState:UIControlStateHighlighted];
        [_joinButton addTarget:self action:@selector(onJoinPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinButton;
}
@end
@interface RealTimeLocationStartCell : RCMessageCell
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;
@property(nonatomic, strong) RCAttributedLabel *textLabel;
@property(nonatomic, strong) UIImageView *locationView;
@end
@implementation RealTimeLocationStartCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    CGFloat __messagecontentview_height = 40.0f;
    __messagecontentview_height += extraHeight;
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    //    for (UIView *subView in [self.messageContentView subviews]) {
    //        [subView removeFromSuperview];
    //    }
    NSString *content = @"我发起了位置共享";
    [self.textLabel setText:content dataDetectorEnabled:NO];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    // ios 7
    CGSize __textSize = [content boundingRectWithSize:CGSizeMake(self.baseContentView.bounds.size.width - (10 +[RCIM sharedRCIM].globalMessagePortraitSize.width +10) *2 -5 - 35,8000)
     options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
     attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:Text_Message_Font_Size]} context:nil].size;
    __textSize = CGSizeMake(ceilf(__textSize.width), ceilf(__textSize.height));
    CGSize __labelSize = CGSizeMake(__textSize.width, __textSize.height + 5);
    CGFloat __bubbleWidth = __labelSize.width + 18 + 15 < 50? 50: (__labelSize.width + 18 +15);
    CGFloat __bubbleHeight = __labelSize.height + 5 + 5 < 40 ? 40 : (__labelSize.height + 5 + 5);
    CGSize __bubbleSize = CGSizeMake(__bubbleWidth + 18, __bubbleHeight);
    CGRect messageContentViewRect = self.messageContentView.frame;
    //拉伸图片
    // CGFloat top, CGFloat left, CGFloat bottom, CGFloat right
    if (MessageDirection_RECEIVE == self.messageDirection) {
        messageContentViewRect.size.width = __bubbleSize.width;
        messageContentViewRect.size.height = __bubbleSize.height;
        self.messageContentView.frame = messageContentViewRect;
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        self.bubbleBackgroundView.image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
        self.locationView.frame = CGRectMake(18, self.bubbleBackgroundView.frame.size.height / 2 -20 / 2,15,20);
        self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.locationView.frame) + 4, 20 - __labelSize.height / 2, __labelSize.width, __labelSize.height);
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,image.size.width * 0.8,image.size.height * 0.2,image.size.width * 0.2)];
    } else {
        messageContentViewRect.size.width = __bubbleSize.width;
        messageContentViewRect.size.height = __bubbleSize.height;
        messageContentViewRect.origin.x = self.baseContentView.bounds.size.width - (messageContentViewRect.size.width + HeadAndContentSpacing + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        self.textLabel.frame = CGRectMake(12, 20 - __labelSize.height / 2,__labelSize.width, __labelSize.height);
        self.locationView.frame = CGRectMake(12 + __labelSize.width + 4,self.bubbleBackgroundView.frame.size.height / 2 -20 / 2,15,20);
        self.bubbleBackgroundView.image = [RCKitUtility imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,image.size.width * 0.2,image.size.height * 0.2,image.size.width * 0.8)];
    }
}
- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}
- (void)tapMessage:(id)sender {
    [self.delegate didTapMessageCell:self.model];
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[RCAttributedLabel alloc] initWithFrame:CGRectZero];
        [_textLabel setFont:[UIFont systemFontOfSize:Text_Message_Font_Size]];
        _textLabel.numberOfLines = 0;
        [_textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_textLabel setTextAlignment:NSTextAlignmentLeft];
        [_textLabel setTextColor:[UIColor blackColor]];
        [self.bubbleBackgroundView addSubview:_textLabel];
    }
    return _textLabel;
}
- (UIImageView *)bubbleBackgroundView {
    if (!_bubbleBackgroundView) {
        _bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.messageContentView addSubview:_bubbleBackgroundView];
        UITapGestureRecognizer *messageTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessage:)];
        messageTap.numberOfTapsRequired = 1;
        messageTap.numberOfTouchesRequired = 1;
        [self.bubbleBackgroundView addGestureRecognizer:messageTap];
        self.bubbleBackgroundView.userInteractionEnabled = YES;
    }
    return _bubbleBackgroundView;
}
- (UIImageView *)locationView {
    if (!_locationView) {
        _locationView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.bubbleBackgroundView addSubview:_locationView];
        [_locationView setImage:[UIImage imageNamed:@"blue_location_icon"]];
    }
    return _locationView;
}
@end
/**TipMessageCell */
@interface RealTimeLocationEndCell : RCMessageBaseCell
//tipMessage显示Label
@property(strong, nonatomic) RCTipLabel *tipMessageLabel;
- (void)setDataModel:(RCMessageModel *)model;
@end
@implementation RealTimeLocationEndCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    CGFloat __messagecontentview_height = 21.0f;
    __messagecontentview_height += extraHeight;
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tipMessageLabel = [RCTipLabel greyTipLabel];
        [self.baseContentView addSubview:self.tipMessageLabel];
        // self.tipMessageLabel.marginInsets = UIEdgeInsetsMake(0.5f, 0.5f, 0.5f,
        // 0.5f);
    }
    return self;
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    //    RCMessageContent *content = model.content;
    CGFloat maxMessageLabelWidth = self.baseContentView.bounds.size.width - 30 * 2;
    [self.tipMessageLabel setText:@"位置共享已结束" dataDetectorEnabled:NO];
    NSString *__text = self.tipMessageLabel.text;
    CGSize __textSize = [RCKitUtility getTextDrawingSize:__text font:[UIFont systemFontOfSize:14.0f] constrainedSize:CGSizeMake(maxMessageLabelWidth, MAXFLOAT)];
    __textSize = CGSizeMake(ceilf(__textSize.width), ceilf(__textSize.height));
    CGSize __labelSize = CGSizeMake(__textSize.width + 10, __textSize.height + 6);
    self.tipMessageLabel.frame = CGRectMake((self.baseContentView.bounds.size.width - __labelSize.width) / 2.0f, 10,__labelSize.width, __labelSize.height);
}
@end
/*!测试消息Cell*/
@interface RCDTestMessageCell : RCMessageCell
/*!文本内容的Label*/
@property(strong, nonatomic) UILabel *textLabel;
/*! 背景View*/
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;
/*!根据消息内容获取显示的尺寸
@param message 消息内容
@return 显示的View尺寸*/
+ (CGSize)getBubbleBackgroundViewSize:(RCDTestMessage *)message;
@end

@implementation RCDTestMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    RCDTestMessage *message = (RCDTestMessage *)model.content;
    CGSize size = [RCDTestMessageCell getBubbleBackgroundViewSize:message];
    CGFloat __messagecontentview_height = size.height;
    __messagecontentview_height += extraHeight;
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.textLabel setFont:[UIFont systemFontOfSize:16]];
    self.textLabel.numberOfLines = 0;
    [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLabel setTextAlignment:NSTextAlignmentLeft];
    [self.textLabel setTextColor:[UIColor blackColor]];
    [self.bubbleBackgroundView addSubview:self.textLabel];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    UITapGestureRecognizer *textMessageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTextMessage:)];
    textMessageTap.numberOfTapsRequired = 1;
    textMessageTap.numberOfTouchesRequired = 1;
    [self.textLabel addGestureRecognizer:textMessageTap];
    self.textLabel.userInteractionEnabled = YES;
}
- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self setAutoLayout];
}
- (void)setAutoLayout {
    RCDTestMessage *testMessage = (RCDTestMessage *)self.model.content;
    if (testMessage) {
        self.textLabel.text = testMessage.content;
    }
    CGSize textLabelSize = [[self class] getTextLabelSize:testMessage];
    CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:textLabelSize];
    CGRect messageContentViewRect = self.messageContentView.frame;
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {
        self.textLabel.frame = CGRectMake(20, 7, textLabelSize.width, textLabelSize.height);
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        self.messageContentView.frame = messageContentViewRect;
        self.bubbleBackgroundView.frame = CGRectMake( 0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,image.size.width * 0.8,image.size.height * 0.2,image.size.width * 0.2)];
    } else {
        self.textLabel.frame = CGRectMake(12, 7, textLabelSize.width, textLabelSize.height);
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        messageContentViewRect.origin.x =self.baseContentView.bounds.size.width -(messageContentViewRect.size.width + HeadAndContentSpacing +[RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,image.size.width * 0.2,image.size.height * 0.2,image.size.width * 0.8)];
    }
}
- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}

+ (CGSize)getTextLabelSize:(RCDTestMessage *)message {
    if ([message.content length] > 0) {
        float maxWidth = [UIScreen mainScreen].bounds.size.width - (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
        CGRect textRect = [message.content boundingRectWithSize:CGSizeMake(maxWidth, 8000) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    } else {
        return CGSizeZero;
    }
}

+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
    CGSize bubbleSize = CGSizeMake(textLabelSize.width, textLabelSize.height);
    if (bubbleSize.width + 12 + 20 > 50) {
        bubbleSize.width = bubbleSize.width + 12 + 20;
    } else {
        bubbleSize.width = 50;
    }
    if (bubbleSize.height + 7 + 7 > 40) {
        bubbleSize.height = bubbleSize.height + 7 + 7;
    } else {
        bubbleSize.height = 40;
    }
    return bubbleSize;
}
+ (CGSize)getBubbleBackgroundViewSize:(RCDTestMessage *)message {
    CGSize textLabelSize = [[self class] getTextLabelSize:message];
    return [[self class] getBubbleSize:textLabelSize];
}
@end

@interface RCDChatViewController () <UIActionSheetDelegate, RCRealTimeLocationObserver,RealTimeLocationStatusViewDelegate, UIAlertViewDelegate,RCMessageCellDelegate>
@property(nonatomic, weak) id<RCRealTimeLocationProxy> realTimeLocation;
@property(nonatomic, strong)RealTimeLocationStatusView *realTimeLocationStatusView;
@property(nonatomic, strong) RCDGroupInfo *groupInfo;
@property(nonatomic, strong) RCUserInfo *cardInfo;
-(UIView *)loadEmoticonView:(NSString *)identify index:(int)index;
@end
NSMutableDictionary *userInputStatus;
@implementation RCDChatViewController
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
    NSString *userInputStatusKey = [NSString stringWithFormat:@"%lu--%@",(unsigned long)self.conversationType,self.targetId];
    if (userInputStatus && [userInputStatus.allKeys containsObject:userInputStatusKey]) {
        KBottomBarStatus inputType = (KBottomBarStatus)[userInputStatus[userInputStatusKey] integerValue];
        //输入框记忆功能，如果退出时是语音输入，再次进入默认语音输入
        if (inputType == KBottomBarRecordStatus) {
            self.defaultInputType = RCChatSessionInputBarInputVoice;
        }else if (inputType == KBottomBarPluginStatus){
            //      self.defaultInputType = RCChatSessionInputBarInputExtention;
        }
    }
  [self refreshTitle];
    [self.chatSessionInputBarControl updateStatus:self.chatSessionInputBarControl.currentBottomBarStatus animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    KBottomBarStatus inputType = self.chatSessionInputBarControl.currentBottomBarStatus;
    if (!userInputStatus) {
        userInputStatus = [NSMutableDictionary new];
    }
    NSString *userInputStatusKey = [NSString stringWithFormat:@"%lu--%@",(unsigned long)self.conversationType,self.targetId];
    [userInputStatus setObject:[NSString stringWithFormat:@"%ld",(long)inputType]  forKey:userInputStatusKey];
}
- (void)viewDidLoad {
  [super viewDidLoad];
  self.enableSaveNewPhotoToLocalSystem = YES;
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  if (self.conversationType != ConversationType_CHATROOM) {
    if (self.conversationType == ConversationType_DISCUSSION) {
      [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId
          success:^(RCDiscussion *discussion) {
            if (discussion != nil && discussion.memberIdList.count > 0) {
              if ([discussion.memberIdList containsObject:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                [self setRightNavigationItem:[UIImage imageNamed:@"Private_Setting"] withFrame:CGRectMake(15, 3.5, 16, 18.5)];
              } else {
                self.navigationItem.rightBarButtonItem = nil;
              }
            }
          }error:^(RCErrorCode status){
          }];
    } else if (self.conversationType == ConversationType_GROUP) {
      [self setRightNavigationItem:[UIImage imageNamed:@"Group_Setting"] withFrame:CGRectMake(10, 3.5, 21, 19.5)];
    } else {
      [self setRightNavigationItem:[UIImage imageNamed:@"Private_Setting"] withFrame:CGRectMake(15, 3.5, 16, 18.5)];
    }
  } else {
    self.navigationItem.rightBarButtonItem = nil;
  }
  /*******************实时地理位置共享***************/
  [self registerClass:[RealTimeLocationStartCell class] forMessageClass:[RCRealTimeLocationStartMessage class]];
  [self registerClass:[RealTimeLocationEndCell class] forMessageClass:[RCRealTimeLocationEndMessage class]];
  __weak typeof(&*self) weakSelf = self;
  [[RCRealTimeLocationManager sharedManager] getRealTimeLocationProxy:self.conversationType targetId:self.targetId success:^(id<RCRealTimeLocationProxy> realTimeLocation) {
        weakSelf.realTimeLocation = realTimeLocation;
        [weakSelf.realTimeLocation addRealTimeLocationObserver:self];
        [weakSelf updateRealTimeLocationStatus];
      }error:^(RCRealTimeLocationErrorCode status) {
        NSLog(@"get location share failure with code %d", (int)status);
      }];
  /******************实时地理位置共享**************/
  ///注册自定义测试消息Cell
  [self registerClass:[RCDTestMessageCell class]forMessageClass:[RCDTestMessage class]];
  [self notifyUpdateUnreadMessageCount];
    if (self.conversationType != ConversationType_APPSERVICE && self.conversationType != ConversationType_PUBLICSERVICE) {
        //加号区域增加发送文件功能，Kit中已经默认实现了该功能，但是为了SDK向后兼容性，目前SDK默认不开启该入口，可以参考以下代码在加号区域中增加发送文件功能。
        UIImage *imageFile = [RCKitUtility imageNamed:@"actionbar_file_icon" ofBundle:@"RongCloud.bundle"];
        [self.pluginBoardView insertItemWithImage:imageFile title:NSLocalizedStringFromTable(@"File", @"RongCloudKit", nil) atIndex:3 tag:PLUGIN_BOARD_ITEM_FILE_TAG];
    }
  //    self.chatSessionInputBarControl.hidden = YES;
  //    CGRect intputTextRect = self.conversationMessageCollectionView.frame;
  //    intputTextRect.size.height = intputTextRect.size.height+50;
  //    [self.conversationMessageCollectionView setFrame:intputTextRect];
  //    [self scrollToBottomAnimated:YES];
  /***********如何自定义面板功能***********************
   自定义面板功能首先要继承RCConversationViewController，如现在所在的这个文件。
   然后在viewDidLoad函数的super函数之后去编辑按钮：
   插入到指定位置的方法如下：
   [self.pluginBoardView insertItemWithImage:imagePic
                                       title:title
                                     atIndex:0
                                         tag:101];
   或添加到最后的：
   [self.pluginBoardView insertItemWithImage:imagePic
                                       title:title
                                         tag:101];
   删除指定位置的方法：
   [self.pluginBoardView removeItemAtIndex:0];
   删除指定标签的方法：
   [self.pluginBoardView removeItemWithTag:101];
   删除所有：
   [self.pluginBoardView removeAllItems];
   更换现有扩展项的图标和标题:
   [self.pluginBoardView updateItemAtIndex:0 image:newImage title:newTitle];
   或者根据tag来更换
   [self.pluginBoardView updateItemWithTag:101 image:newImage title:newTitle];
   以上所有的接口都在RCPluginBoardView.h可以查到。

   当编辑完扩展功能后，下一步就是要实现对扩展功能事件的处理，放开被注掉的函数
   pluginBoardView:clickedItemWithTag:
   在super之后加上自己的处理。

   */

  //默认输入类型为语音
  // self.defaultInputType = RCChatSessionInputBarInputExtention;

  /***********如何在会话页面插入提醒消息***********************

      RCInformationNotificationMessage *warningMsg =
     [RCInformationNotificationMessage
     notificationWithMessage:@"请不要轻易给陌生人汇钱！" extra:nil];
      BOOL saveToDB = NO;  //是否保存到数据库中
      RCMessage *savedMsg ;
      if (saveToDB) {
          savedMsg = [[RCIMClient sharedRCIMClient]
     insertOutgoingMessage:self.conversationType targetId:self.targetId
     sentStatus:SentStatus_SENT content:warningMsg];
      } else {
          savedMsg =[[RCMessage alloc] initWithType:self.conversationType
     targetId:self.targetId direction:MessageDirection_SEND messageId:-1
     content:warningMsg];//注意messageId要设置为－1
      }
      [self appendAndDisplayMessage:savedMsg];
  */
  //    self.enableContinuousReadUnreadVoice = YES;//开启语音连读功能
  if (self.conversationType == ConversationType_PRIVATE || self.conversationType == ConversationType_GROUP) {
  }

  //刷新个人或群组的信息
  [self refreshUserInfoOrGroupInfo];
  
  if (self.conversationType == ConversationType_GROUP) {
    //群组改名之后，更新当前页面的Title
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitleForGroup:) name:@"UpdeteGroupInfo" object:nil];
  }
  //清除历史消息
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearHistoryMSG:) name:@"ClearHistoryMsg" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateForSharedMessageInsertSuccess:) name:@"RCDSharedMessageInsertSuccess" object:nil];

//  //表情面板添加自定义表情包
//  UIImage *icon = [RCKitUtility imageNamed:@"emoji_btn_normal"
//                                  ofBundle:@"RongCloud.bundle"];
//  RCDCustomerEmoticonTab *emoticonTab1 = [RCDCustomerEmoticonTab new];
//  emoticonTab1.identify = @"1";
//  emoticonTab1.image = icon;
//  emoticonTab1.pageCount = 2;
//  emoticonTab1.chartView = self;
//
//  [self.emojiBoardView addEmojiTab:emoticonTab1];
//
//  RCDCustomerEmoticonTab *emoticonTab2 = [RCDCustomerEmoticonTab new];
//  emoticonTab2.identify = @"2";
//  emoticonTab2.image = icon;
//  emoticonTab2.pageCount = 4;
//  emoticonTab2.chartView = self;
//
//  [self.emojiBoardView addEmojiTab:emoticonTab2];
}
/*  返回的 view 大小必须等于 contentViewSize （宽度 = 屏幕宽度，高度 = 186）
 *  @param identify 表情包标示
 *  @param index    index
 *  @return view */
- (UIView *)loadEmoticonView:(NSString *)identify index:(int)index {
  UIView *view11 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 186)];
  view11.backgroundColor = [UIColor blackColor];
  switch (index) {
  case 1:view11.backgroundColor = [UIColor yellowColor];break;
  case 2:view11.backgroundColor = [UIColor redColor];break;
  case 3:view11.backgroundColor = [UIColor greenColor];break;
  case 4:view11.backgroundColor = [UIColor grayColor];break;
  default:break;
  }
  return view11;
}
- (void)updateForSharedMessageInsertSuccess:(NSNotification *)notification {
  RCMessage *message = notification.object;
  if (message.conversationType == self.conversationType && [message.targetId isEqualToString:self.targetId]) {
    [self appendAndDisplayMessage:message];
  }
}
- (void)setRightNavigationItem:(UIImage *)image withFrame:(CGRect)frame {
    UIButton *buttonItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    UIImageView *imageV = [[UIImageView alloc]initWithImage:image];
    imageV.frame = frame;
    [buttonItem addSubview:imageV];
    [buttonItem addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonItem];
}

- (void)updateTitleForGroup:(NSNotification *)notification {
  NSString *groupId = notification.object;
  if ([groupId isEqualToString:self.targetId]) {
    RCDGroupInfo *tempInfo = [[RCDataBaseManager shareInstance] getGroupByGroupId:self.targetId];
    int count = tempInfo.number.intValue;
    dispatch_async(dispatch_get_main_queue(), ^{
      self.title = [NSString stringWithFormat:@"%@(%d)",tempInfo.groupName,count];
    });
  }
}
- (void)clearHistoryMSG:(NSNotification *)notification {
  [self.conversationDataRepository removeAllObjects];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.conversationMessageCollectionView reloadData];
  });
}

- (void)leftBarButtonItemPressed:(id)sender {
  if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_OUTGOING ||
      [self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_CONNECTED) {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"离开聊天，位置共享也会结束，确认离开" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 101;
    [alertView show];
  } else {
    [self popupChatViewController];
  }
}
- (void)popupChatViewController {
  [super leftBarButtonItemPressed:nil];
  [self.realTimeLocation removeRealTimeLocationObserver:self];
  if (_needPopToRootView == YES) {
    [self.navigationController popToRootViewControllerAnimated:YES];
  } else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

/**
 *  此处使用自定义设置，开发者可以根据需求自己实现
 *  不添加rightBarButtonItemClicked事件，则使用默认实现。
 */
- (void)rightBarButtonItemClicked:(id)sender {
  if (self.conversationType == ConversationType_PRIVATE) {
    RCDUserInfo *friendInfo = [[RCDataBaseManager shareInstance] getFriendInfo:self.targetId];
    if (![friendInfo.status isEqualToString:@"20"]) {
      RCDAddFriendViewController *vc = [[RCDAddFriendViewController alloc] init];
      vc.targetUserInfo = friendInfo;
      [self.navigationController pushViewController:vc animated:YES];
    } else {
      RCDPrivateSettingsTableViewController *settingsVC = [RCDPrivateSettingsTableViewController privateSettingsTableViewController];
      settingsVC.userId = self.targetId;
      [self.navigationController pushViewController:settingsVC animated:YES];
    }
  } else if (self.conversationType == ConversationType_DISCUSSION) {
    RCDDiscussGroupSettingViewController *settingVC =
        [[RCDDiscussGroupSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    settingVC.conversationTitle = self.userName;
    //设置讨论组标题时，改变当前会话页面的标题
    settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
      self.title = discussTitle;
    };
    //清除聊天记录之后reload data
    __weak RCDChatViewController *weakSelf = self;
    settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
      if (isSuccess) {
        [weakSelf.conversationDataRepository removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.conversationMessageCollectionView reloadData];
        });
      }
    };
    [self.navigationController pushViewController:settingVC animated:YES];
  }
  //群组设置
  else if (self.conversationType == ConversationType_GROUP) {
    RCDGroupSettingsTableViewController *settingsVC =
        [RCDGroupSettingsTableViewController groupSettingsTableViewController];
    if (_groupInfo == nil) {
      settingsVC.Group = [[RCDataBaseManager shareInstance] getGroupByGroupId:self.targetId];
    } else {
      settingsVC.Group = _groupInfo;
    }
    [self.navigationController pushViewController:settingsVC animated:YES];
  }
  //客服设置
  else if (self.conversationType == ConversationType_CUSTOMERSERVICE ||self.conversationType == ConversationType_SYSTEM) {
    RCDSettingBaseViewController *settingVC = [[RCDSettingBaseViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    //清除聊天记录之后reload data
    __weak RCDChatViewController *weakSelf = self;
    settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
      if (isSuccess) {
        [weakSelf.conversationDataRepository removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.conversationMessageCollectionView reloadData];
        });
      }
    };
    [self.navigationController pushViewController:settingVC animated:YES];
  } else if (ConversationType_APPSERVICE == self.conversationType ||ConversationType_PUBLICSERVICE == self.conversationType) {
    RCPublicServiceProfile *serviceProfile = [[RCIMClient sharedRCIMClient]getPublicServiceProfile:(RCPublicServiceType)self.conversationType publicServiceId:self.targetId];
    RCPublicServiceProfileViewController *infoVC = [[RCPublicServiceProfileViewController alloc] init];
    infoVC.serviceProfile = serviceProfile;
    infoVC.fromConversation = YES;
    [self.navigationController pushViewController:infoVC animated:YES];
  }
}
/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model {
  RCImageSlideController *previewController = [[RCImageSlideController alloc] init];
  previewController.messageModel = model;
  UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:previewController];
  [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
  [super didLongTouchMessageCell:model inView:view];
  NSLog(@"%s", __FUNCTION__);
}
/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
  __weak typeof(&*self) __weakself = self;
  int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
    @(ConversationType_PRIVATE),
    @(ConversationType_DISCUSSION),
    @(ConversationType_APPSERVICE),
    @(ConversationType_PUBLICSERVICE),
    @(ConversationType_GROUP)
  ]];
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *backString = nil;
    if (count > 0 && count < 1000) {
      backString = [NSString stringWithFormat:@"返回(%d)", count];
    } else if (count >= 1000) {
      backString = @"返回(...)";
    } else {
      backString = @"返回";
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 87, 23);
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
    backImg.frame = CGRectMake(-6, 4, 10, 17);
    [backBtn addSubview:backImg];
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(9, 4, 85, 17)];
    backText.text = backString; // NSLocalizedStringFromTable(@"Back",
                                // @"RongCloudKit", nil);
    //   backText.font = [UIFont systemFontOfSize:17];
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:[UIColor whiteColor]];
    [backBtn addSubview:backText];
    [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [__weakself.navigationItem setLeftBarButtonItem:leftButton];
  });
}
- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage {
  //保存图片
  UIImage *image = newImage;
  UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
}

- (void)setRealTimeLocation:(id<RCRealTimeLocationProxy>)realTimeLocation {
  _realTimeLocation = realTimeLocation;
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
  switch (tag) {
  case PLUGIN_BOARD_ITEM_LOCATION_TAG: {
    if (self.realTimeLocation) {
      UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
               cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送位置", @"位置实时共享", nil];
      [actionSheet showInView:self.view];
    } else {
      [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
  } break;
  default:[super pluginBoardView:pluginBoardView clickedItemWithTag:tag];break;
  }
}

- (RealTimeLocationStatusView *)realTimeLocationStatusView {
  if (!_realTimeLocationStatusView) {
    _realTimeLocationStatusView = [[RealTimeLocationStatusView alloc]initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 0)];
    _realTimeLocationStatusView.delegate = self;
    [self.view addSubview:_realTimeLocationStatusView];
  }
  return _realTimeLocationStatusView;
}
#pragma mark - RealTimeLocationStatusViewDelegate
- (void)onJoin {
  [self showRealTimeLocationViewController];
}
- (RCRealTimeLocationStatus)getStatus {
  return [self.realTimeLocation getStatus];
}
- (void)onShowRealTimeLocationView {
  [self showRealTimeLocationViewController];
}
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent {
  //可以在这里修改将要发送的消息
  if ([messageContent isMemberOfClass:[RCTextMessage class]]) {
    // RCTextMessage *textMsg = (RCTextMessage *)messageContent;
    // textMsg.extra = @"";
  }
  return messageContent;
}
#pragma mark override
- (void)didTapMessageCell:(RCMessageModel *)model {
  [super didTapMessageCell:model];
  if ([model.content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
    [self showRealTimeLocationViewController];
  }
  if ([model.content isKindOfClass:[RCContactCardMessage class]]) {
    [self didTapCellPortrait:((RCContactCardMessage*)model.content).userId];
  }
  
}

- (NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList:
    (RCMessageModel *)model {
  NSMutableArray<UIMenuItem *> *menuList =
      [[super getLongTouchMessageCellMenuList:model] mutableCopy];
  /*
  在这里添加删除菜单。
  [menuList enumerateObjectsUsingBlock:^(UIMenuItem * _Nonnull obj, NSUInteger
 idx, BOOL * _Nonnull stop) {
    if ([obj.title isEqualToString:@"删除"] || [obj.title
 isEqualToString:@"delete"]) {
      [menuList removeObjectAtIndex:idx];
      *stop = YES;
    }
  }];

 UIMenuItem *forwardItem = [[UIMenuItem alloc] initWithTitle:@"转发"
 action:@selector(onForwardMessage:)];
 [menuList addObject:forwardItem];

  如果您不需要修改，不用重写此方法，或者直接return［super
 getLongTouchMessageCellMenuList:model]。
  */
  return menuList;
}

- (void)didTapCellPortrait:(NSString *)userId {
  if (self.conversationType == ConversationType_GROUP ||
      self.conversationType == ConversationType_DISCUSSION) {
    if (![userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
      [[RCDUserInfoManager shareInstance] getFriendInfo:userId completion:^(RCUserInfo *user) {
           [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
           [self gotoNextPage:user];
         }];
    } else {
      [[RCDUserInfoManager shareInstance]getUserInfo:userId completion:^(RCUserInfo *user) {
         [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
         [self gotoNextPage:user];
       }];
    }
  }
  if (self.conversationType == ConversationType_PRIVATE) {
    [[RCDUserInfoManager shareInstance] getUserInfo:userId completion:^(RCUserInfo *user) {
       [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
       [self gotoNextPage:user];
     }];
  }
}

- (void)gotoNextPage:(RCUserInfo *)user {
  NSArray *friendList = [[RCDataBaseManager shareInstance] getAllFriends];
  BOOL isGotoDetailView = NO;
  for (RCDUserInfo *friend in friendList) {
    if ([user.userId isEqualToString:friend.userId] && [friend.status isEqualToString:@"20"]) {
      isGotoDetailView = YES;
    } else if ([user.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
      isGotoDetailView = YES;
    }
  }
  if (isGotoDetailView == YES) {
      RCDPersonDetailViewController *temp = [[RCDPersonDetailViewController alloc]init];
    temp.userId = user.userId;
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.navigationController pushViewController:temp animated:YES];
    });
  } else {
    RCDAddFriendViewController *vc = [[RCDAddFriendViewController alloc] init];
    vc.targetUserInfo = user;
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.navigationController pushViewController:vc animated:YES];
    });
  }
}
///**
// *  重写方法实现未注册的消息的显示
// 如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
// *  需要设置RCIM showUnkownMessage属性
#pragma mark override
- (void)resendMessage:(RCMessageContent *)messageContent {
  if ([messageContent isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
    [self showRealTimeLocationViewController];
  } else {
    [super resendMessage:messageContent];
  }
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
  case 0: {
    [super pluginBoardView:self.pluginBoardView clickedItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
  } break;
  case 1: {
    [self showRealTimeLocationViewController];
  } break;
  }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
  SEL selector = NSSelectorFromString(@"_alertController");
  if ([actionSheet respondsToSelector:selector]) {
    UIAlertController *alertController =[actionSheet valueForKey:@"_alertController"];
    if ([alertController isKindOfClass:[UIAlertController class]]) {
      alertController.view.tintColor = [UIColor blackColor];
    }
  } else {
    for (UIView *subView in actionSheet.subviews) {
      if ([subView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)subView;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      }
    }
  }
}

#pragma mark - RCRealTimeLocationObserver
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
  __weak typeof(&*self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf updateRealTimeLocationStatus];
  });
}

- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId {
  __weak typeof(&*self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf updateRealTimeLocationStatus];
  });
}

- (void)onParticipantsJoin:(NSString *)userId {
  __weak typeof(&*self) weakSelf = self;
  if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
    [self notifyParticipantChange:@"你加入了地理位置共享"];
  } else {
    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
     if (userInfo.name.length) {
       [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@加入地理位置共享",userInfo.name]];
     } else {
       [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>加入地理位置共享",userId]];
     }
   }];
  }
}

- (void)onParticipantsQuit:(NSString *)userId {
  __weak typeof(&*self) weakSelf = self;
  if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
    [self notifyParticipantChange:@"你退出地理位置共享"];
  } else {
    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
         if (userInfo.name.length) {
           [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@退出地理位置共享",userInfo.name]];
         } else {
           [weakSelf notifyParticipantChange: [NSString stringWithFormat:@"user<%@>退出地理位置共享", userId]];
         }
       }];
  }
}

- (void)onRealTimeLocationStartFailed:(long)messageId {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (int i = 0; i < self.conversationDataRepository.count; i++) {
      RCMessageModel *model = [self.conversationDataRepository objectAtIndex:i];
      if (model.messageId == messageId) {
        model.sentStatus = SentStatus_FAILED;
      }
    }
    NSArray *visibleItem = [self.conversationMessageCollectionView indexPathsForVisibleItems];
    for (int i = 0; i < visibleItem.count; i++) {
      NSIndexPath *indexPath = visibleItem[i];
      RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
      if (model.messageId == messageId) {
        [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[ indexPath ]];
      }
    }
  });
}

- (void)notifyParticipantChange:(NSString *)text {
  __weak typeof(&*self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf.realTimeLocationStatusView updateText:text];
    [weakSelf performSelector:@selector(updateRealTimeLocationStatus) withObject:nil afterDelay:0.5];
  });
}
- (void)onFailUpdateLocation:(NSString *)description {
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (alertView.tag) {
    case 101: {
      if (buttonIndex == 1) {
        [self.realTimeLocation quitRealTimeLocation];
        [self popupChatViewController];
      }
    }break;break;
    default:break;
  }
}
- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message {
  return message;
}

/*******************实时地理位置共享***************/
- (void)showRealTimeLocationViewController {
  RealTimeLocationViewController *lsvc = [[RealTimeLocationViewController alloc] init];
  lsvc.realTimeLocationProxy = self.realTimeLocation;
  if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
    [self.realTimeLocation joinRealTimeLocation];
  } else if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE) {
    [self.realTimeLocation startRealTimeLocation];
  }
  [self.navigationController presentViewController:lsvc animated:YES completion:^{}];
}
- (void)updateRealTimeLocationStatus {
  if (self.realTimeLocation) {
    [self.realTimeLocationStatusView updateRealTimeLocationStatus];
    __weak typeof(&*self) weakSelf = self;
    NSArray *participants = nil;
    switch ([self.realTimeLocation getStatus]) {
    case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
      [self.realTimeLocationStatusView updateText:@"你正在共享位置"];
      break;
    case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
    case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
      participants = [self.realTimeLocation getParticipants];
      if (participants.count == 1) {
        NSString *userId = participants[0];
        [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"user<%@>正在共享位置", userId]];
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
         if (userInfo.name.length) {
           dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.realTimeLocationStatusView
                 updateText:[NSString stringWithFormat:@"%@正在共享位置",userInfo.name]];
           });
         }
       }];
      } else {
        if (participants.count < 1)
          [self.realTimeLocationStatusView removeFromSuperview];
        else
          [self.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%d人正在共享地理位置",(int)participants.count]];
      }break;
    default:break;
    }
  }
}
- (void)refreshUserInfoOrGroupInfo {
  //打开单聊强制从demo server 获取用户信息更新本地数据库
  if (self.conversationType == ConversationType_PRIVATE) {
    if (![self.targetId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
      __weak typeof(self) weakSelf = self;
      [[RCDRCIMDataSource shareInstance]getUserInfoWithUserId:self.targetId completion:^(RCUserInfo *userInfo) {
       [[RCDHttpTool shareInstance]updateUserInfo:weakSelf.targetId success:^(RCDUserInfo *user) {
             RCUserInfo *updatedUserInfo =[[RCUserInfo alloc] init];
             updatedUserInfo.userId = user.userId;
             if (user.displayName.length > 0) {
               updatedUserInfo.name = user.displayName;
             } else {
               updatedUserInfo.name = user.name;
             }
             updatedUserInfo.portraitUri = user.portraitUri;
             weakSelf.navigationItem.title = updatedUserInfo.name;
             [[RCIM sharedRCIM]refreshUserInfoCache:updatedUserInfo withUserId:updatedUserInfo.userId];
           }failure:^(NSError *err){
           }];
     }];
    }
      }
  //刷新自己头像昵称
      [[RCDUserInfoManager shareInstance]getUserInfo:[RCIM sharedRCIM].currentUserInfo.userId completion:^(RCUserInfo *user) {
         [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
       }];
  //打开群聊强制从demo server 获取群组信息更新本地数据库
  if (self.conversationType == ConversationType_GROUP) {
    __weak typeof(self) weakSelf = self;
    [RCDHTTPTOOL getGroupByID:self.targetId successCompletion:^(RCDGroupInfo *group) {
      RCGroup *Group = [[RCGroup alloc] initWithGroupId:weakSelf.targetId groupName:group.groupName portraitUri:group.portraitUri];
      [[RCIM sharedRCIM] refreshGroupInfoCache:Group withGroupId:weakSelf.targetId];
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf refreshTitle];
      });
    }];
  }
  //更新群组成员用户信息的本地缓存
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSMutableArray *groupList =[[RCDataBaseManager shareInstance] getGroupMember:self.targetId];
    NSArray *resultList =[[RCDUserInfoManager shareInstance] getFriendInfoList:groupList];
    groupList = [[NSMutableArray alloc] initWithArray:resultList];
    for (RCUserInfo *user in groupList) {
      if ([user.portraitUri isEqualToString:@""]) {
        user.portraitUri = [FreedomTools defaultUserPortrait:user];
      }
      if ([user.portraitUri hasPrefix:@"file:///"]) {
        NSString *filePath = [FreedomTools getIconCachePath:[NSString stringWithFormat:@"user%@.png", user.userId]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
          NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
          user.portraitUri = [portraitPath absoluteString];
        } else {
          user.portraitUri = [FreedomTools defaultUserPortrait:user];
        }
      }
      [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
    }
  });
}

- (void)refreshTitle{
  if (self.userName == nil) {
    return;
  }
    int count = [[[RCDataBaseManager shareInstance] getGroupByGroupId:self.targetId].number intValue];
    if(self.conversationType == ConversationType_GROUP && count > 0){
        self.title = [NSString stringWithFormat:@"%@(%d)",self.userName,count];
    }else{
        self.title = self.userName;
    }
}
- (void)didTapReceiptCountView:(RCMessageModel *)model {
  if ([model.content isKindOfClass:[RCTextMessage class]]) {
    RCDReceiptDetailsTableViewController *vc = [[RCDReceiptDetailsTableViewController alloc] init];
    RCTextMessage *messageContent = (RCTextMessage *)model.content;
   NSString *sendTime = [RCKitUtility ConvertMessageTime:model.sentTime/1000];
    RCMessage *message = [[RCIMClient sharedRCIMClient] getMessageByUId:model.messageUId];
    NSMutableDictionary *readReceiptUserList = message.readReceiptInfo.userIdList;
    NSArray *hasReadUserList = [readReceiptUserList allKeys];
    if (hasReadUserList.count > 1) {
      hasReadUserList = [self sortForHasReadList:readReceiptUserList];
    }
    vc.targetId = self.targetId;
    vc.messageContent = messageContent.content;
    vc.messageSendTime = sendTime;
    vc.hasReadUserList = hasReadUserList;
    [self.navigationController pushViewController:vc animated:YES];
  }
}
-(NSArray *)sortForHasReadList: (NSDictionary *)readReceiptUserDic {
  NSArray *result;
  NSArray *sortedKeys = [readReceiptUserDic keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    if ([obj1 integerValue] > [obj2 integerValue]) {
      return (NSComparisonResult)NSOrderedDescending;
    }
    if ([obj1 integerValue] < [obj2 integerValue]) {
      return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
  }];
  result = [sortedKeys copy];
  return result;
}
- (BOOL)stayAfterJoinChatRoomFailed {
  //加入聊天室失败之后，是否还停留在会话界面
  return [[[NSUserDefaults standardUserDefaults] objectForKey:@"stayAfterJoinChatRoomFailed"] isEqualToString:@"YES"];
}
- (void)alertErrorAndLeft:(NSString *)errorInfo {
  if (![self stayAfterJoinChatRoomFailed]) {
    [super alertErrorAndLeft:errorInfo];
  }
}

@end
