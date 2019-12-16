//
//  UIViewController+Global.m
//  TTTFramework
//
//  Created by jia on 2017/10/15.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UIViewController+Global.h"
#import <objc/runtime.h>
#import "TTTFrameworkCommonDefines.h"

@implementation UIViewController (Global)

#pragma mark - Properties
+ (Class)global
{
    return [UIViewController class];
}

+ (void)setBackgroundColor:(UIColor *)backgroundColor
{
    objc_setAssociatedObject(self.global, @selector(backgroundColor), backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)backgroundColor
{
    UIColor *backgroundColor = objc_getAssociatedObject(self.global, @selector(backgroundColor));
    return backgroundColor ?: RGBCOLOR(255, 255, 255);
}

+ (void)setSeparatorColor:(UIColor *)separatorColor
{
    objc_setAssociatedObject(self.global, @selector(separatorColor), separatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)separatorColor
{
    UIColor *separatorColor = objc_getAssociatedObject(self.global, @selector(separatorColor));
    return separatorColor ?: RGBCOLOR(229, 229, 229);
}

@end
