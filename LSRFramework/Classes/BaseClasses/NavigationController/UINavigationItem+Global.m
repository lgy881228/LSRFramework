//
//  UINavigationItem+Global.m
//  TTTFramework
//
//  Created by jia on 2017/10/15.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UINavigationItem+Global.h"
#import "TTTFrameworkScreenParameters.h"
#import <objc/runtime.h>

@implementation UINavigationItem (Global)

#pragma mark - Properties
+ (Class)global
{
    return [UINavigationItem class];
}

+ (void)setBarButtonItemColor:(UIColor *)barButtonItemColor
{
    objc_setAssociatedObject(self.global, @selector(barButtonItemColor), barButtonItemColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)barButtonItemColor
{
    return objc_getAssociatedObject(self.global, @selector(barButtonItemColor)) ?: [UIColor colorWithRed:0/255.0 green:64/255.0 blue:221/255.0 alpha:1.0];
}

+ (void)setBarButtonItemFont:(UIFont *)barButtonItemFont
{
    objc_setAssociatedObject(self.global, @selector(barButtonItemFont), barButtonItemFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIFont *)barButtonItemFont
{
    return objc_getAssociatedObject(self.global, @selector(barButtonItemFont)) ?: [UIFont systemFontOfSize:16.0];
}

+ (void)setBackButtonItemColor:(UIColor *)backButtonItemColor
{
    objc_setAssociatedObject(self.global, @selector(backButtonItemColor), backButtonItemColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)backButtonItemColor
{
    return objc_getAssociatedObject(self.global, @selector(backButtonItemColor)) ?: self.barButtonItemColor;
}

+ (void)setCloseButtonItemColor:(UIColor *)closeButtonItemColor
{
    objc_setAssociatedObject(self.global, @selector(closeButtonItemColor), closeButtonItemColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)closeButtonItemColor
{
    return objc_getAssociatedObject(self.global, @selector(closeButtonItemColor)) ?: self.barButtonItemColor;
}

+ (void)setBarButtonItemSideSpacing:(CGFloat)barButtonItemSideSpacing
{
    objc_setAssociatedObject(self.global, @selector(barButtonItemSideSpacing), @(barButtonItemSideSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)barButtonItemSideSpacing
{
    NSNumber *barButtonItemSideSpacing = objc_getAssociatedObject(self.global, @selector(barButtonItemSideSpacing));
    if (barButtonItemSideSpacing)
    {
        return barButtonItemSideSpacing.floatValue;
    }
    return PREFERRED_SCREEN_SIDE_SPACING;
}

+ (void)setTitleButtonItemSideSpacing:(CGFloat)titleButtonItemSideSpacing
{
    objc_setAssociatedObject(self.global, @selector(titleButtonItemSideSpacing), @(titleButtonItemSideSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)titleButtonItemSideSpacing
{
    NSNumber *titleButtonItemSideSpacing = objc_getAssociatedObject(self.global, @selector(titleButtonItemSideSpacing));
    if (titleButtonItemSideSpacing)
    {
        return titleButtonItemSideSpacing.floatValue;
    }
    return PREFERRED_SCREEN_SIDE_SPACING;
}

+ (void)setImageButtonItemSideSpacing:(CGFloat)imageButtonItemSideSpacing
{
    objc_setAssociatedObject(self.global, @selector(imageButtonItemSideSpacing), @(imageButtonItemSideSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)imageButtonItemSideSpacing
{
    NSNumber *imageButtonItemSideSpacing = objc_getAssociatedObject(self.global, @selector(imageButtonItemSideSpacing));
    if (imageButtonItemSideSpacing)
    {
        return imageButtonItemSideSpacing.floatValue;
    }
    return PREFERRED_SCREEN_SIDE_SPACING;
}

+ (void)setBackButtonItemSideSpacing:(CGFloat)backButtonItemSideSpacing
{
    objc_setAssociatedObject(self.global, @selector(backButtonItemSideSpacing), @(backButtonItemSideSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)backButtonItemSideSpacing
{
    NSNumber *backButtonItemSideSpacing = objc_getAssociatedObject(self.global, @selector(backButtonItemSideSpacing));
    if (backButtonItemSideSpacing)
    {
        return backButtonItemSideSpacing.floatValue;
    }
    return PREFERRED_SCREEN_SIDE_SPACING;
}

// 调整返回按钮的图片位置
+ (void)setBackButtonImageOffset:(CGPoint)backButtonImageOffset
{
    objc_setAssociatedObject(self.global, @selector(backButtonImageOffset), NSStringFromCGPoint(backButtonImageOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGPoint)backButtonImageOffset
{
    NSString *backButtonImageOffset = objc_getAssociatedObject(self.global, @selector(backButtonImageOffset));
    if (backButtonImageOffset)
    {
        return CGPointFromString(backButtonImageOffset);
    }
    return CGPointZero;
}

+ (void)setBarButtonItemSize:(CGSize)barButtonItemSize
{
    objc_setAssociatedObject(self.global, @selector(barButtonItemSize), NSStringFromCGSize(barButtonItemSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGSize)barButtonItemSize
{
    NSString *barButtonItemSize = objc_getAssociatedObject(self.global, @selector(barButtonItemSize));
    if (barButtonItemSize)
    {
        return CGSizeFromString(barButtonItemSize);
    }
    return CGSizeMake(30, NAVIGATION_BAR_HEIGHT);
}

+ (void)setBackButtonItemSize:(CGSize)backButtonItemSize
{
    objc_setAssociatedObject(self.global, @selector(backButtonItemSize), NSStringFromCGSize(backButtonItemSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGSize)backButtonItemSize
{
    NSString *backButtonItemSize = objc_getAssociatedObject(self.global, @selector(backButtonItemSize));
    if (backButtonItemSize)
    {
        return CGSizeFromString(backButtonItemSize);
    }
    return CGSizeMake(44, 22);
}

+ (void)setCloseButtonItemSize:(CGSize)closeButtonItemSize
{
    objc_setAssociatedObject(self.global, @selector(closeButtonItemSize), NSStringFromCGSize(closeButtonItemSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGSize)closeButtonItemSize
{
    NSString *closeButtonItemSize = objc_getAssociatedObject(self.global, @selector(closeButtonItemSize));
    if (closeButtonItemSize)
    {
        return CGSizeFromString(closeButtonItemSize);
    }
    return CGSizeMake(44, 22);
}

@end
