//
//  AppDelegate.m
//  Example
//
//  Created by jia on 2019/3/19.
//  Copyright © 2019 jia. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SettingsViewController.h"
#import "BlurEffectViewController.h"
#import "TabBarController+Theme.h"
#import <TTTFramework/TTTFramework.h>

@interface AppDelegate () <UINavigationControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setupUserInterface];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Setup
- (void)setupUserInterface
{
    [self setupWindow];
    
    [self setupViewController];
}

- (void)setupWindow
{
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UINavigationBar.global setColor:RGBCOLOR(91, 29, 173)];
    [UINavigationBar.global setTitleColor:[UIColor yellowColor]];
    [UINavigationBar.global setTitleFont:[UIFont boldSystemFontOfSize:17.0]];
    [UINavigationBar.global setLargeTitleColor:[UIColor yellowColor]];
    [UINavigationBar.global setLargeTitleFont:[UIFont boldSystemFontOfSize:34.0]];
    
    [UINavigationItem.global setBarButtonItemColor:[UIColor greenColor]];
    [UINavigationItem.global setBarButtonItemFont:[UIFont systemFontOfSize:16.0]];
    
    [NavigationController.global setNavigationBarTranslucent:NO];
    // [NavigationController.global setCustomizedNavigationBarTranslucent:YES];
    
    /* 已经调整为只读属性了
     [UINavigationItem.global setBarButtonItemTitleSideSpacing:10.0];
     [UINavigationItem.global setBarButtonItemImageSideSpacing:10.0];
     [UINavigationItem.global setBarButtonItemSideSpacing:10.0];
     [UINavigationItem.global setBarButtonItemBackImageSideSpacing:15.0];
     */
    
    [UINavigationItem.global setBarButtonItemSize:CGSizeMake(25, NAVIGATION_BAR_HEIGHT)]; // 调整前是25
    [UINavigationItem.global setBackButtonItemSize:CGSizeMake(44, 22)]; // default width is 44
    
    [UINavigationItem.global setBackButtonImageOffset:CGPointMake(4.0, 0.0)];
    
    [UIViewController.global setBackgroundColor:[UIColor whiteColor]];
    [UIViewController.global setSeparatorColor:[UIColor blackColor]];
    [UIViewController.global setLoadingPromptTheme:LoadingPromptThemeDark];
    [UIViewController.global setLoadingPromptTitleFont:[UIFont boldSystemFontOfSize:14.0]];
    [UIViewController.global setLoadingPromptCornerRadius:8.0];
    [UIViewController.global setLoadingPromptMargin:25.0];
}

- (void)setupViewController
{
    NavigationControllerConstructor ncc = ^(UINavigationController **nc, UIViewController *vc) {
        
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:vc];
        navigationController.delegate = self;
        *nc = navigationController;
    };
    
    TabBarController *tabBarController = [[TabBarController alloc] init];
    tabBarController.tabBar.translucent = YES;
    
    tabBarController.tabBarItemTitles = @[NSLocalizedString(@"首页", nil),
                                          NSLocalizedString(@"我的", nil)];
    tabBarController.tabBarItemImages = @[[UIImage imageNamed:@"home_tab_bar_home"],
                                          [UIImage imageNamed:@"home_tab_bar_mine"]];
    tabBarController.tabBarItemSelectedImages = @[[UIImage imageNamed:@"home_tab_bar_home_selected"],
                                                  [UIImage imageNamed:@"home_tab_bar_mine_selected"]];
    tabBarController.tabBarItemTitleOffset = UIOffsetMake(0, -2);
    tabBarController.tabBarItemTitleNormalColor = RGBCOLOR(102, 102, 102);
    tabBarController.tabBarItemTitleSelectedColor = [UIColor purpleColor];
    tabBarController.tabBarItemImageNormalColor = RGBCOLOR(102, 102, 102);
    tabBarController.tabBarItemImageSelectedColor = [UIColor purpleColor];
    tabBarController.contentViewControllers = @[[[ViewController alloc] init],
                                                [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    tabBarController.navigationControllerConstructor = ncc;
    [tabBarController loadChildViewControllers];
    [tabBarController observeTabBarChanging];
    
    [self updateRootViewController:tabBarController animated:YES];
}

- (void)updateRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated
{
    if (animated)
    {
        rootViewController.view.alpha = .0f;
        [UIView animateWithDuration:1.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             rootViewController.view.alpha = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             
                             //
                         }];
    }
    
    self.window.rootViewController = rootViewController;
    
    //    BlurEffectViewController *blurEffect = [BlurEffectViewController new];
    //
    //    [self.window addSubview:blurEffect.view];
    //
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //        [blurEffect.view removeFromSuperview];
    //    });
    
}

#pragma mark - Navigation
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"navigation controllers count: %ld", navigationController.viewControllers.count);
    
    if (navigationController.tabBarController) {
        if (navigationController.viewControllers.count > 1) {
            if (navigationController.tabBarController.isTabBarShowing) {
                [navigationController.tabBarController hideTabBar];
            }
        } else if (navigationController.viewControllers.count == 1) {
            if (!navigationController.tabBarController.isTabBarShowing) {
                [navigationController.tabBarController showTabBar];
            }
        }
    }
}
@end
