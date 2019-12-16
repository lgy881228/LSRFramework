//
//  UIViewController+Loading_Prompt.h
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, LoadingPromptTheme)
{
    LoadingPromptThemePure = 0,
    LoadingPromptThemeLight,
    LoadingPromptThemeDark,
};

@class MBProgressHUD;

@protocol UIViewControllerLoadingPromptProtocol <NSObject>

@property (nonatomic, readonly) MBProgressHUD * _Nullable HUD;

@property (nonatomic, assign, class) LoadingPromptTheme loadingPromptTheme;

@property (nonatomic, assign, class) CGFloat loadingIndicatorTransformScale;

@property (nonatomic, assign, class) CGFloat loadingPromptMargin;
@property (nonatomic, assign, class) CGFloat loadingPromptCornerRadius;

@property (nonatomic, strong, class) UIFont * _Nullable loadingPromptTitleFont;

// defaults to 1.5s;
@property (nonatomic, assign, class) CGFloat promptTimeInterval;

@property (nonatomic, assign) LoadingPromptTheme preferredLoadingPromptTheme;
@property (nonatomic, assign) CGFloat preferredPromptTimeInterval;

@property (nonatomic, readonly) NSTimer * _Nullable hideDelayTimer;

@end

@interface UIViewController (Loading_Prompt) <UIViewControllerLoadingPromptProtocol>

#pragma mark - Loading
- (void)showLoading;
- (void)showLoading:(NSString * __nullable)loadingText;
- (void)showLoadingInView:(UIView * __nonnull)view;
- (void)showLoading:(NSString * __nullable)loadingText inView:(UIView * __nonnull)view;

- (void)hideLoading;

- (BOOL)isShowingLoading;

#pragma mark - Prompt
- (void)promptMessage:(NSString * _Nullable)message;
- (void)promptMessage:(NSString * _Nullable)message inView:(UIView * __nonnull)view;

@end
