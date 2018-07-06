//
//  RCAnimatedImagesView.h
//  Freedom
//
//  Created by Super on 7/6/18.
//  Copyright © 2018 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCAnimatedImagesView : UIView
@property(nonatomic, assign) NSTimeInterval timePerImage;
- (void)startAnimating;
- (void)stopAnimating;
- (void)reloadData;
@end
