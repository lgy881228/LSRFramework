//
//  UINavigationItem+Customized.m
//  TTTFramework
//
//  Created by jia on 2016/12/5.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UINavigationItem+Customized.h"
#import "UINavigationItem+BarButtonItem.h"
#import "UINavigationItem+Global.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"
#import "UIColor+Extension.h"

@implementation UINavigationItem (Customized)

#pragma mark - Properties
- (void)setBarButtonItemColor:(UIColor *)barButtonItemColor
{
    objc_setAssociatedObject(self, @selector(barButtonItemColor), barButtonItemColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self barButtonItemsStyleToFit];
}

// 传非color使用系统默认 传nil使用默认
- (UIColor *)barButtonItemColor
{
    UIColor *barButtonItemColor = objc_getAssociatedObject(self, @selector(barButtonItemColor));
    if (barButtonItemColor)
    {
        if ([barButtonItemColor isKindOfClass:UIColor.class])
        {
            return barButtonItemColor;
        }
        else
        {
            return SYSTEM_NAVIGATION_BAR_BUTTON_ITEM_COLOR;
        }
    }
    else
    {
        return [UINavigationItem.global barButtonItemColor];
    }
}

- (void)setBarButtonItemFont:(UIFont *)barButtonItemFont
{
    objc_setAssociatedObject(self, @selector(barButtonItemFont), barButtonItemFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self barButtonItemsStyleToFit];
}

- (UIFont *)barButtonItemFont
{
    UIFont *barButtonItemFont = objc_getAssociatedObject(self, @selector(barButtonItemFont));
    if (barButtonItemFont)
    {
        return barButtonItemFont;
    }
    else
    {
        return [UINavigationItem.global barButtonItemFont];
    }
}

- (void)setBackButtonItemColor:(UIColor *)backButtonItemColor
{
    objc_setAssociatedObject(self, @selector(backButtonItemColor), backButtonItemColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self backButtonItemStyleToFit];
}

- (UIColor *)backButtonItemColor
{
    UIColor *backButtonItemColor = objc_getAssociatedObject(self, @selector(backButtonItemColor));
    if (backButtonItemColor)
    {
        if ([backButtonItemColor isKindOfClass:UIColor.class])
        {
            return backButtonItemColor;
        }
        else
        {
            return SYSTEM_NAVIGATION_BAR_BUTTON_ITEM_COLOR;
        }
    }
    return [UINavigationItem.global backButtonItemColor];
}

- (void)setCloseButtonItemColor:(UIColor *)closeButtonItemColor
{
    objc_setAssociatedObject(self, @selector(closeButtonItemColor), closeButtonItemColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self closeButtonItemStyleToFit];
}

- (UIColor *)closeButtonItemColor
{
    UIColor *closeButtonItemColor = objc_getAssociatedObject(self, @selector(closeButtonItemColor));
    if (closeButtonItemColor)
    {
        if ([closeButtonItemColor isKindOfClass:UIColor.class])
        {
            return closeButtonItemColor;
        }
        else
        {
            return SYSTEM_NAVIGATION_BAR_BUTTON_ITEM_COLOR;
        }
    }
    return [UINavigationItem.global closeButtonItemColor];
}

- (void)setBarButtonItemSideSpacing:(CGFloat)barButtonItemSideSpacing
{
    objc_setAssociatedObject(self, @selector(barButtonItemSideSpacing), @(barButtonItemSideSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)barButtonItemSideSpacing
{
    NSNumber *barButtonItemSideSpacing = objc_getAssociatedObject(self, @selector(barButtonItemSideSpacing));
    if (barButtonItemSideSpacing)
    {
        return barButtonItemSideSpacing.floatValue;
    }
    return [UINavigationItem.global barButtonItemSideSpacing];
}

- (void)setTitleButtonItemSideSpacing:(CGFloat)titleButtonItemSideSpacing
{
    objc_setAssociatedObject(self, @selector(titleButtonItemSideSpacing), @(titleButtonItemSideSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)titleButtonItemSideSpacing
{
    NSNumber *titleButtonItemSideSpacing = objc_getAssociatedObject(self, @selector(titleButtonItemSideSpacing));
    if (titleButtonItemSideSpacing)
    {
        return titleButtonItemSideSpacing.floatValue;
    }
    return [UINavigationItem.global titleButtonItemSideSpacing];
}

- (void)setImageButtonItemSideSpacing:(CGFloat)imageButtonItemSideSpacing
{
    objc_setAssociatedObject(self, @selector(imageButtonItemSideSpacing), @(imageButtonItemSideSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)imageButtonItemSideSpacing
{
    NSNumber *imageButtonItemSideSpacing = objc_getAssociatedObject(self, @selector(imageButtonItemSideSpacing));
    if (imageButtonItemSideSpacing)
    {
        return imageButtonItemSideSpacing.floatValue;
    }
    return [UINavigationItem.global imageButtonItemSideSpacing];
}

- (void)setBackButtonItemSideSpacing:(CGFloat)backButtonItemSideSpacing
{
    objc_setAssociatedObject(self, @selector(backButtonItemSideSpacing), @(backButtonItemSideSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)backButtonItemSideSpacing
{
    NSNumber *backButtonItemSideSpacing = objc_getAssociatedObject(self, @selector(backButtonItemSideSpacing));
    if (backButtonItemSideSpacing)
    {
        return backButtonItemSideSpacing.floatValue;
    }
    return [UINavigationItem.global backButtonItemSideSpacing];
}

- (void)setBarButtonItemSize:(CGSize)barButtonItemSize
{
    objc_setAssociatedObject(self, @selector(barButtonItemSize), NSStringFromCGSize(barButtonItemSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)barButtonItemSize
{
    NSString *barButtonItemSize = objc_getAssociatedObject(self, @selector(barButtonItemSize));
    if (barButtonItemSize)
    {
        return CGSizeFromString(barButtonItemSize);
    }
    return [UINavigationItem.global barButtonItemSize];
}

- (void)setBackButtonItemSize:(CGSize)backButtonItemSize
{
    objc_setAssociatedObject(self, @selector(backButtonItemSize), NSStringFromCGSize(backButtonItemSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)backButtonItemSize
{
    NSString *backButtonItemSize = objc_getAssociatedObject(self, @selector(backButtonItemSize));
    if (backButtonItemSize)
    {
        return CGSizeFromString(backButtonItemSize);
    }
    return [UINavigationItem.global backButtonItemSize];
}

- (void)setCloseButtonItemSize:(CGSize)closeButtonItemSize
{
    objc_setAssociatedObject(self, @selector(closeButtonItemSize), NSStringFromCGSize(closeButtonItemSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)closeButtonItemSize
{
    NSString *closeButtonItemSize = objc_getAssociatedObject(self, @selector(closeButtonItemSize));
    if (closeButtonItemSize)
    {
        return CGSizeFromString(closeButtonItemSize);
    }
    return [UINavigationItem.global closeButtonItemSize];
}

- (BOOL)isDefaultBarButtonItemColor
{
    return self.barButtonItemColor == [UINavigationItem.global barButtonItemColor];
}

- (BOOL)isDefaultBarButtonItemFont
{
    return self.barButtonItemFont == [UINavigationItem.global barButtonItemFont];
}

#pragma mark - Swizzle
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleInstanceSelector:@selector(backBarButtonItem) withSelector:@selector(myCustomBackButton_backBarbuttonItem)];
        
        [self swizzleInstanceSelector:NSSelectorFromString(@"dealloc") withSelector:@selector(uinavigationItem_dealloc)];
    });
}

- (void)uinavigationItem_dealloc
{
    objc_removeAssociatedObjects(self);
    
    [self uinavigationItem_dealloc];
}

static char _customBackBarButtonItemKey;
// 解决导航栏 在返回时 有"..."从导航栏上向右飘过
- (UIBarButtonItem *)myCustomBackButton_backBarbuttonItem
{
    UIBarButtonItem *item = [self myCustomBackButton_backBarbuttonItem];
    if (item)
    {
        return item;
    }
    
    item = objc_getAssociatedObject(self, &_customBackBarButtonItemKey);
    if (!item)
    {
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
        objc_setAssociatedObject(self, &_customBackBarButtonItemKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

@end
