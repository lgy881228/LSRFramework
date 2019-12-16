//
//  UIButton+ImageWithColor.h
//  TTTFramework
//
//  Created by jia on 2017/4/27.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ImageWithColor)

- (void)setImage:(UIImage *)image withColor:(UIColor *)color;
- (void)setImageColor:(UIColor *)color;

- (void)setTitle:(NSString *)title withColor:(UIColor *)color;

@end
