//
//  UIViewController+LoadingSuperView.m
//  TTTFramework
//
//  Created by jia on 2017/1/11.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UIViewController+LoadingSuperView.h"

@implementation UIViewController (LoadingSuperView)

- (UIView *)loadingSuperView
{
    return self.view;
}

- (void)doExtraWhenShowLoading
{
    // nothing
}

- (void)doExtraWhenHideLoading
{
    // nothing
}

@end
