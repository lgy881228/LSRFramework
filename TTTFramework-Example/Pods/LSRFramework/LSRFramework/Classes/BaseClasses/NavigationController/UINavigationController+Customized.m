//
//  UINavigationController+Customized.m
//  TTTFramework
//
//  Created by jia on 2016/12/5.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UINavigationController+Customized.h"
#import "UINavigationBar+Customized.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"
#import "UIImage+Extension.h"
#import "UIViewController+.h"

static id _appearance_navigationBarColor;
static UIColor *_appearance_navigationBarTitleColor;
static UIFont *_appearance_navigationBarTitleFont;


@implementation UINavigationController (Customized)

#pragma mark - Properties
- (id)navigationBarColor
{
    return self.navigationBar.color;
}

- (UIColor *)navigationBarTitleColor
{
    return self.navigationBar.titleColor;
}

- (UIFont *)navigationBarTitleFont
{
    return self.navigationBar.titleFont;
}

- (NSDictionary *)navigationBarTitleAttributes
{
    return self.navigationBar.titleAttributes;
}

- (UIColor *)navigationBarLargeTitleColor
{
    return self.navigationBar.largeTitleColor;
}

- (UIFont *)navigationBarLargeTitleFont
{
    return self.navigationBar.largeTitleFont;
}

- (NSDictionary *)navigationBarLargeTitleAttributes
{
    return self.navigationBar.largeTitleAttributes;
}

- (void)updateNavigationBarColor:(UIColor *)navigationBarColor
{
    self.navigationBar.color = navigationBarColor;
    
    if (navigationBarColor && ![navigationBarColor isKindOfClass:UIColor.class])
    {
        navigationBarColor = nil;
    }
    
    if (!navigationBarColor)
    {
        [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setBarTintColor:nil];
    }
    else
    {
        CGFloat red, green, blue, alpha;
        [navigationBarColor getRed:&red green:&green blue:&blue alpha:&alpha];
        
        if (alpha >= 1.0)
        {
            [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBarTintColor:navigationBarColor];
        }
        else
        {
            [self.navigationBar setBackgroundImage:[UIImage imageWithColor:navigationBarColor] forBarMetrics:UIBarMetricsDefault];
        }
    }
}

- (void)updateNavigationBarTitleColor:(UIColor *)navigationBarTitleColor
{
    self.navigationBar.titleColor = navigationBarTitleColor;
}

- (void)updateNavigationBarTitleFont:(UIFont *)navigationBarTitleFont
{
    self.navigationBar.titleFont = navigationBarTitleFont;
}

- (void)updateNavigationBarTitleAttributes:(NSDictionary *)navigationBarTitleAttributes
{
    self.navigationBar.titleAttributes = navigationBarTitleAttributes;
}

- (void)updateNavigationBarLargeTitleColor:(UIColor *)navigationBarTitleColor
{
    self.navigationBar.largeTitleColor = navigationBarTitleColor;
}

- (void)updateNavigationBarLargeTitleFont:(UIFont *)navigationBarTitleFont
{
    self.navigationBar.largeTitleFont = navigationBarTitleFont;
}

- (void)updateNavigationBarLargeTitleAttributes:(NSDictionary *)navigationBarTitleAttributes
{
    self.navigationBar.largeTitleAttributes = navigationBarTitleAttributes;
}

#pragma mark - Swizzle
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleInstanceSelector:@selector(preferredStatusBarStyle) withSelector:@selector(uinavigationController_preferredStatusBarStyle)];
        [self swizzleInstanceSelector:@selector(prefersStatusBarHidden) withSelector:@selector(uinavigationController_prefersStatusBarHidden)];
        
        [self swizzleInstanceSelector:@selector(shouldAutorotate) withSelector:@selector(uinavigationController_shouldAutorotate)];
        [self swizzleInstanceSelector:@selector(supportedInterfaceOrientations) withSelector:@selector(uinavigationController_supportedInterfaceOrientations)];
        [self swizzleInstanceSelector:@selector(preferredInterfaceOrientationForPresentation) withSelector:@selector(uinavigationController_preferredInterfaceOrientationForPresentation)];
    });
}

- (UIStatusBarStyle)uinavigationController_preferredStatusBarStyle
{
    if (self.topViewController)
    {
        return [self.topViewController preferredStatusBarStyle];
    }
    else
    {
        return self.statusBarStyle;
    }
}

/*
 // 不重写默认的 感觉没必要
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
 */


// 这个方法写了也不调用
- (BOOL)uinavigationController_prefersStatusBarHidden
{
    if (self.topViewController)
    {
        return [self.topViewController prefersStatusBarHidden];
    }
    else
    {
        return [self uinavigationController_prefersStatusBarHidden];
    }
}

/*
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
 */

- (BOOL)uinavigationController_shouldAutorotate
{
    if (self.topViewController)
    {
        return [self.topViewController shouldAutorotate];
    }
    return [self uinavigationController_shouldAutorotate];
}

- (UIInterfaceOrientationMask)uinavigationController_supportedInterfaceOrientations
{
    if (self.topViewController)
    {
        return [self.topViewController supportedInterfaceOrientations];
    }
    return [self uinavigationController_supportedInterfaceOrientations];
}

// 初始方向（Presentation方式专用）
- (UIInterfaceOrientation)uinavigationController_preferredInterfaceOrientationForPresentation
{
    if (self.topViewController)
    {
        return [self.topViewController preferredInterfaceOrientationForPresentation];
    }
    return [self uinavigationController_preferredInterfaceOrientationForPresentation];
}

@end
