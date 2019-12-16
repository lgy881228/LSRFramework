//
//  UIViewController+LoadingSuperView.h
//  TTTFramework
//
//  Created by jia on 2017/1/11.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LoadingSuperView)

- (UIView *)loadingSuperView;

- (void)doExtraWhenShowLoading;
- (void)doExtraWhenHideLoading;

@end
