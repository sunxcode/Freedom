//
//  XFSearchBar.m
//  Weibo
//
//  Created by Fay on 15/9/16.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFSearchBar.h"

@implementation XFSearchBar

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        self.placeholder = @"请输入要搜索的内容";
        self.font = [UIFont systemFontOfSize:13];
        UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:Psearch_gray]];
        
        searchIcon.frameWidth = 30;
        
        searchIcon.frameHeight = 30;
        
        self.leftView = searchIcon;
        
        searchIcon.contentMode = UIViewContentModeCenter;
        
        self.leftViewMode = UITextFieldViewModeAlways;
     
    }

    return self;    
}





+(instancetype)searchBar {
 
    return [[self alloc]init];
    
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
