
//  Weibo
//
//  Created by Fay on 15/9/23.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFUser.h"

@implementation XFUser

+(instancetype)userWithDict:(NSDictionary *)dict {
    
    XFUser * user= [[self alloc]init];
    user.name = dict[@"name"];
    user.idstr = dict[@"idstr"];
    user.profile_image_url = dict[@"profile_image_url"];
    
    return user;
    
}

-(void)setMbtype:(int)mbtype {
    
    _mbtype = mbtype;
    self.vip = mbtype > 2;
    
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com