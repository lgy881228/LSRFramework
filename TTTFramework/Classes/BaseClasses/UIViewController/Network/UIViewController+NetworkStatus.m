//
//  UIViewController+NetworkStatus.m
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UIViewController+NetworkStatus.h"
#import "UIViewController+Loading_Prompt.h"
#import "UIViewController+.h"

#define kIsUsing3GWLAN      @"正在使用3G网络"
#define kThereIsNoNetwork   @"网络不可用"
// #define kNetworkIsAvailable @"正在使用WIFI"

static NetworkStatus initNetworkStatus;

@implementation UIViewController (NetworkStatus)

// 添加网络监控
- (void)addNetworkMonitoring
{
    [AppNetworkMonitoring sharedInstance];
    
    //网络状态变化监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kNotifyNetworkStatusChanged object:nil];
}

// 移除网络监控
- (void)removeNetworkMonitoring
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyNetworkStatusChanged object:nil];
}

- (BOOL)isNoNetwork
{
    return (NotReachable == [AppNetworkMonitoring sharedInstance].networkStatus);
}

- (NetworkStatus)currentNetworkStatus
{
    return [AppNetworkMonitoring sharedInstance].networkStatus;
}

- (void)resetNetworkStatus
{
    initNetworkStatus = [AppNetworkMonitoring sharedInstance].networkStatus;
}

- (void)networkStatusChanged:(NSNotification *)notification
{
    @synchronized(self)
    {
        AppNetworkMonitoring *monitor = [notification object];
        if (![monitor isKindOfClass:[AppNetworkMonitoring class]])
        {
            return;
        }
        
        NetworkStatus status = monitor.networkStatus;
        
        if (NotReachable == status)
        {
            if (self.isViewActive)
            {
                [self promptMessage:kThereIsNoNetwork];
            }
        }
        else
        {
            if (ReachableViaWWAN == status)
            {
                if (self.isViewActive)
                {
                    [self promptMessage:kIsUsing3GWLAN];
                }
            }
            else
            {
                // do nothing
            }
        }
    }
}

@end

