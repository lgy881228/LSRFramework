//
//  UIColor+Extension.h
//  FileBox
//
//  Created by jia on 16/4/26.
//  Copyright © 2016年 OrangeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTFrameworkCommonDefines.h"

#define SYSTEM_NAVIGATION_BAR_COLOR             nil
#define SYSTEM_NAVIGATION_BAR_TITLE_COLOR       RGBCOLOR(0, 0, 0)
#define SYSTEM_NAVIGATION_BAR_BUTTON_ITEM_COLOR RGBCOLOR(0, 64, 221)

#define SHADOW_IMAGE_GRAY_VALUE         176.0/255.0

@interface UIColor (Extension)

- (UIColor *)highlightedColor;
- (UIColor *)disabledColor;

// 判断两个颜色是否一样
+ (BOOL)isColor:(UIColor *)aColor sameToColor:(UIColor *)bColor;
- (BOOL)isSameToColor:(UIColor *)bColor;

- (BOOL)isLightContent;
- (BOOL)isClearColor;

@end
