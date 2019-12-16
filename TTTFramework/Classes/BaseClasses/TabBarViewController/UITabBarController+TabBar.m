//
//  UITabBarController+TabBar.m
//  TTTFramework
//
//  Created by jia on 2017/11/12.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UITabBarController+TabBar.h"

#define kAnimationDuration 0.3

@implementation UITabBarController (TabBar)

- (BOOL)isTabBarShowing
{
    CGFloat screenHeight = CGRectGetMaxY(self.view.frame);
    CGFloat tabBarOrigin = CGRectGetMinY(self.tabBar.frame);
    return tabBarOrigin < screenHeight;
}

- (void)showTabBar
{
    if (!self.isTabBarShowing) {
        CGRect tabBarRect = self.tabBar.frame;
        tabBarRect.origin.y -= CGRectGetHeight(self.tabBar.bounds);

        [UIView animateWithDuration:kAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            [self.tabBar setFrame:tabBarRect];
        }
                         completion:^(BOOL finished) {
        }];
    }
}

- (void)hideTabBar
{
    if (self.isTabBarShowing) {
        CGRect tabBarRect = self.tabBar.frame;
        tabBarRect.origin.y += CGRectGetHeight(self.tabBar.bounds);

        [UIView animateWithDuration:kAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            [self.tabBar setFrame:tabBarRect];
        }
                         completion:^(BOOL finished) {
        }];
    }
}

- (BOOL)isTabBarHidden {
    CGRect viewFrame = self.view.frame;
    CGRect tabBarFrame = self.tabBar.frame;
    return tabBarFrame.origin.y >= viewFrame.size.height;
}

- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    BOOL isHidden = self.tabBarHidden;
    if (hidden == isHidden) return;

    UIView *transitionView = [[[self.view.subviews reverseObjectEnumerator] allObjects] lastObject];
    if (transitionView == nil) {
        NSLog(@"could not get the container view!");
        return;
    }

    CGRect viewFrame = self.view.frame;
    CGRect tabBarFrame = self.tabBar.frame;
    CGRect containerFrame = transitionView.frame;
    tabBarFrame.origin.y = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
    containerFrame.size.height = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.tabBar.frame = tabBarFrame;
                         transitionView.frame = containerFrame;
                     }];
}

@end
