//
//  NavigationController.h
//  TTTFramework
//
//  Created by jia on 16/4/12.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+Customized.h"
#import "NavigationBar.h"

@interface NavigationController : UINavigationController

// defaults to YES
@property (nonatomic, readwrite) BOOL navigationBarTranslucent;

// default to NO
@property (nonatomic, readwrite) BOOL customizedNavigationBarTranslucent;

@end
