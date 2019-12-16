//
//  UIBarButtonItem+Extension.m
//  TTTFramework
//
//  Created by jia on 16/5/19.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIImage+Extension.h"
#import "UIColor+Extension.h"
#import "UIButton+ImageWithColor.h"

@implementation UIBarButtonItem (Extension)

- (void)styleToFitColor:(UIColor *)color font:(UIFont *)font
{
//    CGFloat red, green, blue, alpha;
//    [color getRed:&red green:&green blue:&blue alpha:&alpha];
//    red *= 255; green *= 255; blue *= 255;
    
    if (self.customView)
    {
        if ([self.customView isKindOfClass:[UIButton class]])
        {
            UIButton *btn = self.customView;
            if ([btn imageForState:UIControlStateNormal])
            {
                [btn setImageColor:color];
            }
            
            if ([btn titleForState:UIControlStateNormal])
            {
                [btn.titleLabel setFont:font];

                [btn setTitle:[btn titleForState:UIControlStateNormal] withColor:color];
            }
        }
    }
    else if (self.title)
    {
        [self setTitleTextAttributes:@{NSFontAttributeName : font,
                                             NSForegroundColorAttributeName : color}
                                  forState:UIControlStateNormal];
        [self setTitleTextAttributes:@{NSFontAttributeName : font,
                                             NSForegroundColorAttributeName : color.highlightedColor}
                                  forState:UIControlStateHighlighted];
        [self setTitleTextAttributes:@{NSFontAttributeName : font,
                                             NSForegroundColorAttributeName : color.disabledColor}
                                  forState:UIControlStateDisabled];
    }
    else if (self.image)
    {
        self.image = [self.image imageWithCustomTintColor:color];
    }
    else
    {
        // do nothing
    }
}

@end
