//  TLEmoji.h
//  Freedom
// Created by Super
@interface TLEmoji : NSObject
@property (nonatomic, assign) TLEmojiType type;
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *emojiID;
@property (nonatomic, strong) NSString *emojiName;
@property (nonatomic, strong) NSString *emojiPath;
@property (nonatomic, strong) NSString *emojiURL;
@property (nonatomic, assign) CGFloat size;
@end
