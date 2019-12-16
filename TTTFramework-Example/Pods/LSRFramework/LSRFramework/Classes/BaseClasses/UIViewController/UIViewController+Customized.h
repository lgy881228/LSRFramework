//
//  UIViewController+Customized.h
//  TTTFramework
//
//  Created by jia on 16/6/1.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationBarShadowImageState)
{
    NavigationBarShadowImageStateEnabled   = 0, // 始终显示
    NavigationBarShadowImageStateDisabled  = 1, // 始终隐藏
    NavigationBarShadowImageStateAutomatic = 2, // 根据导航栏color的alpha值，自动显示（alpha >= 0.9999）和隐藏
};

@protocol UIViewControllerCustomizedProtocol <NSObject>

// 是否使用设计好的效果和功能, defaults to YES
@property (nonatomic, readwrite) BOOL customizedEnabled;

// 白名单里包含的class如：UIViewController，UINavigationController，UITableViewController，UICollectionViewController, 他们的customizedEnabled属性默认为 YES
@property (nonatomic, strong, class) NSMutableSet *customizedWhiteList;

#pragma mark - Navigation Bar
/*
 控制是否想要隐藏导航栏
 defaults to NO
 */
@property (nonatomic, readwrite) BOOL prefersNavigationBarHidden;

/*
 定制导航栏颜色
 传不是UIColor的对象代表使用系统默认（区别于默认）
 传nil表示重置，即使用默认（区别于系统默认）
 设置之后不会立即生效，如果需要立即生效需要执行self navigationBarColorToFit，或者self navigationBarStylesToFit。
 */
@property (nonatomic, strong) UIColor *preferredNavigationBarColor;

/*
 定制导航栏底部阴影线条隐藏或显示
 default to NavigationBarShadowImageStateEnabled
 */
@property (nonatomic, readwrite) NavigationBarShadowImageState preferredNavigationBarShadowImageState;

/*
 定制导航栏标题颜色
 传不是UIColor的对象代表使用系统默认（区别于默认）
 传nil表示重置，即使用默认（区别于系统默认）
 */
@property (nonatomic, strong) UIColor *preferredNavigationBarTitleColor;

/*
 定制导航栏标题字体
 传nil表示重置，即使用默认（区别于系统默认）
 */
@property (nonatomic, strong) UIFont  *preferredNavigationBarTitleFont;

/*
 定制导航栏大标题颜色
 传不是UIColor的对象代表使用系统默认（区别于默认）
 传nil表示重置，即使用默认（区别于系统默认）
 */
@property (nonatomic, strong) UIColor *preferredNavigationBarLargeTitleColor;

/*
 定制导航栏大标题字体
 传nil表示重置，即使用默认（区别于系统默认）
 */
@property (nonatomic, strong) UIFont  *preferredNavigationBarLargeTitleFont;

#pragma mark - Status Bar
/*
 控制是否想要隐藏状态栏
 System defaults to NO
 */
@property (nonatomic, readwrite) BOOL prefersStatusBarHidden;

/*
 控制是否总是使用浅色状态栏
 defaults to NO
 */
@property (nonatomic, readwrite) BOOL prefersStatusBarStyleLightContent;

/*
 控制是否总是使用深色状态栏
 defaults to NO
 */
@property (nonatomic, readwrite) BOOL prefersStatusBarStyleDarkContent;

#pragma mark - Autorotate
/*
 控制是否使用屏幕旋转
 defaults to YES
 */
@property (nonatomic, readwrite) BOOL autorotateEnabled;

@end

@interface UIViewController (Customized) <UIViewControllerCustomizedProtocol>

@end
