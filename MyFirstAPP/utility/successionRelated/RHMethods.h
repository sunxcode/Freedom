

#import <Foundation/Foundation.h>
#import "Foundation.h"
@interface RHMethods : NSObject
+ (UITextField *)textFieldlWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor placeholder:(NSString *)aplaceholder text:(NSString*)atext;
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext;
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment;
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment setLineSpacing:(float)afloat;
+(UIButton*)buttonWithFrame:(CGRect)_frame title:(NSString*)_title  image:(NSString*)_image bgimage:(NSString*)_bgimage;
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image;
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image stretchW:(NSInteger)_w stretchH:(NSInteger)_h;
@end
