//
//  TabBarController.h
//  TTTFramework
//
//  Created by jia on 16/4/21.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UITabBarController+TabBar.h"

typedef void (^NavigationControllerConstructor)(UINavigationController **nc, UIViewController *vc);

@interface TabBarController : UITabBarController

// input images
@property (nonatomic, strong) NSArray *tabBarItemImages;
@property (nonatomic, strong) NSArray *tabBarItemSelectedImages;

@property (nonatomic, strong) UIColor *tabBarItemImageNormalColor;
@property (nonatomic, strong) UIColor *tabBarItemImageSelectedColor;

// input titles
@property (nonatomic, strong) NSArray *tabBarItemTitles;
@property (nonatomic, strong) UIFont *tabBarItemTitleFont;
@property (nonatomic, assign) UIOffset tabBarItemTitleOffset;

@property (nonatomic, strong) UIColor *tabBarItemTitleNormalColor;
@property (nonatomic, strong) UIColor *tabBarItemTitleSelectedColor;

@property (nonatomic, strong) NSArray *contentViewControllers;

@property (nonatomic, copy) NavigationControllerConstructor navigationControllerConstructor;

#pragma mark - Member Methods
// 构建TabBarController，属性都设置完毕之后调用
- (void)loadChildViewControllers;

// 刷新Tab Bar上的项目
- (void)reloadTabBarItems;

@end
