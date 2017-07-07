
#import "RHMethods.h"
@implementation RHMethods


+ (UITextField *)textFieldlWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor placeholder:(NSString *)aplaceholder text:(NSString*)atext{
   UITextField *baseTextField=[[UITextField alloc]initWithFrame:aframe];
    [baseTextField setKeyboardType:UIKeyboardTypeDefault];
    [baseTextField setBorderStyle:UITextBorderStyleNone];
    [baseTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [baseTextField setTextColor:acolor];
    baseTextField.placeholder=aplaceholder;
    baseTextField.font=afont;
    [baseTextField setSecureTextEntry:NO];
    [baseTextField setReturnKeyType:UIReturnKeyDone];
    [baseTextField setText:atext];
    baseTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return baseTextField;
}

/**
 *	根据aframe返回相应高度的label（默认透明背景色，白色高亮文字）
 *
 *	@param	aframe	预期框架 若height=0则计算高度  若width=0则计算宽度
 *	@param	afont	字体
 *	@param	acolor	颜色
 *	@param	atext	内容
 *
 *	@return	UILabel
 */
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext
{
    return [self labelWithFrame:aframe font:afont color:acolor text:atext textAlignment:NSTextAlignmentLeft];// autorelease];
}

/**
 *	根据aframe返回相应高度的label（默认透明背景色，白色高亮文字）
 *
 *	@param	aframe	预期框架 若height=0则计算高度  若width=0则计算宽度
 *	@param	afont	字体
 *	@param	acolor	颜色
 *	@param	atext	内容
 *  @param  aalignment   位置
 *  @param  afloat   行距
 *
 *	@return	UILabel
 */
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment setLineSpacing:(float)afloat
{
    UILabel *lblTemp=[self labelWithFrame:aframe font:afont color:acolor text:atext textAlignment:aalignment];
    if (!aframe.size.height) {
        lblTemp.numberOfLines=0;
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lblTemp.text];
        NSMutableParagraphStyle *paragraphStyleT = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyleT setLineSpacing:afloat];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleT range:NSMakeRange(0, [atext length])];
        lblTemp.attributedText = attributedString;
        
        CGSize size = [lblTemp sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        lblTemp.frame=aframe;
        
    }
    return lblTemp;
}

+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment
{
    UILabel *baseLabel=[[UILabel alloc] initWithFrame:aframe];
    if(afont)baseLabel.font=afont;
    if(acolor)baseLabel.textColor=acolor;
    // baseLabel.lineBreakMode=UILineBreakModeCharacterWrap;
    baseLabel.text=atext;
    baseLabel.textAlignment=aalignment;
    baseLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    if(aframe.size.height>20){
        baseLabel.numberOfLines=0;
    }
    if (!aframe.size.height) {
        baseLabel.numberOfLines=0;
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        baseLabel.frame = aframe;
    }else if (!aframe.size.width) {
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
        aframe.size.width = size.width;
        baseLabel.frame = aframe;
    }
//    baseLabel.adjustsFontSizeToFitWidth=YES
    baseLabel.backgroundColor=[UIColor clearColor];
    baseLabel.highlightedTextColor=acolor;//[UIColor whiteColor];
    return baseLabel;// autorelease];
}

+(UIButton*)buttonWithFrame:(CGRect)_frame title:(NSString*)_title image:(NSString*)_image bgimage:(NSString*)_bgimage
{
    UIButton *baseButton=[UIButton buttonWithType:UIButtonTypeCustom];//[[UIButton alloc] initWithFrame:_frame];
    baseButton.frame=_frame;
    baseButton.titleLabel.font=Font(16);
    if (_title) {
        [baseButton setTitle:_title forState:UIControlStateNormal];
        [baseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (_image) {
        [baseButton setImage:[UIImage imageNamed:_image] forState:UIControlStateNormal];
    }
    if (_bgimage) {
        UIImage *bg = [UIImage imageNamed:_bgimage];
        [baseButton setBackgroundImage:bg forState:UIControlStateNormal];
        if (_frame.size.height<0.00001) {
            _frame.size.height = bg.size.height*_frame.size.width/bg.size.width;
            [baseButton setFrame:_frame];
        }else if(_frame.size.width<0.00001) {
            _frame.size.width = bg.size.width*_frame.size.height/bg.size.height;
            _frame.origin.x = (kScreenWidth-_frame.size.width)/2.0;
            [baseButton setFrame:_frame];
        }
    }
    
    return baseButton;// autorelease];
}
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image
{
    return [self imageviewWithFrame:_frame defaultimage:_image stretchW:0 stretchH:0];// autorelease];
}
//-1 if want stretch half of image.size
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image stretchW:(NSInteger)_w stretchH:(NSInteger)_h
{
    UIImageView *imageview = nil;
    if(_image){
        if (_w&&_h) {
            UIImage *image = [UIImage imageNamed:_image];
            if (_w==-1) {
                _w = image.size.width/2;
            }
            if(_h==-1){
                _h = image.size.height/2;
            }
            imageview = [[UIImageView alloc] initWithImage:
                         [image stretchableImageWithLeftCapWidth:_w topCapHeight:_h]];
            imageview.contentMode=UIViewContentModeScaleToFill;
        }else{
            imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_image]];
            imageview.contentMode=UIViewContentModeScaleAspectFill;
        }
    }
    if (CGRectIsEmpty(_frame)) {
        [imageview setFrame:CGRectMake(_frame.origin.x,_frame.origin.y, imageview.image.size.width, imageview.image.size.height)];
    }else{
        [imageview setFrame:_frame];
    }
    imageview.clipsToBounds=YES;
    return  imageview;// autorelease];
}

@end