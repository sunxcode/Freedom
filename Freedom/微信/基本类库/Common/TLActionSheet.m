//  TLActionSheet.m
//  Freedom
// Created by Super
#import "TLActionSheet.h"
    
#define     TITLE_FONT_SIZE             13.0f
#define     BUTTON_FONT_SIZE            18.0f
#define     HEIGHT_BUTTON               48.0f
#define     SPACE_MIDDEL                8.0f
#define     SPACE_TITLE_LEFT            22.0f
#define     SPACE_TITLE_TOP             20.0f
#define     COLOR_BACKGROUND            [UIColor colorWithWhite:0.0 alpha:0.4]
#define     COLOR_DESTRUCTIVE_TITLE     [UIColor redColor]
@interface TLActionSheet() <UITableViewDataSource, UITableViewDelegate>{
    NSInteger tableViewButtonCount;
}
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *destructiveButtonTitle;
@property (nonatomic, strong) NSMutableArray *otherButtonTitles;
@property (nonatomic, strong) UIButton *backgroudView;
@property (nonatomic, strong) UIView *actionSheetView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@end
@implementation TLActionSheet
- (instancetype)initWithTitle:(NSString *)title delegate:(id<TLActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    if (self = [super init]) {
        [self setDelegate:delegate];
        [self setTitle:title];
        [self setCancelButtonTitle:cancelButtonTitle];
        [self setDestructiveButtonTitle:destructiveButtonTitle];
        
        va_list list;
        if (otherButtonTitles) {
            self.otherButtonTitles = [[NSMutableArray alloc] initWithCapacity:0];
            [self.otherButtonTitles addObject:otherButtonTitles];
            
            va_start(list, otherButtonTitles);
            NSString *otherTitle = va_arg(list, id);
            while (otherTitle) {
                [self.otherButtonTitles addObject:otherTitle];
                otherTitle = va_arg(list, id);
            }
        }
        
        tableViewButtonCount = self.otherButtonTitles.count + (destructiveButtonTitle ? 1 : 0);
        _numberOfButtons = tableViewButtonCount + (cancelButtonTitle ? 1 : 0);
        _destructiveButtonIndex = (destructiveButtonTitle ? 0 : -1);
        _cancelButtonIndex = (self.cancelButtonTitle ? self.otherButtonTitles.count + (self.destructiveButtonTitle ? 1 : 0) : -1);
        
        [self p_initSubViews];
    }
    return self;
}
#pragma mark - Public Methods
- (void)show{
    [self showInView:[UIApplication sharedApplication].delegate.window];
}
- (void)showInView:(UIView *)view{
    if (view == nil) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    [view addSubview:self];
    
    CGRect rect = CGRectMake(0, self.frameHeight - self.actionSheetView.frameHeight, self.frameWidth, self.actionSheetView.frameHeight);
    [self.backgroudView setBackgroundColor:[UIColor clearColor]];
    [self.actionSheetView setFrameOrigin:CGPointMake(0, self.frameHeight)];
    [UIView animateWithDuration:0.2 animations:^{
        [self.actionSheetView setFrame:rect];
        [self.backgroudView setBackgroundColor:COLOR_BACKGROUND];
    }];
}
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex{
    buttonIndex -= self.destructiveButtonTitle ? 1 : 0;
    if (buttonIndex == -1) {
        return self.destructiveButtonTitle;
    }else if (buttonIndex >= 0 &&  buttonIndex < self.otherButtonTitles.count) {
        return self.otherButtonTitles[buttonIndex];
    }else if (buttonIndex == self.otherButtonTitles.count) {
        return self.cancelButtonTitle;
    }
    return nil;
}
#pragma mark - Event Response
- (void)didTapBackground:(id)sender{
    if (self.cancelButtonTitle && self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:self.cancelButtonIndex];
    }
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
}
- (void)cancelButtonClicked:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:self.cancelButtonIndex];
    }
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
}
#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableViewButtonCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TLActionSheetCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TLActionSheetCell"];
        [cell.textLabel setFont:[UIFont systemFontOfSize:BUTTON_FONT_SIZE]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    if (self.destructiveButtonTitle) {
        if (indexPath.row == 0) {
            [cell.textLabel setTextColor:COLOR_DESTRUCTIVE_TITLE];
            [cell.textLabel setText:self.destructiveButtonTitle];
        }else{
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setText:self.otherButtonTitles[indexPath.row - 1]];
        }
    }else{
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.textLabel setText:self.otherButtonTitles[indexPath.row]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissWithClickedButtonIndex:indexPath.row animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets edgeInset = UIEdgeInsetsZero;
    if ((self.destructiveButtonTitle && indexPath.row >= self.otherButtonTitles.count) || (!self.destructiveButtonTitle && indexPath.row >= self.otherButtonTitles.count - 1)) {
        edgeInset = UIEdgeInsetsMake(0, 0, 0, self.frameWidth);
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edgeInset];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - 
- (void)p_initSubViews{
    [self setFrame:[UIScreen mainScreen].bounds];
    [self addSubview:self.backgroudView];
    [self addSubview:self.actionSheetView];
    [self.actionSheetView addSubview:self.tableView];
    [self.backgroudView setFrame:self.bounds];
    
    NSInteger bottomHeight = 0;
    NSInteger tableHeight = 0;
    if (self.cancelButtonTitle) {
        [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [self.cancelButton setFrame:CGRectMake(0, self.frameHeight - HEIGHT_BUTTON, self.frameWidth, HEIGHT_BUTTON)];
        [self.actionSheetView addSubview:self.cancelButton];
        
        bottomHeight += HEIGHT_BUTTON;
        tableHeight += SPACE_MIDDEL;
    }else{
        [self.cancelButton removeFromSuperview];
    }
    
    {
        if (tableViewButtonCount * HEIGHT_BUTTON > self.frame.size.height - bottomHeight - 20) {
            tableHeight += (self.frame.size.height - bottomHeight - 20);
            [self.tableView setBounces:YES];
        }else{
            tableHeight += (tableViewButtonCount * HEIGHT_BUTTON);
            [self.tableView setBounces:NO];
        }
        
        if (self.title.length > 0) {
            [self.headerTitleLabel setFrame:CGRectMake(SPACE_TITLE_LEFT, SPACE_TITLE_TOP, self.frameWidth - SPACE_TITLE_LEFT * 2, 0)];
            [self.headerTitleLabel setText:self.title];
            CGFloat hightTitle = [self.headerTitleLabel sizeThatFits:CGSizeMake(self.headerTitleLabel.frameWidth, MAXFLOAT)].height;
            [self.headerTitleLabel setFrameHeight:hightTitle];
            
            CGFloat hightHeader = hightTitle + SPACE_TITLE_TOP * 2;
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, hightHeader)];
            [headerView setBackgroundColor:[UIColor whiteColor]];
            [headerView addSubview:self.headerTitleLabel];
            
            if (self.destructiveButtonTitle || tableViewButtonCount > 0) {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, hightHeader - 0.5, self.frameWidth, 0.5)];
                [lineView setBackgroundColor:colorGrayLine];
                [headerView addSubview:lineView];
            }
            [self.tableView setTableHeaderView:headerView];
            tableHeight += hightHeader;
        }
    }
    
    [self.actionSheetView setFrame:CGRectMake(0, self.frame.size.height - bottomHeight - tableHeight, self.frame.size.width, bottomHeight + tableHeight)];
    [self.tableView setFrame:CGRectMake(0, 0, self.frameWidth, tableHeight)];
    [self.cancelButton setFrame:CGRectMake(0, tableHeight, self.frameWidth, HEIGHT_BUTTON)];
}
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self willDismissWithButtonIndex:buttonIndex];
    }
    
    if (animated) {
        CGRect rect = CGRectMake(0, self.frameHeight, self.frameWidth, self.actionSheetView.frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            [self.actionSheetView setFrame:rect];
            [self.backgroudView setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
                [self.delegate actionSheet:self didDismissWithButtonIndex:buttonIndex];
            }
        }];
    }else{
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
            [self.delegate actionSheet:self didDismissWithButtonIndex:buttonIndex];
        }
    }
}
#pragma mark - 
 
- (UIButton *)backgroudView{
    if (_backgroudView == nil) {
        _backgroudView = [[UIButton alloc] init];
        [_backgroudView setBackgroundColor:[UIColor blueColor]];
        [_backgroudView addTarget:self action:@selector(didTapBackground:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroudView;
}
- (UIView *)actionSheetView{
    if (_actionSheetView == nil) {
        _actionSheetView = [[UIView alloc] init];
        [_actionSheetView setBackgroundColor:[UIColor whiteColor]];
    }
    return _actionSheetView;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setRowHeight:HEIGHT_BUTTON];
        [_tableView setBackgroundColor:colorGrayBG];
        [_tableView setSeparatorColor:colorGrayLine];
        [_tableView setTableFooterView:[UIView new]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}
- (UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:BUTTON_FONT_SIZE]];
        [_cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:colorGrayLine] forState:UIControlStateHighlighted];
    }
    return _cancelButton;
}
- (UILabel *)headerTitleLabel{
    if (_headerTitleLabel == nil) {
        _headerTitleLabel = [[UILabel alloc] init];
        [_headerTitleLabel setTextColor:[UIColor grayColor]];
        [_headerTitleLabel setFont:[UIFont systemFontOfSize:TITLE_FONT_SIZE]];
        [_headerTitleLabel setNumberOfLines:0];
        [_headerTitleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _headerTitleLabel;
}
@end
