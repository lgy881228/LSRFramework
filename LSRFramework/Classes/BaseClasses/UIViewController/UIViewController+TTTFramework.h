//
//  UIViewController+TTTFramework.h
//  TTTFramework
//
//  Created by jia on 2016/11/15.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Helper.h"

@interface UIViewController (TTT)

// defaults to YES;
@property (nonatomic, readwrite, getter=isFirstTimeViewAppear) BOOL firstTimeViewAppear;

// defaults to YES;
@property (nonatomic, readonly, getter=isViewActive) BOOL viewActive;

#pragma mark - Navigation Bar
// 整体刷新导航栏样式
- (void)navigationBarStylesToFit;

// 刷新导航栏某一项的样式
- (void)navigationBarColorToFit;
- (void)navigationBarShadowImageToFit;
- (void)navigationBarTitleAttributesToFit;

- (void)navigationItemStyleToFit;

#pragma mark - Status Bar
- (UIStatusBarStyle)statusBarStyle;

// 自动调整状态栏
- (void)statusBarStyleToFit;
- (void)statusBarStyleToFitColor:(UIColor *)navigationBarColor animated:(BOOL)animated;

// 返回与传入颜色匹配的状态栏风格
- (UIStatusBarStyle)statusBarStyleToColor:(UIColor *)navigationBarColor;

#pragma mark - Tools
+ (BOOL)isMainThread;
- (BOOL)isMainThread;
- (void)dispatchMainThread:(void (^)(void))selector;

- (CGRect)visibleAreaFrame;

- (CGRect)nonScrollingSubviewFrame;

- (CGFloat)topBarsHeight;
- (CGFloat)bottomBarsHeight;

@end
