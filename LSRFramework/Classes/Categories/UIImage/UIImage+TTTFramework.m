//
//  UIImage+TTTFramework.m
//  TTTFramework
//
//  Created by jia on 2017/7/17.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UIImage+TTTFramework.h"
#import "TTTFrameworkResources.h"

@implementation UIImage (TTT)

+ (UIImage *)imageNamed:(NSString *)imageName inAssets:(NSString *)assetsName
{
    return [TTTFrameworkResources imageNamed:imageName inAssets:assetsName];
}

@end
