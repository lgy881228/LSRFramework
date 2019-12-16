//
//  UINavigationBar+Customized.m
//  TTTFramework
//
//  Created by jia on 2016/12/5.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UINavigationBar+Customized.h"
#import "UINavigationBar+Global.h"
#import "UIImage+Extension.h"
#import "UIImage+TTTFramework.h"
#import "UIColor+Extension.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Customized)

#pragma mark - Properties
- (void)setColor:(id)color
{
    objc_setAssociatedObject(self, @selector(color), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)color
{
    id color = objc_getAssociatedObject(self, @selector(color));
    return color;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    [self setTitleAttribute:titleColor forKey:NSForegroundColorAttributeName];
}

- (UIColor *)titleColor
{
    UIColor *titleColor = [self titleAttributeForKey:NSForegroundColorAttributeName];
    return titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    [self setTitleAttribute:titleFont forKey:NSFontAttributeName];
}

- (UIFont *)titleFont
{
    UIFont *titleFont = [self titleAttributeForKey:NSFontAttributeName];
    return titleFont;
}

- (void)setTitleAttributes:(NSDictionary *)titleAttributes
{
    self.titleTextAttributes = titleAttributes;
}

- (NSDictionary *)titleAttributes
{
    NSDictionary *titleAttributes = self.titleTextAttributes;
    return titleAttributes;
}

- (void)setLargeTitleColor:(UIColor *)largeTitleColor
{
    [self setLargeTitleAttribute:largeTitleColor forKey:NSForegroundColorAttributeName];
}

- (UIColor *)largeTitleColor
{
    UIColor *largeTitleColor = [self largeTitleAttributeForKey:NSForegroundColorAttributeName];
    return largeTitleColor;
}

- (void)setLargeTitleFont:(UIFont *)largeTitleFont
{
    [self setLargeTitleAttribute:largeTitleFont forKey:NSFontAttributeName];
}

- (UIFont *)largeTitleFont
{
    UIFont *largeTitleFont = [self largeTitleAttributeForKey:NSFontAttributeName];
    return largeTitleFont;
}

- (void)setLargeTitleAttributes:(NSDictionary *)titleAttributes
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3
    if (@available(iOS 11.0, *))
    {
        self.largeTitleTextAttributes = titleAttributes;
    }
#endif
}

- (NSDictionary *)largeTitleAttributes
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3
    if (@available(iOS 11.0, *))
    {
        NSDictionary *largeTitleAttributes = self.largeTitleTextAttributes;
        return largeTitleAttributes;
    }
#endif
    return nil;
}

#pragma mark - Tools
- (void)setTitleAttribute:(id)attribute forKey:(id)key
{
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:self.titleAttributes];
    properties[key] = attribute;
    
    self.titleAttributes = properties;
}

- (id)titleAttributeForKey:(id)key
{
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:self.titleAttributes];
    return properties[key];
}

- (void)setLargeTitleAttribute:(id)attribute forKey:(id)key
{
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:self.largeTitleAttributes];
    if (properties)
    {
        properties[key] = attribute;
        
        self.largeTitleAttributes = properties;
    }
}

- (id)largeTitleAttributeForKey:(id)key
{
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:self.largeTitleAttributes];
    if (properties)
    {
        return properties[key];
    }
    return nil;
}

#pragma mark - Swizzle
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleInstanceSelector:@selector(init) withSelector:@selector(uinavigationbar_init)];
        [self swizzleInstanceSelector:@selector(initWithCoder:) withSelector:@selector(uinavigationbar_initWithCoder:)];
        [self swizzleInstanceSelector:@selector(initWithFrame:) withSelector:@selector(uinavigationbar_initWithFrame:)];
    });
}

#pragma mark - Init
- (instancetype)uinavigationbar_init
{
    [self uinavigationbar_init];
    if (self)
    {
        [self initializeCustomUINavigationBarData];
    }
    return self;
}

- (instancetype)uinavigationbar_initWithCoder:(NSCoder *)aDecoder
{
    [self uinavigationbar_initWithCoder:aDecoder];
    if (self)
    {
        [self initializeCustomUINavigationBarData];
    }
    return self;
}

- (instancetype)uinavigationbar_initWithFrame:(CGRect)frame
{
    [self uinavigationbar_initWithFrame:frame];
    if (self)
    {
        [self initializeCustomUINavigationBarData];
    }
    return self;
}

- (void)initializeCustomUINavigationBarData
{
    self.color = [UINavigationBar.global color];
    
    self.titleColor = [UINavigationBar.global titleColor];
    self.titleFont  = [UINavigationBar.global titleFont];
    
    self.largeTitleColor = [UINavigationBar.global largeTitleColor];
    self.largeTitleFont = [UINavigationBar.global largeTitleFont];
}

#pragma mark - For System
- (UIImage *)backIndicatorImage
{
    return self.class.backButtonImage;
}

- (UIImage *)backIndicatorTransitionMaskImage
{
    return self.backIndicatorImage;
}

#pragma mark - Shadow
/*
 ios11之后shadowImage可以自由设置
 ios11之前：
 navigationBar setBackgroundImage:image 之后 隐藏阴影才有效
 navigationBar setBackgroundImage:nil   之后 显示阴影才有效
 */
- (void)setShadowImageEnabled:(BOOL)shadowImageEnabled
{
    @synchronized(self)
    {
        if (self.shadowImageEnabled == shadowImageEnabled)
        {
            return;
        }
        
        objc_setAssociatedObject(self, @selector(shadowImageEnabled), @(shadowImageEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (!shadowImageEnabled)
        {
            self.usedShadowImage = self.shadowImage;
        }
        self.shadowImage = shadowImageEnabled ? (self.usedShadowImage ?: nil) : [[UIImage alloc] init];
    }
}

- (BOOL)shadowImageEnabled
{
    NSNumber *shadowImageEnabled = objc_getAssociatedObject(self, @selector(shadowImageEnabled));
    if (shadowImageEnabled)
    {
        return shadowImageEnabled.boolValue;
    }
    return YES;
}

- (void)setUsedShadowImage:(UIImage *)usedShadowImage
{
    objc_setAssociatedObject(self, @selector(usedShadowImage), usedShadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)usedShadowImage
{
    return objc_getAssociatedObject(self, @selector(usedShadowImage));
}

@end
