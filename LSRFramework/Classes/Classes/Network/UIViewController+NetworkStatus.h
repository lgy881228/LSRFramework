//
//  UIViewController+NetworkStatus.h
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppNetworkMonitoring.h"
#import "TTTFrameworkNetworkStatusDefines.h"

@protocol NetworkMonitoringProtocol <NSObject>

- (void)networkStatusChanged:(NSNotification *)notification;

@end

@interface UIViewController (NetworkStatus) <NetworkMonitoringProtocol>

/* 添加网络监控
 网络变化后会回调NetworkMonitoringProtocol代理中的方法
 - (void)networkStatusChanged:(NSNotification *)notification
 当网络切换成非wifi状态时，会自动弹出弱提示信息
 子类可以重写以上函数，如想保留上述功能，请在函数顶端加入
 [super networkStatusChanged:notification];
 */
- (void)addNetworkMonitoring;

// 移除网络监控
- (void)removeNetworkMonitoring;

- (BOOL)isNoNetwork;

- (NetworkStatus)currentNetworkStatus;

@end
