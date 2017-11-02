//
//  TitleScrollView.m
//  titleScrollViewTest
//
//  Created by GCF on 16/5/17.
//  Copyright © 2016年 GCF. All rights reserved.
//

#import "TitleScrollView.h"
@implementation TitleScrollView{
    UIButton       *selectedButt;
    SelectBlock    block;
    NSMutableArray *buttonArray;
    BOOL           isEqualWidth;
}
/**
 *  创建一个标题滚动栏
 *  @param frame          布局
 *  @param titleArray     标题数组
 *  @param selected_index 默认选中按钮的索引
 *  @param scrollEnable   能否滚动
 *  @param isEqual        下面的条子是否按数量等分宽度 YES:等分 NO:按照标题宽度
 *  @param selectBlock    点击标题回调方法
 *  @return 滚动视图对象
 */
-(instancetype)initWithFrame:(CGRect)frame
                  TitleArray:(NSArray *)titleArray
               selectedIndex:(NSInteger)selected_index
                scrollEnable:(BOOL)scrollEnable
              lineEqualWidth:(BOOL)isEqual
               color:(UIColor *)color
              selectColor:(UIColor *)selectColor
                 SelectBlock:(SelectBlock)selectBlock;
{
    self =[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        CGFloat orign_x = 0;
        CGFloat height = self.frame.size.height;
        
        CGFloat space = scrollEnable?20:[TitleScrollHelper caculateSpaceByTitleArray:titleArray rect:frame];
        buttonArray = [NSMutableArray new];
        block = selectBlock;
        isEqualWidth = isEqual;
        for (int i = 0; i<titleArray.count; i++)
        {
            NSString *title =titleArray[i];
            CGSize size = [TitleScrollHelper titleSize:title height:frame.size.height];
            self.titleButton =[UIButton buttonWithType:UIButtonTypeCustom];
            self.titleButton.frame = CGRectMake(orign_x, 0, size.width+space, height);
            [self.titleButton setTitle:title forState:UIControlStateNormal];
            [self.titleButton setTitleColor:color forState:UIControlStateNormal];
            [self.titleButton setTitleColor:selectColor forState:UIControlStateSelected];
            [self.titleButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            self.titleButton.titleLabel.font =titleFont;
            self.titleButton.tag = i;
            orign_x = orign_x+space+size.width;
            self.contentSize = CGSizeMake(orign_x, height);
            if (i == selected_index)
            {
                [self.titleButton setSelected:YES];
                selectedButt = self.titleButton;
                self.line =[[UILabel alloc]init];
                self.line.backgroundColor = selectColor;
                [self addSubview:self.line];
            }
             [buttonArray addObject:self.titleButton];
             [self addSubview:self.titleButton];
            
        }
        [self buttonOffset:selectedButt];
    }
    return self;
}
//按钮点击
-(void)headButtonClick:(UIButton *)butt{
    [self buttonOffset:butt animated:YES];
    for (UIButton *button in buttonArray){
        BOOL isSelected = button.tag == butt.tag?YES:NO;
        [button setSelected:isSelected];
    }block(butt.tag);
}
//点击控制滚动视图的偏移量
-(void)buttonOffset:(UIButton *)butt animated:(BOOL)animated{
    if (animated){
        [UIView animateWithDuration:0.2 animations:^{
            [self buttonOffset:butt];
        }];
    }else{
        [self buttonOffset:butt];
    }
}

-(void)buttonOffset:(UIButton *)butt{
    CGSize size = [TitleScrollHelper titleSize:butt.titleLabel.text height:butt.frame.size.height];
    CGFloat width = isEqualWidth?self.frame.size.width/buttonArray.count:size.width;
    self.line.bounds = CGRectMake(0, 0, width, 3);
    self.line.center = CGPointMake(butt.center.x, butt.frame.size.height-0.75);
    for (UIButton *button in buttonArray){
        BOOL isSelected = button.tag == butt.tag?YES:NO;
        [button setSelected:isSelected];
    }
    if (butt.center.x<=self.center.x){
        self.contentOffset = CGPointMake(0, 0);
    }else if ((butt.center.x>self.center.x)&&((self.contentSize.width-butt.center.x)>(self.frame.size.width/2.0))){
        self.contentOffset = CGPointMake(butt.center.x-self.center.x, 0);
    }else{
        self.contentOffset = CGPointMake(self.contentSize.width-self.frame.size.width, 0);
    }
}
/**
 *  修改选中标题
 *  @param selectedIndex 选中标题的索引
 */
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    for (UIButton *butt in buttonArray){
        if (butt.tag == selectedIndex){
            [self buttonOffset:butt animated:YES];break;
        }
    }
}
@end
