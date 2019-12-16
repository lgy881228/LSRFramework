//
//  NSObject+Swizzle.h
//  TTTFramework
//
//  Created by jia on 2016/11/22.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

+ (void)swizzleInstanceSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector;

@end
