//
//  TabBarController+Theme.m
//  FileBox
//
//  Created by jia on 16/4/21.
//  Copyright © 2016年 OrangeTeam. All rights reserved.
//

#import "TabBarController+Theme.h"

@implementation TabBarController (Theme)

- (void)observeTabBarChanging
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTabBarTheme) name:@"TabBarChanging" object:nil];
}

- (void)refreshTabBarTheme
{
    static int i = 0;
    
    self.tabBar.translucent = (i++ % 2);
    self.tabBar.barTintColor = self.tabBar.translucent ? nil : [UIColor darkGrayColor];
    
    [self reloadTabBarItems]; // 重新加载tab bar items
}

@end
