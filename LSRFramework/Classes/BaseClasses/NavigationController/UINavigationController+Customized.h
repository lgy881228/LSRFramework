//
//  UINavigationController+Customized.h
//  TTTFramework
//
//  Created by jia on 2016/12/5.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Customized)

@property (nonatomic, readonly) UIColor      *navigationBarColor;
@property (nonatomic, readonly) UIColor      *navigationBarTitleColor;
@property (nonatomic, readonly) UIFont       *navigationBarTitleFont;
@property (nonatomic, readonly) NSDictionary *navigationBarTitleAttributes;

@property (nonatomic, readonly) UIColor      *navigationBarLargeTitleColor;
@property (nonatomic, readonly) UIFont       *navigationBarLargeTitleFont;
@property (nonatomic, readonly) NSDictionary *navigationBarLargeTitleAttributes;

- (void)updateNavigationBarColor:(UIColor *)navigationBarColor;

- (void)updateNavigationBarTitleColor:(UIColor *)navigationBarTitleColor;
- (void)updateNavigationBarTitleFont:(UIFont *)navigationBarTitleFont;
- (void)updateNavigationBarTitleAttributes:(NSDictionary *)navigationBarTitleAttributes;

- (void)updateNavigationBarLargeTitleColor:(UIColor *)navigationBarTitleColor;
- (void)updateNavigationBarLargeTitleFont:(UIFont *)navigationBarTitleFont;
- (void)updateNavigationBarLargeTitleAttributes:(NSDictionary *)navigationBarTitleAttributes;

@end
