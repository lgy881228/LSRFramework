//
//  UIViewController+NavigationBar.h
//  TTTFramework
//
//  Created by jia on 2016/12/9.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerNavigationBarProtocol <NSObject>

@property (nonatomic, readonly) UIBarButtonItem *navigationBarBackButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *navigationBarCloseButtonItem;
@property (nonatomic, readonly) BOOL prefersNavigationBarLeftSideBackButtonWhenPushed;
@property (nonatomic, readonly) BOOL prefersNavigationBarLeftSideCloseButtonWhenPresented;

@end

@interface UIViewController (NavigationBar) <UIViewControllerNavigationBarProtocol>

@property (nonatomic, strong) NSString *navigationBarTitle;
@property (nonatomic, strong) UIView   *navigationBarTitleView;

@property (nonatomic, strong) UIBarButtonItem *navigationBarLeftButtonItem;
@property (nonatomic, strong) UIBarButtonItem *navigationBarRightButtonItem;

@property (nonatomic, strong) NSString *navigationBarLeftButtonItemTitle;
@property (nonatomic, strong) NSString *navigationBarRightButtonItemTitle;

// 当导航栏左侧只有一个返回按钮时，navigationBarBackButtonItem同navigationBarLeftButtonItem
@property (nonatomic, readonly) UIBarButtonItem *navigationBarBackButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *navigationBarCloseButtonItem;

// 如果导航栏左右的ButtonItem是用UIButton初始化的，使用下面2个方法可以获得
@property (nonatomic, readonly) UIButton *navigationBarLeftButton;
@property (nonatomic, readonly) UIButton *navigationBarRightButton;

// 应该使用的NavigationItem
- (UINavigationItem *)wantedNavigationItem;

// 设置导航栏左按钮
- (void)addNavigationBarLeftButtonItem:(UIBarButtonItem *)item;
- (UIBarButtonItem *)addNavigationBarLeftButtonItemWithTitle:(NSString *)leftItemTitle action:(SEL)leftItemSelector;
- (UIBarButtonItem *)addNavigationBarLeftButtonItemWithImage:(UIImage *)leftItemImage action:(SEL)leftItemSelector;

- (UIBarButtonItem *)addNavigationBarBackButtonItemWithImage:(UIImage *)leftItemImage action:(SEL)leftItemSelector;
- (UIBarButtonItem *)addNavigationBarCloseButtonItemWithImage:(UIImage *)leftItemImage action:(SEL)leftItemSelector;

// 设置导航栏左按钮数组 先添加的在左边
- (NSArray *)addNavigationBarLeftButtonItems:(NSArray *)items types:(NSArray *)types actions:(NSArray *)selectorStrings;

- (void)restoreNavigationBarLeftButtonItem;
- (void)removeNavigationBarLeftButtonItems;

// 设置导航栏右按钮
- (void)addNavigationBarRightButtonItem:(UIBarButtonItem *)item;
- (UIBarButtonItem *)addNavigationBarRightButtonItemWithTitle:(NSString *)rightItemTitle action:(SEL)rightItemSelector;
- (UIBarButtonItem *)addNavigationBarRightButtonItemWithImage:(UIImage *)rightItemImage action:(SEL)rightItemSelector;
- (UIBarButtonItem *)addNavigationBarRightButtonItemWithImageName:(NSString *)rightItemImageName action:(SEL)rightItemSelector;
// 设置导航栏右按钮数组 先添加的在右边
- (NSArray *)addNavigationBarRightButtonItems:(NSArray *)items types:(NSArray *)types actions:(NSArray *)selectorStrings;

- (void)removeNavigationBarRightButtonItems;

#pragma mark - Push
- (UIImage *)customBackButtonImage;

// 当Pushed，是否默认在导航栏左侧加上一个返回按钮，默认YES
@property (nonatomic, readwrite) BOOL prefersNavigationBarLeftSideBackButtonWhenPushed;

#pragma mark --- 返回按钮的点击处理，子类如果需要自定义返回的点击，请覆盖此函数并在函数结尾调用[super backButtonClicked:sender]
// 子类 定制 返回按钮点击处理
- (void)backButtonClicked:(id)sender;

#pragma mark - Present
- (UIImage *)customCloseButtonImage;

// 当Presented，是否默认在导航栏左侧加上一个关闭按钮，默认YES
@property (nonatomic, readwrite) BOOL prefersNavigationBarLeftSideCloseButtonWhenPresented;

#pragma mark --- 关闭按钮的点击处理，子类如果需要自定义关闭的点击，请覆盖此函数并在函数结尾调用[super closeButtonClicked:sender]
- (void)closeButtonClicked:(id)sender;

@end
