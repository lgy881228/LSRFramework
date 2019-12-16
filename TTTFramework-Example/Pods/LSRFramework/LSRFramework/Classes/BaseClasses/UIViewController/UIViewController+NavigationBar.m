//
//  UIViewController+NavigationBar.m
//  TTTFramework
//
//  Created by jia on 2016/12/9.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "UIViewController+Protected.h"
#import "UIViewController+Push_Present.h"
#import "UIImage+Extension.h"
#import "UINavigationItem+BarButtonItem.h"
#import <objc/runtime.h>

@implementation UIViewController (NavigationBar)

#pragma mark - NavigationBar
- (void)setNavigationBarTitle:(NSString *)navigationBarTitle
{
    if (self.wantedNavigationItem)
    {
        // self.navigationController.navigationBar.topItem.title = title;
        self.wantedNavigationItem.title = navigationBarTitle;
    }
    // 用title的话 导航 返回了 title还是当前title 即影响不仅是本vc
    self.title = navigationBarTitle;
}

- (NSString *)navigationBarTitle
{
    if (self.wantedNavigationItem)
    {
        return self.wantedNavigationItem.title;
    }
    return self.title;
}

- (void)setNavigationBarTitleView:(UIView *)titleView
{
    self.wantedNavigationItem.titleView = titleView;
}

- (UIView *)navigationBarTitleView
{
    return self.wantedNavigationItem.titleView;
}

- (UIBarButtonItem *)navigationBarLeftButtonItem
{
    return self.wantedNavigationItem.leftButtonItem;
}

- (void)setNavigationBarLeftButtonItem:(UIBarButtonItem *)leftButtonItem
{
    [self addNavigationBarLeftButtonItem:leftButtonItem];
}

- (UIBarButtonItem *)navigationBarRightButtonItem
{
    return self.wantedNavigationItem.rightButtonItem;
}

- (void)setNavigationBarRightButtonItem:(UIBarButtonItem *)rightButtonItem
{
    [self addNavigationBarRightButtonItem:rightButtonItem];
}

- (void)setNavigationBarLeftButtonItemTitle:(NSString *)navigationBarLeftButtonItemTitle
{
    self.wantedNavigationItem.leftButtonItemTitle = navigationBarLeftButtonItemTitle;
}

- (NSString *)navigationBarLeftButtonItemTitle
{
    return self.wantedNavigationItem.leftButtonItemTitle;
}

- (void)setNavigationBarRightButtonItemTitle:(NSString *)navigationBarRightButtonItemTitle
{
    self.wantedNavigationItem.rightButtonItemTitle = navigationBarRightButtonItemTitle;
}

- (NSString *)navigationBarRightButtonItemTitle
{
    return self.wantedNavigationItem.rightButtonItemTitle;
}

- (void)setNavigationBarBackButtonItem:(UIBarButtonItem *)navigationBarBackButtonItem
{
    objc_setAssociatedObject(self, @selector(navigationBarBackButtonItem), navigationBarBackButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)navigationBarBackButtonItem
{
    return objc_getAssociatedObject(self, @selector(navigationBarBackButtonItem));
}

- (void)setNavigationBarCloseButtonItem:(UIBarButtonItem *)navigationBarCloseButtonItem
{
    objc_setAssociatedObject(self, @selector(navigationBarCloseButtonItem), navigationBarCloseButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)navigationBarCloseButtonItem
{
    return objc_getAssociatedObject(self, @selector(navigationBarCloseButtonItem));
}

- (UIButton *)navigationBarLeftButton
{
    return self.wantedNavigationItem.leftButton;
}

- (UIButton *)navigationBarRightButton
{
    return self.wantedNavigationItem.rightButton;
}

- (UINavigationItem *)wantedNavigationItem
{
    if (self.parentViewController)
    {
        if ([self.parentViewController isKindOfClass:[UINavigationController class]])
        {
            return self.navigationItem;
        }
        else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
        {
            return self.tabBarController.navigationItem;
        }
        else
        {
            // unknown, do nothing
        }
    }
    
    return self.navigationItem;
}

#pragma mark Left
- (void)addNavigationBarLeftButtonItem:(UIBarButtonItem *)item
{
    [self.wantedNavigationItem addLeftBarButtonItem:item];
}

- (UIBarButtonItem *)addNavigationBarLeftButtonItemWithTitle:(NSString *)leftItemTitle action:(SEL)leftItemSelector
{
    return [self.wantedNavigationItem addLeftBarButtonItem:leftItemTitle type:BarButtonItemTypeTitle target:self action:leftItemSelector];
}

- (UIBarButtonItem *)addNavigationBarLeftButtonItemWithImage:(UIImage *)leftItemImage action:(SEL)leftItemSelector
{
    return [self.wantedNavigationItem addLeftBarButtonItemWithImage:leftItemImage target:self action:leftItemSelector];
}

- (UIBarButtonItem *)addNavigationBarBackButtonItemWithImage:(UIImage *)leftItemImage action:(SEL)leftItemSelector
{
    return self.navigationBarBackButtonItem = [self.wantedNavigationItem addBackButtonItemWithImage:leftItemImage target:self action:leftItemSelector];
}

- (UIBarButtonItem *)addNavigationBarCloseButtonItemWithImage:(UIImage *)leftItemImage action:(SEL)leftItemSelector
{
    return self.navigationBarCloseButtonItem = [self.wantedNavigationItem addCloseBarButtonItemWithImage:leftItemImage target:self action:leftItemSelector];
}

// 设置导航栏左按钮数组 先添加的在左边
- (NSArray *)addNavigationBarLeftButtonItems:(NSArray *)items types:(NSArray *)types actions:(NSArray *)selectorStrings
{
    return [self.wantedNavigationItem addLeftBarButtonItems:items types:types target:self actions:selectorStrings];
}

- (void)restoreNavigationBarLeftButtonItem
{
    if (self.navigationBarBackButtonItem)
    {
        [self setupNavigationBarLeftSideFunctionalButton];
    }
    else
    {
        [self removeNavigationBarLeftButtonItems];
    }
}

- (void)removeNavigationBarLeftButtonItems
{
    [self.wantedNavigationItem removeLeftBarButtonItems];
}

#pragma mark Right
- (void)addNavigationBarRightButtonItem:(UIBarButtonItem *)item
{
    [self.wantedNavigationItem addRightBarButtonItem:item];
}

- (UIBarButtonItem *)addNavigationBarRightButtonItemWithTitle:(NSString *)rightItemTitle action:(SEL)rightItemSelector
{
    return [self.wantedNavigationItem addRightBarButtonItem:rightItemTitle type:BarButtonItemTypeTitle target:self action:rightItemSelector];
}

- (UIBarButtonItem *)addNavigationBarRightButtonItemWithImage:(UIImage *)rightItemImage action:(SEL)rightItemSelector
{
    return [self.wantedNavigationItem addRightBarButtonItem:rightItemImage type:BarButtonItemTypeImage target:self action:rightItemSelector];
}

- (UIBarButtonItem *)addNavigationBarRightButtonItemWithImageName:(NSString *)rightItemImageName action:(SEL)rightItemSelector
{
    return [self.wantedNavigationItem addRightBarButtonItem:rightItemImageName type:BarButtonItemTypeImageName target:self action:rightItemSelector];
}

// 设置导航栏右按钮数组组 先添加的在右边
- (NSArray *)addNavigationBarRightButtonItems:(NSArray *)items types:(NSArray *)types actions:(NSArray *)selectorStrings
{
    return [self.wantedNavigationItem addRightBarButtonItems:items types:types target:self actions:selectorStrings];
}

- (void)removeNavigationBarRightButtonItems
{
    [self.wantedNavigationItem removeRightBarButtonItems];
}

#pragma mark - Push
- (UIImage *)customBackButtonImage
{
    return nil;
}

- (void)setPrefersNavigationBarLeftSideBackButtonWhenPushed:(BOOL)prefersNavigationBarLeftSideBackButtonWhenPushed
{
    objc_setAssociatedObject(self, @selector(prefersNavigationBarLeftSideBackButtonWhenPushed), @(prefersNavigationBarLeftSideBackButtonWhenPushed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 是否默认在导航栏左侧加上一个返回按钮，默认YES
- (BOOL)prefersNavigationBarLeftSideBackButtonWhenPushed
{
    NSNumber *prefersNavigationBarLeftSideBackButtonWhenPushed = objc_getAssociatedObject(self, @selector(prefersNavigationBarLeftSideBackButtonWhenPushed));
    if (prefersNavigationBarLeftSideBackButtonWhenPushed)
    {
        return prefersNavigationBarLeftSideBackButtonWhenPushed.boolValue;
    }
    return YES;
}

#pragma mark --- 返回按钮的点击处理，子类如果需要自定义返回的点击，请覆盖此函数并在函数结尾调用[super backButtonClicked:sender]
- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Present
- (UIImage *)customCloseButtonImage
{
    return nil;
}

- (void)setPrefersNavigationBarLeftSideCloseButtonWhenPresented:(BOOL)prefersNavigationBarLeftSideCloseButtonWhenPresented
{
    objc_setAssociatedObject(self, @selector(prefersNavigationBarLeftSideCloseButtonWhenPresented), @(prefersNavigationBarLeftSideCloseButtonWhenPresented), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 是否默认在导航栏左侧加上一个关闭按钮，默认YES
- (BOOL)prefersNavigationBarLeftSideCloseButtonWhenPresented
{
    NSNumber *prefersNavigationBarLeftSideCloseButtonWhenPresented = objc_getAssociatedObject(self, @selector(prefersNavigationBarLeftSideCloseButtonWhenPresented));
    if (prefersNavigationBarLeftSideCloseButtonWhenPresented)
    {
        return prefersNavigationBarLeftSideCloseButtonWhenPresented.boolValue;
    }
    return YES;
}

#pragma mark --- 关闭按钮的点击处理，子类如果需要自定义关闭的点击，请覆盖此函数并在函数结尾调用[super closeButtonClicked:sender]
- (void)closeButtonClicked:(id)sender
{
    // 如果当前vc是被present出来的，self.presentingViewController是把当前vc present出来的
    if (self.presentingViewController)
    {
        [self dismiss];
    }
}

@end
