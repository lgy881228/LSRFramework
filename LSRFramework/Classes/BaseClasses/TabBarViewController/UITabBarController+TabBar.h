//
//  UITabBarController+TabBar.h
//  TTTFramework
//
//  Created by jia on 2017/11/12.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (TabBar)

@property (nonatomic, readonly) BOOL isTabBarShowing;

- (void)showTabBar;
- (void)hideTabBar;

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
