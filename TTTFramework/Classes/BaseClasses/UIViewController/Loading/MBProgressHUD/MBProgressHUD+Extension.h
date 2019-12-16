//
//  MBProgressHUD+Extension.h
//  TTTFramework
//
//  Created by jia on 16/5/6.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM (NSInteger, MBProgressHUDTheme)
{
    MBProgressHUDThemePure = 0,
    MBProgressHUDThemeLight,
    MBProgressHUDThemeDark
};

@interface MBProgressHUD (Extension)

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style;

- (void)setActivityIndicatorTransformScale:(CGFloat)scale;

- (void)setMBProgressHUDLook:(MBProgressHUDTheme)look;

@end
