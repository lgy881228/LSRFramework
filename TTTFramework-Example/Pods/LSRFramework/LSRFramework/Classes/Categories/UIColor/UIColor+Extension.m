//
//  UIColor+Extension.m
//  FileBox
//
//  Created by jia on 16/4/26.
//  Copyright © 2016年 OrangeTeam. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

- (UIColor *)highlightedColor
{
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:0.25f];
}

- (UIColor *)disabledColor
{
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:0.25f];
}

+ (BOOL)isColor:(UIColor *)aColor sameToColor:(UIColor *)bColor
{
    return [aColor isSameToColor:bColor];
}

- (BOOL)isSameToColor:(UIColor *)bColor
{
    CGFloat aRed, aGreen, aBlue, aAlpha;
    CGFloat bRed, bGreen, bBlue, bAlpha;
    [self getRed:&aRed green:&aGreen blue:&aBlue alpha:&aAlpha];
    [bColor getRed:&bRed green:&bGreen blue:&bBlue alpha:&bAlpha];
    
    return (aRed == bRed) && (aGreen == bGreen) && (aBlue == bBlue) && (aAlpha == bAlpha);
}

- (BOOL)isLightContent
{
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (red > SHADOW_IMAGE_GRAY_VALUE &&
        green > SHADOW_IMAGE_GRAY_VALUE &&
        blue > SHADOW_IMAGE_GRAY_VALUE)
    {
        // light
        return YES;
    }
    else if (0 == red && 0 == green && 0 == blue && 0 == alpha)
    {
        // clear
        return YES;
    }
    else
    {
        // dark
        return NO;
    }
}

- (BOOL)isClearColor
{
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (0 == red && 0 == green && 0 == blue && 0 == alpha)
    {
        // clear
        return YES;
    }
    else
    {
        // dark
        return NO;
    }
}

@end
