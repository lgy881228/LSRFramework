//
//  UINavigationBar+Global.m
//  TTTFramework
//
//  Created by jia on 2017/10/15.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UINavigationBar+Global.h"
#import "UIImage+TTTFramework.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Global)

#pragma mark - Properties
+ (Class)global
{
    return [UINavigationBar class];
}

+ (void)setColor:(id)color
{
    objc_setAssociatedObject(self.global, @selector(color), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (id)color
{
    return objc_getAssociatedObject(self.global, @selector(color));
}

+ (void)setTitleColor:(UIColor *)titleColor
{
    objc_setAssociatedObject(self.global, @selector(titleColor), titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)titleColor
{
    return objc_getAssociatedObject(self.global, @selector(titleColor)) ?: [UIColor blackColor];
}

+ (void)setTitleFont:(UIFont *)titleFont
{
    objc_setAssociatedObject(self.global, @selector(titleFont), titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIFont *)titleFont
{
    return objc_getAssociatedObject(self.global, @selector(titleFont)) ?: [UIFont boldSystemFontOfSize:17.0];
}

+ (void)setTitleAttributes:(NSDictionary *)titleAttributes
{
    objc_setAssociatedObject(self.global, @selector(titleAttributes), titleAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSDictionary *)titleAttributes
{
    return objc_getAssociatedObject(self.global, @selector(titleAttributes));
}

+ (void)setLargeTitleColor:(UIColor *)largeTitleColor
{
    objc_setAssociatedObject(self.global, @selector(largeTitleColor), largeTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)largeTitleColor
{
    // 系统默认是nil，模糊半透明
    return objc_getAssociatedObject(self.global, @selector(largeTitleColor)) ?: [UIColor blackColor];
}

+ (void)setLargeTitleFont:(UIFont *)largeTitleFont
{
    objc_setAssociatedObject(self.global, @selector(largeTitleFont), largeTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIFont *)largeTitleFont
{
    return objc_getAssociatedObject(self.global, @selector(largeTitleFont)) ?: [UIFont boldSystemFontOfSize:33.0];
}

+ (void)setLargeTitleAttributes:(NSDictionary *)largeTitleAttributes
{
    objc_setAssociatedObject(self.global, @selector(largeTitleAttributes), largeTitleAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSDictionary *)largeTitleAttributes
{
    return objc_getAssociatedObject(self.global, @selector(largeTitleAttributes));
}

+ (void)setBackButtonImage:(UIImage *)backButtonImage
{
    objc_setAssociatedObject(self.global, @selector(backButtonImage), backButtonImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIImage *)backButtonImage
{
    UIImage *backButtonImage = objc_getAssociatedObject(self.global, @selector(backButtonImage));
    return backButtonImage ?: [UIImage imageNamed:@"navigation_back_image_default" inAssets:@"UIViewController"];
}

+ (void)setCloseButtonImage:(UIImage *)closeButtonImage
{
    objc_setAssociatedObject(self.global, @selector(closeButtonImage), closeButtonImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIImage *)closeButtonImage
{
    UIImage *closeButtonImage = objc_getAssociatedObject(self.global, @selector(closeButtonImage));
    return closeButtonImage ?: [UIImage imageNamed:@"navigation_close_image_default" inAssets:@"UIViewController"];
}

@end
