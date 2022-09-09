//
//  UINavigationBar+Global.h
//  TTTFramework
//
//  Created by jia on 2017/10/15.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UINavigationBarGlobalProtocol <NSObject>

// 全局控制样式
@property (nonatomic, readonly, class, nonnull) Class global;

@property (nonatomic, strong, class, nullable) id color;

@property (nonatomic, strong, class, nonnull) UIColor      *titleColor;
@property (nonatomic, strong, class, nonnull) UIFont       *titleFont;
@property (nonatomic, strong, class, nonnull) NSDictionary *titleAttributes;

@property (nonatomic, strong, class, nonnull) UIColor      *largeTitleColor;
@property (nonatomic, strong, class, nonnull) UIFont       *largeTitleFont;
@property (nonatomic, strong, class, nonnull) NSDictionary *largeTitleAttributes;

@property (nonatomic, strong, class, nonnull) UIImage *backButtonImage;
@property (nonatomic, strong, class, nonnull) UIImage *closeButtonImage;

@end

@interface UINavigationBar (Global) <UINavigationBarGlobalProtocol>

@end
