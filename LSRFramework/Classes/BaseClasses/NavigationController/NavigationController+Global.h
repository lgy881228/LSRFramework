//
//  NavigationController+Global.h
//  TTTFramework
//
//  Created by jia on 2017/11/7.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "NavigationController.h"

@protocol NavigationControllerGlobalProtocol <NSObject>

// 全局控制样式
@property (nonatomic, readonly, class) Class global;

// defaults to YES
@property (nonatomic, readwrite, class) BOOL navigationBarTranslucent;

// default to NO
@property (nonatomic, readwrite, class) BOOL customizedNavigationBarTranslucent;

@end

@interface NavigationController (Global) <NavigationControllerGlobalProtocol>

@end
