//
//  TitleScrollView.h
//  titleScrollViewTest
//
//  Created by GCF on 16/5/17.
//  Copyright © 2016年 GCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleScrollHelper.h"
@interface TitleScrollView : UIScrollView
typedef void (^SelectBlock)(NSInteger index);
/**
 *  创建一个标题滚动栏
 *  @param frame          布局
 *  @param titleArray     标题数组
 *  @param selected_index 默认选中按钮的索引
 *  @param scrollEnable   能否滚动
 *  @param isEqual        下面的条子是否按数量等分宽度 YES:等分 NO:按照标题宽度
 *  @param selectBlock    点击标题回调方法
 *
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
/**
 *  修改选中标题
 *  @param selectedIndex 选中标题的索引
 */
-(void)setSelectedIndex:(NSInteger)selectedIndex;
/**
 *  把按钮放出来以便改变可以其颜色 （陈亮）
 */
@property (nonatomic,strong) UIButton *titleButton;
/**
 *  把line放出来,有的界面不需要显示,直接隐藏它 (郭长峰)
 */
@property (nonatomic,strong) UILabel        *line;
@end
