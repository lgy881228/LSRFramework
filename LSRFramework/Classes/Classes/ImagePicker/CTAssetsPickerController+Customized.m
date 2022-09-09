//
//  CTAssetsPickerController+Customized.m
//  TTTFramework
//
//  Created by jia on 2016/12/3.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "CTAssetsPickerController+Customized.h"
#import "NavigationController.h"

@implementation CTAssetsPickerController (Customized)

- (BOOL)customizedEnabled
{
    return YES;
}

- (BOOL)prefersNavigationBarLeftSideCloseButtonWhenPresented
{
    return NO;
}

+ (Class)navigationControllerClass
{
    return [NavigationController class];
}

@end
