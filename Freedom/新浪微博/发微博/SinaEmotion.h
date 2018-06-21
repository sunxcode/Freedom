//  XFEmotion.h
//  
//  Created by Super on 15/10/18.
//
#import <Foundation/Foundation.h>
typedef enum {
    XFComposeToolbarButtonTypeCamera, // 拍照
    XFComposeToolbarButtonTypePicture, // 相册
    XFComposeToolbarButtonTypeMention, // @
    XFComposeToolbarButtonTypeTrend, // #
    XFComposeToolbarButtonTypeEmotion // 表情
} XFComposeToolbarButtonType;
typedef enum {
    XFEmotionTabBarButtonTypeRecent, // 最近
    XFEmotionTabBarButtonTypeDefault, // 默认
    XFEmotionTabBarButtonTypeEmoji, // emoji
    XFEmotionTabBarButtonTypeLxh, // 浪小花
    
} XFEmotionTabBarButtonType;
@interface SinaEmotionKeyboard : UIView
@end
@interface SinaComposePhotosView : UIView
-(void)addPhoto:(UIImage *)photo;
@property (nonatomic, strong,readonly) NSMutableArray *photos;
@end
@interface SinaTextView : UITextView
/** 占位文字 */
@property (nonatomic,copy)NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic,strong)UIColor *placeholderColor;
@end
@class XFEmotion;
@interface SinaEmotionTextView : SinaTextView
-(void)insertEmotion:(XFEmotion *)emotion;
- (NSString *)fullText;
@end
@class SinaEmotion;
@interface SinaEmotionAttachment : NSTextAttachment
@property (nonatomic, strong) SinaEmotion *emotion;
@end
@class SinaComposeToolbar;
@protocol XFComposeToolbarDelegate <NSObject>
@optional
-(void)composeToolbar:(SinaComposeToolbar *)toolbar didClickButton:(XFComposeToolbarButtonType)buttonType;
@end
@interface SinaComposeToolbar : UIView
@property (nonatomic,weak) id<XFComposeToolbarDelegate> delegate;
/** 是否要显示键盘按钮  */
@property (nonatomic, assign) BOOL showKeyboardButton;
@end
@interface SinaEmotion : NSObject
/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的16进制编码 */
@property (nonatomic, copy) NSString *code;
@end
