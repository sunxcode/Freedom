//  TLContact.h
//  Freedom
// Created by Super
/*通讯录 Model*/
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, TLContactStatus) {
    TLContactStatusStranger,
    TLContactStatusFriend,
    TLContactStatusWait,
};
@interface TLContact : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarPath;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, assign) TLContactStatus status;
@property (nonatomic, assign) int recordID;
@property (nonatomic, assign) NSString *email;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *pinyinInitial;
@end
