//
//  UIDevice+Orientation.m
//  FileBox
//
//  Created by jia on 16/4/19.
//  Copyright © 2016年 OrangeTeam. All rights reserved.
//

#import "UIDevice+Orientation.h"

@implementation UIDevice (Orientation)

+ (void)setOrientation:(UIInterfaceOrientation)orientation
{
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[self currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

@end
