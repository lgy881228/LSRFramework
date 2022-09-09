//
//  TTTFrameworkScreenParameters.h
//  TTTFramework
//
//  Created by jia on 2016/11/30.
//  Copyright © 2016年 jia. All rights reserved.
//

#ifndef TTTFrameworkScreenParameters_h
#define TTTFrameworkScreenParameters_h

// 屏幕属性：宽 高 缩放比
#define SCREEN_WIDTH                   ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                  ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_SCALE                   ([UIScreen mainScreen].scale)

#define ONE_PIXEL                      (1.0/SCREEN_SCALE)

// 状态栏高度
#define STATUS_BAR_HEIGHT              CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])

// 导航栏高度
#define NAVIGATION_BAR_HEIGHT          44.0

// 切换栏高度
#define TAB_BAR_HEIGHT                 49.0

// 安全区
#define SAFE_AREA_INSETS               (@available(iOS 11.0, *) ?\
                                       UIApplication.sharedApplication.keyWindow.safeAreaInsets : UIEdgeInsetsZero)

#define SAFE_AREA_LEFT_SPACING         SAFE_AREA_INSETS.left
#define SAFE_AREA_RIGHT_SPACING        SAFE_AREA_INSETS.right
#define SAFE_AREA_TOP_SPACING          SAFE_AREA_INSETS.top
#define SAFE_AREA_BOTTOM_SPACING       SAFE_AREA_INSETS.bottom
#define SAFE_AREA_SIDE_SPACING         fmax(SAFE_AREA_LEFT_SPACING, SAFE_AREA_RIGHT_SPACING)

// 切换栏区域
#define TAB_BAR_AREA_HEIGHT            (TAB_BAR_HEIGHT + SAFE_AREA_INSETS.bottom)

// 是否是全面屏（如iphoneX）
#define IS_ALL_SCREEN_DEVICE           (@available(iOS 11.0, *) ? SAFE_AREA_INSETS.bottom > 0.0 : NO)

// 是否是 iPhone Plus
#define IS_IPHONE_PLUS                 ((MIN(SCREEN_WIDTH, SCREEN_HEIGHT)) >= 414)

// 导航栏元素距离屏幕边距
#define PREFERRED_SCREEN_SIDE_SPACING  (IS_IPHONE_PLUS ? 20.0 : 16.0)

#endif /* TTTFrameworkScreenParameters_h */
