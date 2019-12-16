//
//  UIViewController+TTTFramework.m
//  TTTFramework
//
//  Created by jia on 2016/11/15.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UIViewController+TTTFramework.h"
#import "UIViewController+.h"
#import "UIViewController+Protected.h"
#import "NSObject+Swizzle.h"
#import "UINavigationBar+Customized.h"
#import "UINavigationController+Customized.h"
#import "UINavigationBar+Customized.h"
#import "UINavigationBar+Global.h"
#import "UINavigationItem+BarButtonItem.h"
#import "TTTFrameworkScreenParameters.h"
#import <objc/runtime.h>

@implementation UIViewController (TTT)

#pragma mark - Swizzle
+ (void)load
{    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleInstanceSelector:@selector(viewDidLoad) withSelector:@selector(uiviewController_viewDidLoad)];
        [self swizzleInstanceSelector:@selector(viewWillAppear:) withSelector:@selector(uiviewController_viewWillAppear:)];
        [self swizzleInstanceSelector:@selector(viewDidAppear:) withSelector:@selector(uiviewController_viewDidAppear:)];
        [self swizzleInstanceSelector:@selector(viewWillDisappear:) withSelector:@selector(uiviewController_viewWillDisappear:)];
        [self swizzleInstanceSelector:@selector(viewDidDisappear:) withSelector:@selector(uiviewController_viewDidDisappear:)];
        
        [self swizzleInstanceSelector:@selector(preferredStatusBarStyle) withSelector:@selector(uiviewController_preferredStatusBarStyle)];
        
        [self swizzleInstanceSelector:@selector(shouldAutorotate) withSelector:@selector(uiviewController_shouldAutorotate)];
        [self swizzleInstanceSelector:@selector(uiviewController_supportedInterfaceOrientations) withSelector:@selector(supportedInterfaceOrientations)];
        [self swizzleInstanceSelector:@selector(uiviewController_preferredInterfaceOrientationForPresentation) withSelector:@selector(preferredInterfaceOrientationForPresentation)];
        
        [self swizzleInstanceSelector:NSSelectorFromString(@"dealloc") withSelector:@selector(uiviewController_dealloc)];
    });
}

- (void)uiviewController_dealloc
{
    objc_removeAssociatedObjects(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self uiviewController_dealloc];
}

- (void)uiviewController_viewDidLoad
{
    [self uiviewController_viewDidLoad];
    
    // 无论是在viewDidLoad还是viewWillAppear中设置背景色，都会使某些系统VC（UIAlertController，MFMessageComposeViewController等）显示不出来
    if (self.backgroundSettingEnabled)
    {
        // for background setting enabled vc
        self.view.backgroundColor = [UIViewController.global backgroundColor];
    }
    
    if (self.customizedEnabled)
    {
        if (self.prefersNavigationBarHidden && self.navigationController)
        {
            self.navigationController.navigationBarHidden = YES;
        }
        
        // 是否根据按所在界面的navigationbar与tabbar的高度，自动调整scrollview的inset（从透明的bar后面调整出来：缩进）
        self.automaticallyAdjustsScrollViewInsets = YES;
        
        // 边缘要延伸的方向
        self.edgesForExtendedLayout = UIRectEdgeAll;
        
        // 对于不透明的导航栏，YES：原点是屏幕左上角，NO：原点为导航栏左下角；透明的导航栏不受此属性影响
        self.extendedLayoutIncludesOpaqueBars = YES;
        
        // for customized enabled vc
        self.view.backgroundColor = [UIViewController.global backgroundColor];
    }
}

- (void)uiviewController_viewWillAppear:(BOOL)animated
{
    [self uiviewController_viewWillAppear:animated];
    
    if (self.customizedEnabled)
    {
        [self setupNavigationBarAutomatically];
        
        [self statusBarStyleToFit];
    }
}

- (void)uiviewController_viewDidAppear:(BOOL)animated
{
    [self uiviewController_viewDidAppear:animated];
    
    self.viewActive = YES;
}

- (void)uiviewController_viewWillDisappear:(BOOL)animated
{
    self.viewActive = NO;
    
    [self uiviewController_viewWillDisappear:animated];
}

- (void)uiviewController_viewDidDisappear:(BOOL)animated
{
    if (self.customizedEnabled)
    {
        [self hideLoading];
    }
    
    self.firstTimeViewAppear = NO;
    
    [self uiviewController_viewDidDisappear:animated];
}

- (UIStatusBarStyle)uiviewController_preferredStatusBarStyle
{
    if (self.customizedEnabled)
    {
        if (self.prefersStatusBarStyleLightContent)
        {
            return UIStatusBarStyleLightContent;
        }
        else if (self.prefersStatusBarStyleDarkContent)
        {
            return UIStatusBarStyleDefault;
        }
        else
        {
            if (self.navigationController)
            {
                if (!self.preferredNavigationBarColor && UIBarStyleBlack == self.navigationController.navigationBar.barStyle)
                {
                    return UIStatusBarStyleLightContent;
                }
                else
                {
                    return [self statusBarStyleToColor:self.preferredNavigationBarColor];
                }
            }
            else
            {
                // 没有导航栏的vc，默默人当成白页面+黑状态栏
                return UIStatusBarStyleDefault;
            }
        }
    }
    else
    {
        return [self uiviewController_preferredStatusBarStyle];
    }
}

- (BOOL)uiviewController_shouldAutorotate
{
    if (self.customizedEnabled)
    {
        return self.autorotateEnabled;
    }
    return [self uiviewController_shouldAutorotate];
}

- (UIInterfaceOrientationMask)uiviewController_supportedInterfaceOrientations
{
    if (self.customizedEnabled)
    {
        return [self shouldAutorotate] ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait;
    }
    return [self uiviewController_supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)uiviewController_preferredInterfaceOrientationForPresentation
{
    if (self.customizedEnabled)
    {
        return UIInterfaceOrientationPortrait;
    }
    else
    {
        return [self uiviewController_preferredInterfaceOrientationForPresentation];
    }
}

#pragma mark - Framework
- (void)setFirstTimeViewAppear:(BOOL)firstTimeViewAppear
{
    objc_setAssociatedObject(self, @selector(isFirstTimeViewAppear), @(firstTimeViewAppear), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isFirstTimeViewAppear
{
    NSNumber *isFirstTimeViewAppear = objc_getAssociatedObject(self, @selector(isFirstTimeViewAppear));
    if (isFirstTimeViewAppear)
    {
        return isFirstTimeViewAppear.boolValue;
    }
    return YES;
}

- (void)setViewActive:(BOOL)viewActive
{
    objc_setAssociatedObject(self, @selector(isViewActive), @(viewActive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isViewActive
{
    NSNumber *isViewActive = objc_getAssociatedObject(self, @selector(isViewActive));
    if (isViewActive)
    {
        return isViewActive.boolValue;
    }
    return NO;
}

#pragma mark - Navigation Bar
- (void)setupNavigationBarAutomatically
{
    [self setupNavigationBarLeftSideFunctionalButton];
    
    // 由导航的根vc控制
    [self setupPopGestureRecognizer];
    
    [self navigationBarStylesToFit];
}

// 整体调整导航栏样式
- (void)navigationBarStylesToFit
{
    if (self.navigationController)
    {
        /*
         对于[我的]这样的不显示导航栏的页面，第一次不加动画，非第一次（比如push过后，从后面的页面pop回来）要加动画
         对于该显示导航栏的页面，要加动画
         */
        if ([self prefersNavigationBarHidden])
        {
            BOOL animated = self.isFirstTimeViewAppear;
            [self.navigationController setNavigationBarHidden:YES animated:!animated];
        }
        else
        {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
    
    [self navigationBarColorToFit];
    [self navigationBarTitleAttributesToFit];
    
    [self navigationItemStyleToFit];
}

- (void)navigationBarColorToFit
{
    // 每次viewWillAppear都会执行
    // 有可能当前页面导航栏和全局一致，但下级颜色不一致，从下级回来的话，还要执行导航栏颜色设置，以保证当前页面导航栏颜色正常显示
    [self.navigationController updateNavigationBarColor:self.preferredNavigationBarColor];
    
    [self navigationBarShadowImageToFit];
}

- (void)navigationBarShadowImageToFit
{
    if (NavigationBarShadowImageStateAutomatic == self.preferredNavigationBarShadowImageState)
    {
        CGFloat red, green, blue, alpha;
        [self.preferredNavigationBarColor getRed:&red green:&green blue:&blue alpha:&alpha];
        BOOL shown = alpha >= 0.9999;
        [self.navigationController.navigationBar setShadowImageEnabled:shown];
    }
    else
    {
        BOOL hidden = self.preferredNavigationBarShadowImageState;
        [self.navigationController.navigationBar setShadowImageEnabled:!hidden];
    }
}

- (void)navigationBarTitleAttributesToFit
{
    // 每次viewWillAppear都会执行
    NSDictionary *attributes = nil;
    if (!self.preferredNavigationBarTitleColor &&
        !self.preferredNavigationBarTitleFont)
    {
        // 有可能当前页面导航栏和全局一直，但下级颜色不一致，从下级回来的话 还要执行导航栏颜色设置 保证当前页面导航栏颜色正常显示
        attributes = [UINavigationBar.global titleAttributes];
    }
    else
    {
        NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:self.navigationController.navigationBarTitleAttributes];
        if (self.preferredNavigationBarTitleColor)
        {
            properties[NSForegroundColorAttributeName] = self.preferredNavigationBarTitleColor;
        }
        
        if (self.preferredNavigationBarTitleFont)
        {
            properties[NSFontAttributeName] = self.preferredNavigationBarTitleFont;
        }
        
        attributes = properties;
    }
    
    NSDictionary *largeAttributes = nil;
    if (!self.preferredNavigationBarLargeTitleColor &&
        !self.preferredNavigationBarLargeTitleFont)
    {
        // 有可能当前页面导航栏和全局一直，但下级颜色不一致，从下级回来的话 还要执行导航栏颜色设置 保证当前页面导航栏颜色正常显示
        largeAttributes = [UINavigationBar.global largeTitleAttributes];
    }
    else
    {
        NSMutableDictionary *largeProperties = [NSMutableDictionary dictionaryWithDictionary:self.navigationController.navigationBarLargeTitleAttributes];
        if (self.preferredNavigationBarLargeTitleColor)
        {
            largeProperties[NSForegroundColorAttributeName] = self.preferredNavigationBarLargeTitleColor;
        }
        
        if (self.preferredNavigationBarLargeTitleFont)
        {
            largeProperties[NSFontAttributeName] = self.preferredNavigationBarLargeTitleFont;
        }
        
        largeAttributes = largeProperties;
    }
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        [self.navigationController updateNavigationBarTitleAttributes:attributes];
        [self.navigationController updateNavigationBarLargeTitleAttributes:largeAttributes];
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        // unknown
        // [self.tabBarController.navigationController.navigationBar setTitleTextAttributes:property];
    }
    else
    {
        // unknown
    }
}

- (void)navigationItemStyleToFit
{
    // 首次viewWillAppear必执行，之后视是否为默认，不是默认则要执行
    if (self.isFirstTimeViewAppear ||
        !self.wantedNavigationItem.isDefaultBarButtonItemColor ||
        !self.wantedNavigationItem.isDefaultBarButtonItemFont)
    {
        [self.wantedNavigationItem barButtonItemsStyleToFit];
        
        // 修改系统的返回按钮颜色（系统返回按钮颜色并不随BarButtonItem颜色变化而变化）
        self.navigationController.navigationBar.tintColor = self.wantedNavigationItem.barButtonItemColor;
    }
}

#pragma mark - PopGestureRecognizer
- (void)setupPopGestureRecognizer
{
    if (self.navigationController)
    {
        if (self.navigationController.viewControllers.count == 1)
        {
            // 由导航的根vc控制
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        }
        else
        {
            // do nothing
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) // 关闭主界面的右滑返回
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - Status Bar
- (UIStatusBarStyle)statusBarStyle
{
    return [[UIApplication sharedApplication] statusBarStyle];
}

- (void)statusBarStyleToFit
{
    // 容器不影响状态栏
    if ([self isKindOfClass:UINavigationController.class])
    {
        return;
    }
    
    /*
     对于[我的]这样的不显示导航栏的页面，第一次不加动画，非第一次（比如push过后，从后面的页面pop回来）要加动画
     对于该显示导航栏的页面，要加动画
     */
    if ([self prefersStatusBarHidden])
    {
        BOOL animated = self.isFirstTimeViewAppear;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    }
    
    UIStatusBarStyle style = self.preferredStatusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:style];
}

- (void)statusBarStyleToFitColor:(UIColor *)navigationBarColor animated:(BOOL)animated
{
    // 延时执行更改状态栏风格，使状态栏风格改变的时刻和新vc展示动画结束时刻相一致，避免视觉上的生硬变化
    CGFloat seconds = animated ? 0.5f : 0.0f;
    [NSThread delaySeconds:seconds perform:^{
        
        UIStatusBarStyle style = [self statusBarStyleToColor:navigationBarColor];
        [[UIApplication sharedApplication] setStatusBarStyle:style];
    }];
}

- (UIStatusBarStyle)statusBarStyleToColor:(UIColor *)navigationBarColor
{
    if (navigationBarColor && ![navigationBarColor isKindOfClass:UIColor.class])
    {
        navigationBarColor = nil;
    }
    
    if (navigationBarColor)
    {
        if (navigationBarColor.isLightContent)
        {
            // 导航栏透明，一版都是下面为深色内容，因此配合浅色的状态栏
            if (navigationBarColor.isClearColor)
            {
                return UIStatusBarStyleLightContent;
            }
            else
            {
                return UIStatusBarStyleDefault;
            }
        }
        else
        {
            return UIStatusBarStyleLightContent;
        }
    }
    else
    {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - Tools
+ (BOOL)isMainThread
{
    return [NSThread isMainThread] || [NSOperationQueue.currentQueue isEqual:NSOperationQueue.mainQueue];
}

- (BOOL)isMainThread
{
    return [[self class] isMainThread];
}

- (void)dispatchMainThread:(void (^)(void))selector
{
    if (!selector) return;
    
    if (self.isMainThread)
    {
        selector();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            selector();
        });
    }
}

- (CGRect)visibleAreaFrame
{
    return self.view.bounds;
}

// 对于scrollView类型，frame和self.view.bounds保持一致
- (CGRect)scrollingSubviewFrame
{
    return self.view.bounds;
    
#if 0
    CGRect rect = self.view.bounds;
    CGRect scrollViewRect = [[UIScreen mainScreen] bounds];
    if (self.navigationController)
    {
        CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
        CGFloat statusBarHeight     = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        
        BOOL translucent = self.navigationController.navigationBar.translucent;
        if (translucent)
        {
            // 半透明的导航栏，view原点在屏幕左上角
        }
        else
        {
            // 不透明的导航栏，view原点在导航栏左下角
            scrollViewRect.size.height -= (statusBarHeight + navigationBarHeight);
        }
    }
    
    if (self.tabBarController)
    {
        BOOL translucent = self.tabBarController.tabBar.translucent;
        if (translucent)
        {
            // 半透明的切换栏
        }
        else
        {
            // 不透明的导航栏，view原点在导航栏左下角
            scrollViewRect.size.height -= CGRectGetHeight(self.tabBarController.tabBar.bounds);
        }
    }
    
    return scrollViewRect;
#endif
}

// 对于非scrollView类型，半透明时，比较特殊，不透明时其实就是self.view.bounds
- (CGRect)nonScrollingSubviewFrame
{
    CGRect nonScrollViewRect = self.view.bounds;
    nonScrollViewRect.origin = CGPointMake(0.0f, 0.0f);
    
    if ([self.view isKindOfClass:UITableView.class])
    {
        if (!self.prefersStatusBarHidden)
        {
            CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
            
            nonScrollViewRect.size.height -= statusBarHeight;
            nonScrollViewRect.origin.y += statusBarHeight;
        }
        
        if (self.navigationController && !self.navigationController.navigationBar.hidden)
        {
            nonScrollViewRect.size.height -= CGRectGetHeight(self.navigationController.navigationBar.bounds);
            
            if ((!self.navigationController.navigationBar.translucent && self.extendedLayoutIncludesOpaqueBars) || // 不透明的导航栏原点也为屏幕左上
                !self.automaticallyAdjustsScrollViewInsets) // 是否根据按所在界面的navigationbar与tabbar的高度，自动调整scrollview的inset（从透明的bar后面调整出来：缩进）
            {
                nonScrollViewRect.origin.y += CGRectGetHeight(self.navigationController.navigationBar.bounds);
            }
        }
        
        nonScrollViewRect.size.height -= self.bottomBarsHeight;
    }
    else
    {
        if (!self.prefersStatusBarHidden)
        {
            CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
            
            nonScrollViewRect.size.height -= statusBarHeight;
            nonScrollViewRect.origin.y += statusBarHeight;
        }
        
        if (self.navigationController && !self.navigationController.navigationBar.hidden)
        {
            CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
            
            if (self.navigationController.navigationBar.translucent || // 半透明的导航栏，原点是在屏幕坐上
                self.extendedLayoutIncludesOpaqueBars) // extendedLayoutIncludesOpaqueBars=YES, 不透明的导航栏原点也为屏幕左上
            {
                // 透明的导航栏，view原点在屏幕左上角
                nonScrollViewRect.origin.y += navigationBarHeight;
            }
            
            nonScrollViewRect.size.height -= navigationBarHeight;
        }
        
        nonScrollViewRect.size.height -= self.bottomBarsHeight;
    }
    
    return nonScrollViewRect;
}

- (CGFloat)topBarsHeight
{
    CGFloat topBarsHeight = 0.0;
    
    if (!self.prefersStatusBarHidden)
    {
        topBarsHeight += CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    }
    
    if (self.navigationController && !self.navigationController.navigationBar.hidden)
    {
        topBarsHeight += CGRectGetHeight(self.navigationController.navigationBar.bounds);
    }
    return topBarsHeight;
}

- (CGFloat)bottomBarsHeight
{
    CGFloat bottomBarsHeight = 0.0;
    
    if (self.tabBarController)
    {
        if (self.navigationController && (self.navigationController.viewControllers.count == 1))
        {
            bottomBarsHeight += CGRectGetHeight(self.tabBarController.tabBar.bounds) + SAFE_AREA_BOTTOM_SPACING;
        }
    }
    return bottomBarsHeight;
}

- (BOOL)backgroundSettingEnabled
{
    if ([self isMemberOfClass:UIViewController.class]
        // || [self isKindOfClass:UINavigationController.class]
        // || [self isKindOfClass:UITabBarController.class]
        // || [self isKindOfClass:UITableViewController.class]
        // || [self isKindOfClass:UICollectionViewController.class]
        // || [self isKindOfClass:UIPageViewController.class]
        )
    {
        return YES;
    }
    return NO;
}
@end
