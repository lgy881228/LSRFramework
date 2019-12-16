//
//  UIViewController+Protected.m
//  TTTFramework
//
//  Created by jia on 2017/10/15.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UIViewController+Protected.h"
#import "UINavigationBar+Global.h"
#import "UIViewController+.h"
#import "UINavigationItem+BarButtonItem.h"

@implementation UIViewController (Protected)

- (void)setupNavigationBarLeftSideFunctionalButton
{
    if ([self shouldAddCloceButton])
    {
        [self addCloseButton];
    }
    else if ([self shouldAddBackButton])
    {
        [self addBackButton];
        self.navigationBarLeftButton.hidden = ![self prefersNavigationBarLeftSideBackButtonWhenPushed];
    }
    else
    {
        // do nothing
    }
}

#pragma mark - Button
- (BOOL)shouldAddCloceButton
{
    if (self.presentingViewController)
    {
        // present
        if (self.navigationController)
        {
            if (self.navigationController.viewControllers.count <= 1)
            {
                if ([self prefersNavigationBarLeftSideCloseButtonWhenPresented])
                {
                    return YES;
                }
            }
            
            // there is a self.splitViewController in vc, it's self.navigationController's count is 0, but should using back button.
        }
        else
        {
            if ([self prefersNavigationBarLeftSideCloseButtonWhenPresented])
            {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)shouldAddBackButton
{
    if (self.navigationController && self.navigationController.viewControllers.count > 1 && [self.navigationController.topViewController isEqual:self])
    {
        return YES;
    }
    return NO;
}

- (void)addCloseButton
{
    UIImage *closeButtonImage = self.customCloseButtonImage ?: UINavigationBar.closeButtonImage;
    closeButtonImage = [closeButtonImage imageWithCustomTintColor:self.wantedNavigationItem.closeButtonItemColor];
    [self addNavigationBarCloseButtonItemWithImage:closeButtonImage action:@selector(closeButtonClicked:)];
}

- (void)addBackButton
{
    UIImage *backButtonImage = self.customBackButtonImage ?: UINavigationBar.backButtonImage;
    backButtonImage = [backButtonImage imageWithCustomTintColor:self.wantedNavigationItem.backButtonItemColor];
    [self addNavigationBarBackButtonItemWithImage:backButtonImage action:@selector(backButtonClicked:)];
}

@end
