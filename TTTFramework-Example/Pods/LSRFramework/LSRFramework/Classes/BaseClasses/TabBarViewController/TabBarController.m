//
//  TabBarController.m
//  TTTFramework
//
//  Created by jia on 16/4/21.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "TabBarController.h"
#import "UIViewController+Customized.h"
#import "UIImage+Extension.h"
#import "UIDevice+Orientation.h"
#import "UIColor+Extension.h"

@interface TabBarController ()
@end

@implementation TabBarController

- (instancetype)init
{
    if (self = [super init])
    {
        self.customizedEnabled = YES;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.tabBarItemTitleOffset = UIOffsetZero;
    
    [self setTabBarBGColor];
    
    // [self setupNotificationObserver];
}

#pragma mark - Setup Methods
- (void)setTabBarBGColor
{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f)
    {
        UIImage *buttonImage = [UIImage imageWithColor:RGBCOLOR(248, 248, 248) size:CGSizeMake(1, CGRectGetHeight(self.tabBar.bounds))];
        
        UIImageView *imgv = [[UIImageView alloc] initWithImage:buttonImage];
        imgv.frame = CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
        imgv.contentMode = UIViewContentModeScaleToFill;
        [[self tabBar] insertSubview:imgv atIndex:1];
        
        // CGSize selectionSize = self.tabBar.selectionIndicatorImage.size;
        
        // 用与背景一样的颜色 把选中的矩形指示图形隐藏
        [self.tabBar setSelectionIndicatorImage:buttonImage];
    }
}

#pragma mark - Notification
- (void)setupNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applicationDidBecomeActive
{
    
}

- (void)applicationWillResignActive
{
    [UIDevice setOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate
{
    if (self.selectedViewController)
    {
        return [self.selectedViewController shouldAutorotate];
    }
    return self.autorotateEnabled;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.selectedViewController)
    {
        return [self.selectedViewController supportedInterfaceOrientations];
    }
    else
    {
        if ([self shouldAutorotate])
        {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }
        else
        {
            return UIInterfaceOrientationMaskPortrait;
        }
    }
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    if (self.selectedViewController)
//    {
//        return [self.selectedViewController preferredInterfaceOrientationForPresentation];
//    }
//    return UIInterfaceOrientationPortrait;
//}

#pragma mark - Member Methods
- (void)loadChildViewControllers
{
    NSUInteger countViewControllers = self.countViewControllers;
    if (countViewControllers <= 0)
    {
        return;
    }
    
    if (self.tabBarItemImageSelectedColor) {
        self.tabBar.tintColor = self.tabBarItemImageSelectedColor;
    }
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:countViewControllers];
    
    for (NSInteger i = 0; i < countViewControllers; ++i)
    {
        UIViewController *vc = self.contentViewControllers[i];
        vc.tabBarItem = [self makeTabBarItemWithIndex:i];
        
        UINavigationController *nc = nil;
        if (self.navigationControllerConstructor)
        {
            self.navigationControllerConstructor(&nc, vc);
        }
        else
        {
            nc = [[UINavigationController alloc] initWithRootViewController:vc];
        }
        
        [viewControllers addObject:nc];
    }
    
    self.viewControllers = viewControllers;
}

- (void)reloadTabBarItems
{
    if (self.tabBarItemImageSelectedColor) {
        self.tabBar.tintColor = self.tabBarItemImageSelectedColor;
    }
    
    for (NSUInteger index = 0; index < self.viewControllers.count; ++index)
    {
        UIViewController *vc = self.viewControllers[index];
        
        [self customizeTabBarItem:vc.tabBarItem atIndex:index];
    }
}

- (NSUInteger)countViewControllers
{
    NSUInteger countImages = self.tabBarItemImages.count;
    NSUInteger countTitles = self.tabBarItemTitles.count;
    NSUInteger countViewControllers = self.contentViewControllers.count;
    
    return (countViewControllers <= MIN(countImages, countTitles)) ? countViewControllers : 0;
}

- (UITabBarItem *)makeTabBarItemWithIndex:(NSInteger)index
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:self.tabBarItemTitles[index] image:nil selectedImage:nil];
    [item setTag:index];
    [item setTitlePositionAdjustment:self.tabBarItemTitleOffset];
    
    [self customizeTabBarItem:item atIndex:index];
    
    return item;
}

- (void)customizeTabBarItem:(UITabBarItem *)item atIndex:(NSUInteger)index
{
    UIImage *image = self.tabBarItemImages[index];
    UIImage *selectedImage = self.tabBarItemSelectedImages.count > index ? self.tabBarItemSelectedImages[index] : image;
    
    if (self.tabBarItemImageNormalColor) {
        item.image = [[image imageWithCustomTintColor:self.tabBarItemImageNormalColor] originalImage];
    } else {
        item.image = image.originalImage;
    }
    
    if (self.tabBarItemImageSelectedColor) {
        item.selectedImage = [[selectedImage imageWithCustomTintColor:self.tabBarItemImageSelectedColor] originalImage];
    } else {
        item.selectedImage = selectedImage.originalImage;
    }
    
    // 不指定颜色 系统会自动设置title颜色，但未选中的title颜色比图片浅 选中的title颜色比图片深
        // 注意修改字体只能修改正常的字体 选中的字体会保持和正常时的一致 无法单独设置
        NSDictionary *normalTitleAttributes = nil;
        NSDictionary *selectedTitleAttributes = nil;
        
        if (self.tabBarItemTitleNormalColor && self.tabBarItemTitleFont) {
            normalTitleAttributes = @{NSForegroundColorAttributeName : self.tabBarItemTitleNormalColor,
                                      NSFontAttributeName : self.tabBarItemTitleFont};
        } else if (self.tabBarItemTitleNormalColor) {
            normalTitleAttributes = @{NSForegroundColorAttributeName : self.tabBarItemTitleNormalColor};
        } else if (self.tabBarItemTitleFont) {
            normalTitleAttributes = @{NSFontAttributeName : self.tabBarItemTitleFont};
        } else {
            // do nothing
        }
        
        if (self.tabBarItemTitleSelectedColor && self.tabBarItemTitleFont) {
            selectedTitleAttributes = @{NSForegroundColorAttributeName : self.tabBarItemTitleSelectedColor,
                                        NSFontAttributeName : self.tabBarItemTitleFont};
        } else if (self.tabBarItemTitleSelectedColor) {
            selectedTitleAttributes = @{NSForegroundColorAttributeName : self.tabBarItemTitleSelectedColor};
        } else if (self.tabBarItemTitleFont) {
            selectedTitleAttributes = @{NSFontAttributeName : self.tabBarItemTitleFont};
        } else {
            // do nothing
        }
        
        if (normalTitleAttributes) {
            [item setTitleTextAttributes:normalTitleAttributes forState:UIControlStateNormal];
        }
        
        if (selectedTitleAttributes) {
            [item setTitleTextAttributes:selectedTitleAttributes forState:UIControlStateSelected];
        }
    
    if (@available(iOS 13.0, *))
    {
        self.tabBar.tintColor = self.tabBarItemTitleSelectedColor;
        self.tabBar.unselectedItemTintColor = self.tabBarItemTitleNormalColor;
        
    } else
    {
      // do nothing
    }
    
    
}

@end

