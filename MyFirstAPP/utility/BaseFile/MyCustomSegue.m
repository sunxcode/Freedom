//
//  MyCustomSegue.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/18.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "MyCustomSegue.h"

@implementation MyCustomSegue
//-(void)perform{
//    UIViewController * svc = self.sourceViewController;
//    UIViewController * dvc = self.destinationViewController;
//    [svc.view addSubview:dvc.view];
//    [dvc.view setFrame:svc.view.frame];
//    [dvc.view setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
//    [dvc.view setAlpha:0.0];
//    [UIView animateWithDuration:5.0
//                     animations:^{
//                         [dvc.view setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
//                         [dvc.view setAlpha:1.0];
//                     }
//                     completion:^(BOOL finished) {
////                         [dvc.view removeFromSuperview];
//                     }];
//}
-(void)perform{
    UIViewController * svc = self.sourceViewController;
    UIViewController * dvc = self.destinationViewController;
//    [svc showViewController:dvc sender:svc];
    dvc.modalPresentationStyle = UIModalPresentationFormSheet;
    [svc presentViewController:dvc animated:YES completion:NULL];
}

@end
