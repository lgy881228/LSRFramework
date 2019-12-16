//
//  UIViewController+Customized.m
//  TTTFramework
//
//  Created by jia on 16/6/1.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UIViewController+Customized.h"
#import "UIViewController+Global.h"
#import "UINavigationController+Customized.h"
#import "UINavigationItem+BarButtonItem.h"
#import "UINavigationBar+Global.h"
#import "UIViewController+TTTFramework.h"
#import <objc/runtime.h>

@implementation UIViewController (Customized)

- (void)setCustomizedEnabled:(BOOL)customizedEnabled
{
    objc_setAssociatedObject(self, @selector(customizedEnabled), @(customizedEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)customizedEnabled
{
    NSNumber *customizedEnabled = objc_getAssociatedObject(self, @selector(customizedEnabled));
    if (customizedEnabled)
    {
        return customizedEnabled.boolValue;
    }
    else
    {
        if ([self.class.customizedWhiteList containsObject:self.class])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

+ (void)setCustomizedWhiteList:(NSMutableSet *)customizedWhiteList
{
    // 因为类名不同，self也就是不用的类名，数据会绑定到不同的类上，这里只想唯一绑定一次，不能用self，全用UIViewController
    objc_setAssociatedObject(self.global, @selector(customizedWhiteList), customizedWhiteList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSMutableSet *)customizedWhiteList
{
    // 因为类名不同，self也就是不用的类名，数据会绑定到不同的类上，这里只想唯一绑定一次，不能用self，全用UIViewController
    NSMutableSet *customizedWhiteList = objc_getAssociatedObject(self.global, @selector(customizedWhiteList));
    if (!customizedWhiteList)
    {
        customizedWhiteList = [[NSMutableSet alloc] initWithObjects:UIViewController.class, UINavigationController.class, UITableViewController.class, UICollectionViewController.class, nil];
        self.class.customizedWhiteList = customizedWhiteList;
    }
    return customizedWhiteList;
}

#pragma mark - Navigation Bar
- (void)setPrefersNavigationBarHidden:(BOOL)prefersNavigationBarHidden
{
    objc_setAssociatedObject(self, @selector(prefersNavigationBarHidden), @(prefersNavigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)prefersNavigationBarHidden
{
    NSNumber *prefersNavigationBarHidden = objc_getAssociatedObject(self, @selector(prefersNavigationBarHidden));
    if (prefersNavigationBarHidden)
    {
        return prefersNavigationBarHidden.boolValue;
    }
    return NO;
}

- (void)setPreferredNavigationBarColor:(UIColor *)preferredNavigationBarColor
{
    objc_setAssociatedObject(self, @selector(preferredNavigationBarColor), preferredNavigationBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (preferredNavigationBarColor)
    {
        if (![preferredNavigationBarColor isKindOfClass:UIColor.class])
        {
            // 传非color使用系统默认
            preferredNavigationBarColor = SYSTEM_NAVIGATION_BAR_COLOR;
        }
    }
    else
    {
        // 传nil使用默认
        preferredNavigationBarColor = [UINavigationBar.global color];
    }
}

- (UIColor *)preferredNavigationBarColor
{
    id preferredNavigationBarColor = objc_getAssociatedObject(self, @selector(preferredNavigationBarColor));
    if (preferredNavigationBarColor)
    {
        return [preferredNavigationBarColor isKindOfClass:UIColor.class] ? preferredNavigationBarColor : SYSTEM_NAVIGATION_BAR_COLOR;
    }
    else
    {
        return self.navigationController ? [UINavigationBar.global color] : nil;
    }
}

- (void)setPreferredNavigationBarShadowImageState:(NavigationBarShadowImageState)preferredNavigationBarShadowImageState
{
    objc_setAssociatedObject(self, @selector(preferredNavigationBarShadowImageState), @(preferredNavigationBarShadowImageState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self navigationBarShadowImageToFit];
}

- (NavigationBarShadowImageState)preferredNavigationBarShadowImageState
{
    NSNumber *preferredNavigationBarShadowImageState = objc_getAssociatedObject(self, @selector(preferredNavigationBarShadowImageState));
    if (preferredNavigationBarShadowImageState)
    {
        return preferredNavigationBarShadowImageState.integerValue;
    }
    return NavigationBarShadowImageStateEnabled;
}

- (void)setPreferredNavigationBarTitleColor:(UIColor *)preferredNavigationBarTitleColor
{
    objc_setAssociatedObject(self, @selector(preferredNavigationBarTitleColor), preferredNavigationBarTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (preferredNavigationBarTitleColor)
    {
        if (![preferredNavigationBarTitleColor isKindOfClass:UIColor.class])
        {
            // 传非color使用系统默认
            preferredNavigationBarTitleColor = SYSTEM_NAVIGATION_BAR_TITLE_COLOR;
        }
    }
    else
    {
        // 传nil使用默认
        preferredNavigationBarTitleColor = [UINavigationBar.global titleColor];
    }
    
    [self.navigationController updateNavigationBarTitleColor:preferredNavigationBarTitleColor];
}

- (UIColor *)preferredNavigationBarTitleColor
{
    UIColor *preferredNavigationBarTitleColor = objc_getAssociatedObject(self, @selector(preferredNavigationBarTitleColor));
    return preferredNavigationBarTitleColor ? ([preferredNavigationBarTitleColor isKindOfClass:UIColor.class] ? preferredNavigationBarTitleColor : SYSTEM_NAVIGATION_BAR_TITLE_COLOR) : [UINavigationBar.global titleColor];
}

- (void)setPreferredNavigationBarTitleFont:(UIFont *)preferredNavigationBarTitleFont
{
    objc_setAssociatedObject(self, @selector(preferredNavigationBarTitleFont), preferredNavigationBarTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 传nil表示重置，即使用默认（区别于系统默认）
    [self.navigationController updateNavigationBarTitleFont:(preferredNavigationBarTitleFont ?: [UINavigationBar.global titleFont])];
}

- (UIFont *)preferredNavigationBarTitleFont
{
    UIFont *preferredNavigationBarTitleFont = objc_getAssociatedObject(self, @selector(preferredNavigationBarTitleFont));
    return preferredNavigationBarTitleFont ?: [UINavigationBar.global titleFont];
}

- (void)setPreferredNavigationBarLargeTitleColor:(UIColor *)preferredNavigationBarLargeTitleColor
{
    objc_setAssociatedObject(self, @selector(preferredNavigationBarLargeTitleColor), preferredNavigationBarLargeTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (preferredNavigationBarLargeTitleColor)
    {
        if (![preferredNavigationBarLargeTitleColor  isKindOfClass:UIColor.class])
        {
            preferredNavigationBarLargeTitleColor = SYSTEM_NAVIGATION_BAR_TITLE_COLOR;
        }
    }
    else
    {
        // 传nil使用默认
        preferredNavigationBarLargeTitleColor = [UINavigationBar.global largeTitleColor];
    }
    
    [self.navigationController updateNavigationBarLargeTitleColor:preferredNavigationBarLargeTitleColor];
}

- (UIColor *)preferredNavigationBarLargeTitleColor
{
    UIColor *preferredNavigationBarLargeTitleColor = objc_getAssociatedObject(self, @selector(preferredNavigationBarLargeTitleColor));
    return preferredNavigationBarLargeTitleColor ? ([preferredNavigationBarLargeTitleColor isKindOfClass:UIColor.class] ? preferredNavigationBarLargeTitleColor : SYSTEM_NAVIGATION_BAR_TITLE_COLOR) : [UINavigationBar.global largeTitleColor];
}

- (void)setPreferredNavigationBarLargeTitleFont:(UIFont *)preferredNavigationBarLargeTitleFont
{
    objc_setAssociatedObject(self, @selector(preferredNavigationBarLargeTitleFont), preferredNavigationBarLargeTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 传nil表示重置，即使用默认（区别于系统默认）
    [self.navigationController updateNavigationBarLargeTitleFont:(preferredNavigationBarLargeTitleFont ?: [UINavigationBar.global largeTitleFont])];
}

- (UIFont *)preferredNavigationBarLargeTitleFont
{
    UIFont *preferredNavigationBarLargeTitleFont = objc_getAssociatedObject(self, @selector(preferredNavigationBarLargeTitleFont));
    return preferredNavigationBarLargeTitleFont ?: [UINavigationBar.global largeTitleFont];
}

#pragma mark - Status Bar
- (void)setPrefersStatusBarHidden:(BOOL)prefersStatusBarHidden
{
    objc_setAssociatedObject(self, @selector(prefersStatusBarHidden), @(prefersStatusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)prefersStatusBarHidden
{
    NSNumber *prefersStatusBarHidden = objc_getAssociatedObject(self, @selector(prefersStatusBarHidden));
    if (prefersStatusBarHidden)
    {
        return prefersStatusBarHidden.boolValue;
    }
    return NO; // System defaults to NO
}

- (void)setPrefersStatusBarStyleLightContent:(BOOL)prefersStatusBarStyleLightContent
{
    objc_setAssociatedObject(self, @selector(prefersStatusBarStyleLightContent), @(prefersStatusBarStyleLightContent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)prefersStatusBarStyleLightContent
{
    NSNumber *prefersStatusBarStyleLightContent = objc_getAssociatedObject(self, @selector(prefersStatusBarStyleLightContent));
    if (prefersStatusBarStyleLightContent)
    {
        return prefersStatusBarStyleLightContent.boolValue;
    }
    return NO; // defaults to NO
}

- (void)setPrefersStatusBarStyleDarkContent:(BOOL)prefersStatusBarStyleDarkContent
{
    objc_setAssociatedObject(self, @selector(prefersStatusBarStyleDarkContent), @(prefersStatusBarStyleDarkContent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)prefersStatusBarStyleDarkContent
{
    NSNumber *prefersStatusBarStyleDarkContent = objc_getAssociatedObject(self, @selector(prefersStatusBarStyleDarkContent));
    if (prefersStatusBarStyleDarkContent)
    {
        return prefersStatusBarStyleDarkContent.boolValue;
    }
    return NO; // defaults to NO
}

#pragma mark - Autorotate
- (void)setAutorotateEnabled:(BOOL)autorotateEnabled
{
    objc_setAssociatedObject(self, @selector(autorotateEnabled), @(autorotateEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)autorotateEnabled
{
    NSNumber *autorotateEnabled = objc_getAssociatedObject(self, @selector(autorotateEnabled));
    if (autorotateEnabled)
    {
        return autorotateEnabled.boolValue;
    }
    return YES;
}

@end
