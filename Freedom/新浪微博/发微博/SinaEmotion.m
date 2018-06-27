//  XFEmotion.m
//  
//  Created by Super on 15/10/18.
//
#import "SinaEmotion.h"
@interface SinaEmotion () <NSCoding>
@end
@implementation SinaEmotion
MJCodingImplementation
- (BOOL)isEqual:(SinaEmotion *)other{
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
}
@end
@class SinaEmotionTabBar;
@protocol XFEmotionTabBarDelegate <NSObject>
@optional
- (void)emotionTabBar:(SinaEmotionTabBar *)tabBar didSelectButton:(XFEmotionTabBarButtonType)buttonType;
@end
@interface SinaEmotionTabBar : UIView
@property (nonatomic, weak) id<XFEmotionTabBarDelegate> delegate;
@end
@interface SinaEmotionTabBar()
@property (nonatomic, weak) UIButton *selectedBtn;
@end
@implementation SinaEmotionTabBar
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtn:@"最近" buttonType:XFEmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:XFEmotionTabBarButtonTypeDefault];
        [self setupBtn:@"Emoji" buttonType:XFEmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:XFEmotionTabBarButtonTypeLxh];
    }
    return self;
}
- (UIButton *)setupBtn:(NSString *)title buttonType:(XFEmotionTabBarButtonType)buttonType {
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];

    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    if (buttonType == XFEmotionTabBarButtonTypeDefault) {
        [self btnClick:btn];
    }
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    } else if (self.subviews.count == 4) {
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    return btn;
}
//重写delegate 方法
-(void)setDelegate:(id<XFEmotionTabBarDelegate>)delegate {
    _delegate = delegate;
    [self btnClick:(UIButton *)[self viewWithTag:XFEmotionTabBarButtonTypeDefault]];
}
/*按钮点击*/
- (void)btnClick:(UIButton *)btn {
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:(int)btn.tag];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.frame.size.width / btnCount;
    CGFloat btnH = self.frameHeight;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
    }
}
@end
@implementation SinaEmotionAttachment
- (void)setEmotion:(SinaEmotion *)emotion{
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.png];
}
@end
@implementation SinaTextView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
-(void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}
-(void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setNeedsDisplay];
}
//移除通知
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}
/**
 * 监听文字改变*/
-(void)textDidChange {
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect {
    if (self.hasText) return;
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = self.font;
    attr[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];
}
@end
@implementation SinaEmotionTextView
-(void)insertEmotion:(SinaEmotion *)emotion {
    if (emotion.code) {
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
        SinaEmotionAttachment *attch = [[SinaEmotionAttachment alloc] init];
        attch.emotion = emotion;
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
        //拼接之前的文件
        [attributedText appendAttributedString:self.attributedText];
        NSUInteger loc = self.selectedRange.location;
        //[attributedText insertAttributedString:text atIndex:loc];
        [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:imageStr];
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        self.attributedText = attributedText;
        self.selectedRange = NSMakeRange(loc + 1, 0);
    }
}
- (NSString *)fullText{
    NSMutableString *fullText = [NSMutableString string];
    // 遍历所有的属性文字（图片、emoji、普通文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        SinaEmotionAttachment *attch = attrs[@"NSAttachment"];
        if (attch) { // 图片
            [fullText appendString:attch.emotion.chs];
        } else {
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    return fullText;
}
@end
@interface SinaEmotionPageView : UIView
/** 这一页显示的表情（里面都是XFEmotion模型） */
@property (nonatomic, strong) NSArray *emotions;
@end
@class SinaEmotion;
@interface SinaEmotionTool : NSObject
+ (void)addRecentEmotion:(XFEmotion *)emotion;
+ (NSArray *)recentEmotions;
@end
@implementation SinaEmotionTool
static NSMutableArray *_recentEmotions;
+ (void)initialize{
    NSString *XFRecentEmotionsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"];
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:XFRecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}
+ (void)addRecentEmotion:(XFEmotion *)emotion{
    NSString *XFRecentEmotionsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"];
    [_recentEmotions removeObject:emotion];
    [_recentEmotions insertObject:emotion atIndex:0];
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:XFRecentEmotionsPath];
}
/*返回装着XFEmotion模型的数组*/
+ (NSArray *)recentEmotions{
    return _recentEmotions;
}
@end
@class SinaEmotion;
@interface SinaEmotionButton : UIButton
@property (nonatomic, strong) SinaEmotion *emotion;
@end
@implementation SinaEmotionButton
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}
- (void)setEmotion:(SinaEmotion *)emotion{
    _emotion = emotion;
    if (emotion.png) { // 有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (emotion.code) { // 是emoji表情
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}
@end
@interface SinaEmotionPageView ()
@property (nonatomic, weak) UIButton *deleteButton;
@end
@implementation SinaEmotionPageView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *deleteButton = [[UIButton alloc]init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
    }
    return self;
}
-(void)setEmotions:(NSArray *)emotions {
    _emotions = emotions;
    NSUInteger count = emotions.count;
    for (int i = 0; i<count; i++) {
        SinaEmotionButton *btn = [[SinaEmotionButton alloc]init];
        [self addSubview:btn];
        btn.emotion = emotions[i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//监听删除按钮点击
-(void)deleteClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmotionDidDeleteNotification" object:nil];
}
-(void)btnClick:(SinaEmotionButton *)btn{
    [self selectEmotion:btn.emotion];
}
-(void)selectEmotion:(XFEmotion *)emotion {
    [SinaEmotionTool addRecentEmotion:emotion];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"SelectEmotionKey"] = emotion;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EmotionDidSelectNotification" object:nil userInfo:userInfo];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat inset = 20;
    NSUInteger count = self.emotions.count;
    CGFloat btnw = (self.frame.size.width - 2 * inset) /7;
    CGFloat btnH = (self.frameHeight - inset) /3;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i+1];
        btn.frame = CGRectMake(inset + (i%7) * btnw, inset + (i/7) * btnH, btnw, btnH);
    }
    self.deleteButton.frame = CGRectMake(self.frame.size.width - inset - btnw,  self.frameHeight - btnH, btnw, btnH);
}
@end
@interface SinaEmotionListView : UIView
/** 表情(里面存放的XFEmotion模型) */
@property (nonatomic, strong) NSArray *emotions;
@end
@interface SinaEmotionListView ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;
@end
@implementation SinaEmotionListView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 1.UIScollView
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        //私有属性，使用KVC赋值
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}
// 根据emotions，创建对应个数的表情
-(void)setEmotions:(NSArray *)emotions {
    _emotions = emotions;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger count = (emotions.count + 20 - 1) /20;
    self.pageControl.numberOfPages = count;
    for (int i = 0; i<self.pageControl.numberOfPages; i++) {
        SinaEmotionPageView *pageView = [[SinaEmotionPageView alloc]init];
        NSRange range;
        range.location  = i *20;
        NSUInteger left = emotions.count - range.location;
        if (left >= 20) {
            range.length = 20;
        }else {
            range.length = left;
        }
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    [self setNeedsLayout];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, self.frameHeight - self.pageControl.frameHeight, self.frame.size.width, 35);
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.pageControl.frameY);
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i<count; i++) {
        SinaEmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.frame = CGRectMake(i * pageView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frameHeight);
    }
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.frame.size.width, 0);
}
#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = (int)(pageNum + 0.5);
}
@end
@interface SinaEmotionKeyboard()<XFEmotionTabBarDelegate>
/** 保存正在显示listView */
@property (nonatomic, weak) SinaEmotionListView *showingListView;
/** 表情内容 */
@property (nonatomic, strong) SinaEmotionListView *recentListView;
@property (nonatomic, strong) SinaEmotionListView *defaultListView;
@property (nonatomic, strong) SinaEmotionListView *emojiListView;
@property (nonatomic, strong) SinaEmotionListView *lxhListView;
/** tabbar */
@property (nonatomic, weak) SinaEmotionTabBar *tabBar;
@end
@implementation SinaEmotionKeyboard
#pragma mark - 懒加载
-(SinaEmotionListView *)recentListView{
    if (!_recentListView) {
        self.recentListView = [[SinaEmotionListView alloc] init];
        //加载沙盒中的数据
        self.recentListView.emotions = [SinaEmotionTool recentEmotions];
    }
    return _recentListView;
}
-(SinaEmotionListView *)defaultListView {
    if (!_defaultListView) {
        self.defaultListView = [[SinaEmotionListView alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        self.defaultListView.emotions = [SinaEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultListView;
}
- (SinaEmotionListView *)emojiListView{
    if (!_emojiListView) {
        self.emojiListView = [[SinaEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiListView.emotions = [SinaEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiListView;
}
- (SinaEmotionListView *)lxhListView{
    if (!_lxhListView) {
        self.lxhListView = [[SinaEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        self.lxhListView.emotions = [SinaEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhListView;
}
-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // tabbar
        SinaEmotionTabBar *tabbar = [[SinaEmotionTabBar alloc]init];
        tabbar.delegate = self;
        [self addSubview:tabbar];
        self.tabBar = tabbar;
        // 表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:@"EmotionDidSelectNotification" object:nil];
    }
    return self;
}
-(void)emotionDidSelect {
    self.recentListView.emotions = [SinaEmotionTool recentEmotions];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.tabBar.frame = CGRectMake(0, self.frameHeight - self.tabBar.frameHeight, self.frame.size.width, 37) ;
    self.showingListView.frame = CGRectMake(0,0,self.frame.size.width,self.tabBar.frameY);
}
#pragma mark - XFEmotionTabBarDelegate
- (void)emotionTabBar:(SinaEmotionTabBar *)tabBar didSelectButton:(XFEmotionTabBarButtonType)buttonType {
    [self.showingListView removeFromSuperview];
    switch (buttonType) {
        case XFEmotionTabBarButtonTypeDefault:{//默认
            [self addSubview:self.defaultListView];break;
        }
        case XFEmotionTabBarButtonTypeLxh:{//浪小花
            [self addSubview:self.lxhListView];break;
        }
        case XFEmotionTabBarButtonTypeEmoji:{ //Emoji
            [self addSubview:self.emojiListView];break;
        }
        case XFEmotionTabBarButtonTypeRecent:{ //最近
            [self addSubview:self.recentListView];
            break;
        }
    }
    self.showingListView = [self.subviews lastObject];
    // 重新计算子控件的frame(setNeedsLayout内部会在恰当的时刻，重新调用layoutSubviews，重新布局子控件)
    [self setNeedsLayout];
}
@end
@interface SinaComposeToolbar()
@property (nonatomic, weak) UIButton *emotionButton;
@end
@implementation SinaComposeToolbar
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:XFComposeToolbarButtonTypeCamera];
        [self setupBtn:@"u_album_gray" highImage:@"u_album_y" type:XFComposeToolbarButtonTypePicture];
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:XFComposeToolbarButtonTypeMention];
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:XFComposeToolbarButtonTypeTrend];
        self.emotionButton = [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:XFComposeToolbarButtonTypeEmotion];
    }
    return self;
}
- (void)setShowKeyboardButton:(BOOL)showKeyboardButton{
    _showKeyboardButton = showKeyboardButton;
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    if (showKeyboardButton) {
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    // 设置图片
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}
/**
 * 创建一个按钮*/
- (UIButton *)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(XFComposeToolbarButtonType)type{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    return btn;
}
-(void)btnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
        [self.delegate composeToolbar:self didClickButton:(int)btn.tag];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.frame.size.width / count;
    CGFloat btnH = self.frameHeight;
    for (NSUInteger i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
    }
}
@end
@implementation SinaComposePhotosView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}
-(void)addPhoto:(UIImage *)photo {
    UIImageView *photoView = [[UIImageView alloc]init];
    photoView.image = photo;
    [self addSubview:photoView];
    [self.photos addObject:photo];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 80;
    CGFloat imageMargin = 10;
    for (int i = 0 ; i<count; i++) {
        UIImageView *image = self.subviews[i];
        int col = i % maxCol;
        int row = i / maxCol;
        image.frame = CGRectMake(col * (imageWH + imageMargin) + imageMargin, row * (imageWH + imageMargin), imageWH, imageWH);
    }
    
}
@end
