//
//  UIView+Debug.m
//  Sleep
//
//  Created by jia on 2017/8/13.
//  Copyright © 2017年 JiaJunbo. All rights reserved.
//

#import "UIView+Debug.h"
#import <TTTFramework/NSObject+Swizzle.h>

@implementation UIView (Debug)

#pragma mark - Swizzle
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleInstanceSelector:@selector(setBackgroundColor:) withSelector:@selector(debug_setBackgroundColor:)];
    });
}

- (void)debug_setBackgroundColor:(UIColor *)backgroundColor
{
#if DEBUG
#ifdef COLORFUL_DEBUG
    backgroundColor = [UIColor colorWithRed:(arc4random() % 255)/255.0 green:(arc4random() % 255)/255.0 blue:(arc4random() % 255)/255.0 alpha:1.0];
#endif
#endif
    
    [self debug_setBackgroundColor:backgroundColor];
}

@end
