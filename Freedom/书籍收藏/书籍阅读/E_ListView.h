//  E_ListView.h
//  Freedom
//  Created by Super on 15/2/15.
#import <UIKit/UIKit.h>
#import "E_CommonManager.h"
#import "E_Mark.h"
@protocol E_ListViewDelegate <NSObject>
- (void)clickMark:(E_Mark *)eMark;
- (void)clickChapter:(NSInteger)chaperIndex;
- (void)removeE_ListView;
@end
@interface E_ListView : UIView<UITableViewDataSource,UITableViewDelegate>{
   
    UISegmentedControl *_segmentControl;
    NSInteger dataCount;
    NSMutableArray *_dataSource;
    CGFloat  _panStartX;
    BOOL    _isMenu;
    BOOL    _isMark;
    BOOL    _isNote;
}
@property (nonatomic,assign)id<E_ListViewDelegate>delegate;
@property (nonatomic,strong)UITableView *listView;
@end
