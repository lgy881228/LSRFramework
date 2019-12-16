//
//  UINavigationBar+Customized.h
//  TTTFramework
//
//  Created by jia on 2016/12/5.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kShadowImageGrayValue 176.0/255.0

@protocol UINavigationBarCustomizedProtocol <NSObject>

@property (nonatomic, readonly) id _Nullable color;

@end

@interface UINavigationBar (Customized) <UINavigationBarCustomizedProtocol>

@property (nonatomic, strong, nullable) id color;

@property (nonatomic, strong, nonnull) UIColor      *titleColor;
@property (nonatomic, strong, nonnull) UIFont       *titleFont;
@property (nonatomic, strong, nonnull) NSDictionary *titleAttributes;

@property (nonatomic, strong, nonnull) UIColor      *largeTitleColor;
@property (nonatomic, strong, nonnull) UIFont       *largeTitleFont;
@property (nonatomic, strong, nonnull) NSDictionary *largeTitleAttributes;

/*
 ios11之后shadowImage可以自由设置
 ios11之前：
 navigationBar setBackgroundImage:image 之后 隐藏阴影才有效
 navigationBar setBackgroundImage:nil   之后 显示阴影才有效
 */
@property (nonatomic) BOOL shadowImageEnabled;

@end
