//  TLMomentDetailViewController.m
//  Freedom
//  Created by Super on 16/4/23.
#import "TLMomentDetailViewController.h"
#import "MWPhotoBrowser.h"
#import <UIKit/UIKit.h>
#import "UIView+expanded.h"
#import "UIButton+WebCache.h"
#define     WIDTH_IMAGE_ONE     (WIDTH_SCREEN - 70) * 0.6
#define     WIDTH_IMAGE         (WIDTH_SCREEN - 70) * 0.31
#define     SPACE               4.0
#import "UIButton+WebCache.h"
#define         EDGE_LEFT       10.0f
#define         EDGE_TOP        15.0f
#define         WIDTH_AVATAR    40.0f
#define         SPACE_ROW       8.0f
#define     EDGE_HEADER     5.0f
#import "TLTableViewCell.h"
typedef NS_ENUM(NSInteger, TLMomentViewButtonType) {
    TLMomentViewButtonTypeAvatar,
    TLMomentViewButtonTypeUserName,
    TLMomentViewButtonTypeMore,
};
@interface TLMomentExtensionView : UIView<UITableViewDelegate, UITableViewDataSource>
- (void)registerCellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) TLMomentExtension *extension;
@end
@interface TLMomentExtensionLikedCell : TLTableViewCell
@property (nonatomic, strong) NSArray *likedFriends;
@end
@implementation TLMomentExtensionLikedCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBottomLineStyle:TLCellLineStyleFill];
    }
    return self;
}
@end
@interface TLMomentExtensionCommentCell : TLTableViewCell
@property (nonatomic, strong) TLMomentComment *comment;
@end
@implementation TLMomentExtensionCommentCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setBottomLineStyle:TLCellLineStyleNone];
    }
    return self;
}
@end
@interface TLMomentExtensionView ()
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation TLMomentExtensionView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(EDGE_HEADER);
            make.left.and.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).priorityLow();
        }];
        
        [self registerCellForTableView:self.tableView];
    }
    return self;
}
- (void)setExtension:(TLMomentExtension *)extension{
    _extension = extension;
    [self.tableView reloadData];
}
- (void)drawRect:(CGRect)rect{
    CGFloat startX = 20;
    CGFloat startY = 0;
    CGFloat endY = EDGE_HEADER;
    CGFloat width = 6;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, startX + width, endY);
    CGContextAddLineToPoint(context, startX - width, endY);
    CGContextClosePath(context);
    [RGBACOLOR(243.0, 243.0, 245.0, 1.0) setFill];
    [RGBACOLOR(243.0, 243.0, 245.0, 1.0) setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}
#pragma mark -
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:RGBACOLOR(243.0, 243.0, 245.0, 1.0)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setScrollsToTop:NO];
        [_tableView setScrollEnabled:NO];
    }
    return _tableView;
}
- (void)registerCellForTableView:(UITableView *)tableView{
    [tableView registerClass:[TLMomentExtensionCommentCell class] forCellReuseIdentifier:@"TLMomentExtensionCommentCell"];
    [tableView registerClass:[TLMomentExtensionLikedCell class] forCellReuseIdentifier:@"TLMomentExtensionLikedCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = self.extension.likedFriends.count > 0 ? 1 : 0;
    section += self.extension.comments.count > 0 ? 1 : 0;
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 && self.extension.likedFriends.count > 0) {
        return 1;
    }else{
        return self.extension.comments.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && self.extension.likedFriends.count > 0) {  // 点赞
        TLMomentExtensionLikedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMomentExtensionLikedCell"];
        [cell setLikedFriends:self.extension.likedFriends];
        return cell;
    }else{      // 评论
        TLMomentComment *comment = [self.extension.comments objectAtIndex:indexPath.row];
        TLMomentExtensionCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMomentExtensionCommentCell"];
        [cell setComment:comment];
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && self.extension.likedFriends.count > 0) {
        return self.extension.extensionFrame.heightLiked;
    }else{
        TLMomentComment *comment = [self.extension.comments objectAtIndex:indexPath.row];
        return comment.commentFrame.height;
    }
    return 0.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
@interface TLMomentBaseView ()
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UIButton *usernameView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *originLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) TLMomentExtensionView *extensionView;
@end
@implementation TLMomentBaseView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.avatarView];
        [self addSubview:self.usernameView];
        [self addSubview:self.detailContainerView];
        [self addSubview:self.extensionContainerView];
        [self addSubview:self.dateLabel];
        [self addSubview:self.originLabel];
        [self addSubview:self.moreButton];
        
        [self.extensionContainerView addSubview:self.extensionView];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setMoment:(TLMoment *)moment{
    _moment = moment;
    [self.avatarView sd_setImageWithURL:TLURL(moment.user.avatarURL) forState:UIControlStateNormal];
    [self.usernameView setTitle:moment.user.showName forState:UIControlStateNormal];
    [self.dateLabel setText:@"1小时前"];
    [self.originLabel setText:@"微博"];
    [self.extensionView setExtension:moment.extension];
    
    [self.detailContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(moment.momentFrame.heightDetail);
    }];
    [self.extensionContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(moment.momentFrame.heightExtension);
    }];
}
#pragma mark - Event Response
- (void)buttonClicked:(UIButton *)sender{
    if (sender.tag == TLMomentViewButtonTypeAvatar) {
        
    }else if (sender.tag == TLMomentViewButtonTypeUserName) {
        
    }else if (sender.tag == TLMomentViewButtonTypeMore) {
        
    }
}
#pragma mark -
- (void)p_addMasonry{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(EDGE_TOP);
        make.left.mas_equalTo(self).mas_offset(EDGE_LEFT);
        make.size.mas_equalTo(CGSizeMake(WIDTH_AVATAR, WIDTH_AVATAR));
    }];
    [self.usernameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarView);
        make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(EDGE_LEFT);
        make.right.mas_lessThanOrEqualTo(self).mas_offset(-EDGE_LEFT);
        make.height.mas_equalTo(15.0f);
    }];
    [self.detailContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.usernameView);
        make.top.mas_equalTo(self.usernameView.mas_bottom).mas_offset(SPACE_ROW);
        make.right.mas_equalTo(self).mas_offset(-EDGE_LEFT);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailContainerView.mas_bottom).mas_offset(SPACE_ROW);
        make.left.mas_equalTo(self.usernameView);
    }];
    [self.originLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel);
        make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(EDGE_LEFT);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dateLabel);
        make.right.mas_equalTo(self.detailContainerView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [self.extensionContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_bottom).mas_offset(SPACE_ROW);
        make.left.and.right.mas_equalTo(self.detailContainerView);
        make.height.mas_equalTo(0);
    }];
    
    [self.extensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
#pragma mark -
- (UIButton *)avatarView{
    if (_avatarView == nil) {
        _avatarView = [[UIButton alloc] init];
        [_avatarView setTag:TLMomentViewButtonTypeAvatar];
        [_avatarView addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarView;
}
- (UIButton *)usernameView{
    if (_usernameView == nil) {
        _usernameView = [[UIButton alloc] init];
        _usernameView.tag = TLMomentViewButtonTypeUserName;
        [_usernameView.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [_usernameView setTitleColor:RGBACOLOR(74.0, 99.0, 141.0, 1.0) forState:UIControlStateNormal];
        [_usernameView addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _usernameView;
}
- (UIView *)detailContainerView{
    if (_detailContainerView == nil) {
        _detailContainerView = [[UIView alloc] init];
    }
    return _detailContainerView;
}
- (UIView *)extensionContainerView{
    if (_extensionContainerView == nil) {
        _extensionContainerView = [[UIView alloc] init];
    }
    return _extensionContainerView;
}
- (UILabel *)dateLabel{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setTextColor:[UIColor grayColor]];
        [_dateLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _dateLabel;
}
- (UILabel *)originLabel{
    if (_originLabel == nil) {
        _originLabel = [[UILabel alloc] init];
        [_originLabel setTextColor:[UIColor grayColor]];
        [_originLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _originLabel;
}
- (UIButton *)moreButton{
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setTag:TLMomentViewButtonTypeMore];
        [_moreButton setImage:[UIImage imageNamed:@"moments_more"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"moments_moreHL"] forState:UIControlEventTouchUpInside];
        [_moreButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
- (TLMomentExtensionView *)extensionView{
    if (_extensionView == nil) {
        _extensionView = [[TLMomentExtensionView alloc] init];
    }
    return _extensionView;
}
@end
@interface TLMomentMultiImageView : UIView
@property (nonatomic, assign) id<TLMomentMultiImageViewDelegate> delegate;
@property (nonatomic, strong) NSArray *images;
@end
@interface TLMomentMultiImageView ()
@property (nonatomic, strong) NSMutableArray *imageViews;
@end
@implementation TLMomentMultiImageView
- (void)setImages:(NSArray *)images{
    _images = images;
    for(UIView *v in self.subviews){
        [v removeFromSuperview];
    }
    
    if (images.count == 0) {
        return;
    }
    
    CGFloat imageWidth;
    CGFloat imageHeight;
    if (images.count == 1) {
        imageWidth = WIDTH_IMAGE_ONE;
        imageHeight = imageWidth * 0.8;
    }else{
        imageHeight = imageWidth = WIDTH_IMAGE;
    }
    
    
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i = 0; i < images.count && i < 9; i++) {
        UIButton *imageView;
        if (i < self.imageViews.count) {
            imageView = self.imageViews[i];
        }else{
            imageView = [[UIButton alloc] init];
            [imageView setTag:i];
            [imageView addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.imageViews addObject:imageView];
        }
        [imageView sd_setImageWithURL:images[i] forState:UIControlStateNormal];
        [imageView setFrame:CGRectMake(x, y, imageWidth, imageHeight)];
        [self addSubview:imageView];
        
        if ((i != 0 && images.count != 4 && (i + 1) % 3 == 0) || (images.count == 4 && i == 1)) {
            y += (imageHeight + SPACE);
            x = 0;
        }else{
            x += (imageWidth + SPACE);
        }
    }
}
#pragma mark - Event Response
- (void)buttonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(momentViewClickImage:atIndex:)]) {
        [self.delegate momentViewClickImage:self.images atIndex:sender.tag];
    }
}
@end
@interface TLMomentDetailBaseView : UIView
@property (nonatomic, assign) id<TLMomentDetailViewDelegate> delegate;
@property (nonatomic, strong) TLMomentDetail *detail;
@end
@interface TLMomentDetailTextView : TLMomentDetailBaseView
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation TLMomentDetailBaseView
@end
@implementation TLMomentDetailTextView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.mas_equalTo(self);
        }];
    }
    return self;
}
- (void)setDetail:(TLMomentDetail *)detail{
    [super setDetail:detail];
    [self.titleLabel setText:detail.text];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(detail.detailFrame.heightText);
    }];
}
#pragma mark -
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_titleLabel setNumberOfLines:0];
    }
    return _titleLabel;
}
@end
@interface TLMomentDetailImagesView : TLMomentDetailTextView
@end
@interface TLMomentDetailImagesView ()
@property (nonatomic, strong) TLMomentMultiImageView *multiImageView;
@end
@implementation TLMomentDetailImagesView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.multiImageView];
        
        [self.multiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(self);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }];
    }
    return self;
}
- (void)setDetail:(TLMomentDetail *)detail{
    [super setDetail:detail];
    [self.multiImageView setImages:detail.images];
    CGFloat offset = detail.images.count > 0 ? (detail.text.length > 0 ? 7.0 : 3.0) : 0.0;
    [self.multiImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(offset);
    }];
}
- (void)setDelegate:(id<TLMomentDetailViewDelegate>)delegate{
    [super setDelegate:delegate];
    [self.multiImageView setDelegate:delegate];
}
#pragma mark -
- (TLMomentMultiImageView *)multiImageView{
    if (_multiImageView == nil) {
        _multiImageView = [[TLMomentMultiImageView alloc] init];
        [_multiImageView setDelegate:self.delegate];
    }
    return _multiImageView;
}
@end
@interface TLMomentImageView ()
@property (nonatomic, strong) TLMomentDetailImagesView *detailView;
@end
@implementation TLMomentImageView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.detailContainerView addSubview:self.detailView];
        
        [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.detailContainerView);
        }];
    }
    return self;
}
- (void)setMoment:(TLMoment *)moment{
    [super setMoment:moment];
    [self.detailView setDetail:moment.detail];
}
- (void)setDelegate:(id<TLMomentViewDelegate>)delegate{
    [super setDelegate:delegate];
    [self.detailView setDelegate:delegate];
}
#pragma mark -
- (TLMomentDetailImagesView *)detailView{
    if (_detailView == nil) {
        _detailView = [[TLMomentDetailImagesView alloc] init];
    }
    return _detailView;
}
@end

@interface TLMomentDetailViewController () <TLMomentViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TLMomentImageView *momentView;
@end
@implementation TLMomentDetailViewController
- (id)init{
    if (self = [super init]) {
        [self.navigationItem setTitle:@"详情"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.scrollView];
        [self.scrollView addSubview:self.momentView];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setMoment:(TLMoment *)moment{
    _moment = moment;
    [self.momentView setMoment:moment];
    [self.momentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(moment.momentFrame.height);
    }];
}
#pragma mark - 
//MARK: TLMomentViewDelegate
- (void)momentViewClickImage:(NSArray *)images atIndex:(NSInteger)index{
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:images.count];
    for (NSString *imageUrl in images) {
        MWPhoto *photo = [MWPhoto photoWithURL:TLURL(imageUrl)];
        [data addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:data];
    [browser setDisplayNavArrows:YES];
    [browser setCurrentPhotoIndex:index];
    TLNavigationController *broserNavC = [[TLNavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:broserNavC animated:NO completion:nil];
}
#pragma mark - 
- (void)p_addMasonry{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.momentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
    }];
}
#pragma mark - 
- (TLMomentImageView *)momentView{
    if (_momentView == nil) {
        _momentView = [[TLMomentImageView alloc] init];
        [_momentView setDelegate:self];
    }
    return _momentView;
}
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setAlwaysBounceVertical:YES];
    }
    return _scrollView;
}
@end
