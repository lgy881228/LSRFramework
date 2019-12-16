//
//  UINavigationItem+Customized.h
//  TTTFramework
//
//  Created by jia on 2016/12/5.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UINavigationItemCustomizedProtocol <NSObject>

// 传非color使用系统默认 传nil使用默认
@property (nonatomic, strong) UIColor *barButtonItemColor;

// 传非color使用系统默认 传nil使用默认
@property (nonatomic, strong) UIFont  *barButtonItemFont;

// 传非color使用系统默认 传nil使用默认 除非用户单独设置，否则和barButtonItemColor一致
@property (nonatomic, strong) UIColor *backButtonItemColor;

// 传非color使用系统默认 传nil使用默认 除非用户单独设置，否则和barButtonItemColor一致
@property (nonatomic, strong) UIColor *closeButtonItemColor;

@property (nonatomic, readonly) CGFloat barButtonItemSideSpacing;
@property (nonatomic, readonly) CGFloat titleButtonItemSideSpacing;
@property (nonatomic, readonly) CGFloat imageButtonItemSideSpacing;
@property (nonatomic, readonly) CGFloat backButtonItemSideSpacing;

@property (nonatomic, readwrite) CGSize barButtonItemSize;

// 下面2个按钮图片高度尽量不超过22，否则横屏时会压扁
@property (nonatomic, readwrite) CGSize backButtonItemSize;
@property (nonatomic, readwrite) CGSize closeButtonItemSize;

@end

@interface UINavigationItem (Customized) <UINavigationItemCustomizedProtocol>

// 判断是否使用默认
@property (nonatomic, readonly) BOOL isDefaultBarButtonItemColor;
@property (nonatomic, readonly) BOOL isDefaultBarButtonItemFont;

@end
