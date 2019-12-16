//
//  NavigationController+Global.m
//  TTTFramework
//
//  Created by jia on 2017/11/7.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "NavigationController+Global.h"
#import <objc/runtime.h>

@implementation NavigationController (Global)

#pragma mark - Properties
+ (Class)global
{
    return [NavigationController class];
}

+ (void)setNavigationBarTranslucent:(BOOL)navigationBarTranslucent
{
    objc_setAssociatedObject(self.global, @selector(navigationBarTranslucent), @(navigationBarTranslucent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// defaults to YES
+ (BOOL)navigationBarTranslucent
{
    NSNumber *navigationBarTranslucent = objc_getAssociatedObject(self.global, @selector(navigationBarTranslucent));
    if (navigationBarTranslucent)
    {
        return navigationBarTranslucent.boolValue;
    }
    return YES;
}

+ (void)setCustomizedNavigationBarTranslucent:(BOOL)customizedNavigationBarTranslucent
{
    objc_setAssociatedObject(self.global, @selector(customizedNavigationBarTranslucent), @(customizedNavigationBarTranslucent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// default to NO
+ (BOOL)customizedNavigationBarTranslucent
{
    NSNumber *customizedNavigationBarTranslucent = objc_getAssociatedObject(self.global, @selector(customizedNavigationBarTranslucent));
    if (customizedNavigationBarTranslucent)
    {
        return customizedNavigationBarTranslucent.boolValue;
    }
    return NO;
}

@end
