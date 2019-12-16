//
//  UIViewController+Global.h
//  TTTFramework
//
//  Created by jia on 2017/10/15.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerGlobalProtocol <NSObject>

// 全局控制样式
@property (nonatomic, readonly, class) Class global;

@property (nonatomic, strong, class) UIColor *backgroundColor;
@property (nonatomic, strong, class) UIColor *separatorColor;

@end

@interface UIViewController (Global) <UIViewControllerGlobalProtocol>

@end
