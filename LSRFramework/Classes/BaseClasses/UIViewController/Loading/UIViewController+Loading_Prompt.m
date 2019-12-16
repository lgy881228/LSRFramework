//
//  UIViewController+Loading_Prompt.m
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UIViewController+Loading_Prompt.h"
#import "UIViewController+Global.h"
#import "UIViewController+LoadingSuperView.h"
#import <objc/runtime.h>
#import "MBProgressHUD+Extension.h"

typedef NS_ENUM (NSInteger, MBProgressHUDLook)
{
    MBProgressHUDLookLoading = 0, // default
    MBProgressHUDLookPrompt = 1,
};

@implementation UIViewController (Loading_Prompt)

+ (void)setLoadingPromptTheme:(LoadingPromptTheme)loadingPromptTheme
{
    objc_setAssociatedObject(self.global, @selector(loadingPromptTheme), @(loadingPromptTheme), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (LoadingPromptTheme)loadingPromptTheme
{
    NSNumber *loadingPromptTheme = objc_getAssociatedObject(self.global, @selector(loadingPromptTheme));
    if (loadingPromptTheme)
    {
        return loadingPromptTheme.integerValue;
    }
    return LoadingPromptThemeLight;
}

+ (void)setLoadingIndicatorTransformScale:(CGFloat)loadingIndicatorTransformScale
{
    objc_setAssociatedObject(self.global, @selector(loadingIndicatorTransformScale), @(loadingIndicatorTransformScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)loadingIndicatorTransformScale
{
    NSNumber *loadingIndicatorTransformScale = objc_getAssociatedObject(self.global, @selector(loadingIndicatorTransformScale));
    if (loadingIndicatorTransformScale)
    {
        return loadingIndicatorTransformScale.floatValue;
    }
    return 1.0;
}


+ (void)setPromptTimeInterval:(CGFloat)promptTimeInterval
{
    objc_setAssociatedObject(self.global, @selector(promptTimeInterval), @(promptTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)setLoadingPromptTitleFont:(UIFont *)loadingPromptTitleFont
{
    objc_setAssociatedObject(self.global, @selector(loadingPromptTitleFont), loadingPromptTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIFont *)loadingPromptTitleFont
{
    UIFont *loadingPromptTitleFont = objc_getAssociatedObject(self.global, @selector(loadingPromptTitleFont));
    if (loadingPromptTitleFont)
    {
        return loadingPromptTitleFont;
    }
    return [UIFont boldSystemFontOfSize:14.0];
}

+ (void)setLoadingPromptMargin:(CGFloat)loadingPromptMargin
{
    objc_setAssociatedObject(self.global, @selector(loadingPromptMargin), @(loadingPromptMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)loadingPromptMargin
{
    NSNumber *loadingPromptMargin = objc_getAssociatedObject(self.global, @selector(loadingPromptMargin));
    if (loadingPromptMargin)
    {
        return loadingPromptMargin.floatValue;
    }
    return 20.0;
}

+ (void)setLoadingPromptCornerRadius:(CGFloat)loadingPromptCornerRadius
{
    objc_setAssociatedObject(self.global, @selector(loadingPromptCornerRadius), @(loadingPromptCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)loadingPromptCornerRadius
{
    NSNumber *loadingPromptCornerRadius = objc_getAssociatedObject(self.global, @selector(loadingPromptCornerRadius));
    if (loadingPromptCornerRadius)
    {
        return loadingPromptCornerRadius.floatValue;
    }
    return 6.0;
}

+ (CGFloat)promptTimeInterval
{
    NSNumber *promptTimeInterval = objc_getAssociatedObject(self.global, @selector(promptTimeInterval));
    if (promptTimeInterval)
    {
        return promptTimeInterval.floatValue;
    }
    return 1.5;
}

- (void)setPreferredLoadingPromptTheme:(LoadingPromptTheme)preferredLoadingPromptTheme
{
    objc_setAssociatedObject(self, @selector(preferredLoadingPromptTheme), @(preferredLoadingPromptTheme), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LoadingPromptTheme)preferredLoadingPromptTheme
{
    NSNumber *preferredLoadingPromptTheme = objc_getAssociatedObject(self, @selector(preferredLoadingPromptTheme));
    if (preferredLoadingPromptTheme)
    {
        return preferredLoadingPromptTheme.integerValue;
    }
    return UIViewController.global.loadingPromptTheme;
}

- (void)setPreferredPromptTimeInterval:(CGFloat)preferredPromptTimeInterval
{
    objc_setAssociatedObject(self, @selector(preferredPromptTimeInterval), @(preferredPromptTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)preferredPromptTimeInterval
{
    NSNumber *preferredPromptTimeInterval = objc_getAssociatedObject(self, @selector(preferredPromptTimeInterval));
    if (preferredPromptTimeInterval)
    {
        return preferredPromptTimeInterval.floatValue;
    }
    return UIViewController.global.promptTimeInterval;
}

- (void)setHideDelayTimer:(NSTimer *)hideDelayTimer
{
    if (self.hideDelayTimer)
    {
        [self.hideDelayTimer invalidate];
        objc_setAssociatedObject(self, @selector(hideDelayTimer), hideDelayTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(self, @selector(hideDelayTimer), hideDelayTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)hideDelayTimer
{
    return objc_getAssociatedObject(self, @selector(hideDelayTimer));
}

#pragma mark - Outter Methods
- (void)showLoading
{
    [self showLoading:nil inView:self.loadingSuperView];
}

- (void)showLoading:(NSString *)loadingText
{
    [self showLoading:loadingText inView:self.loadingSuperView];
}

- (void)showLoadingInView:(UIView *)view
{
    [self showLoading:nil inView:view];
}

- (void)showLoading:(NSString *)loadingText inView:(UIView *)view
{
    if (NSThread.currentThread.isMainThread)
    {
        [self showLoadingWithText:loadingText inView:view];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showLoadingWithText:loadingText inView:view];
        });
    }
}

- (void)hideLoading
{
    if (NSThread.currentThread.isMainThread)
    {
        [self hideLoadingView];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingView];
        });
    }
}

- (BOOL)isShowingLoading
{
    return self.HUD ? YES : NO;
}

- (void)promptMessage:(NSString *)message
{
    if (!message || ![message isKindOfClass:NSString.class] || [message isEqualToString:@""])
    {
        return;
    }
    
    [self promptMessage:message inView:self.loadingSuperView];
}

- (void)promptMessage:(NSString *)message inView:(UIView *)view
{
    if (NSThread.currentThread.isMainThread)
    {
        [self showPromptWithText:message inView:view];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showPromptWithText:message inView:view];
        });
    }
}

#pragma mark - Inner Methods
const char HUDKey;
- (void)setHUD:(MBProgressHUD *)hud
{
    if (self.HUD)
    {
        [self.HUD hideAnimated:YES];
        objc_setAssociatedObject(self, &HUDKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(self, &HUDKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, &HUDKey);
}

- (void)showLoadingWithText:(NSString *)text inView:(UIView *)view
{
    [self doExtraWhenShowLoading];
    
    self.hideDelayTimer = nil;
    [self showLoadingViewWithText:text inView:view autoHidden:NO];
}

- (void)showPromptWithText:(NSString *)message inView:(UIView *)view
{
    [self doExtraWhenShowLoading];
    
    [self showLoadingViewWithText:message inView:view autoHidden:YES];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.preferredPromptTimeInterval target:self selector:@selector(handleHideTimer:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.hideDelayTimer = timer;
}

- (void)showLoadingViewWithText:(NSString *)text inView:(UIView *)inView autoHidden:(BOOL)autoHidden
{
    MBProgressHUD *HUD = self.HUD;
    if (!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:inView animated:NO];
        HUD.detailsLabel.font = self.class.loadingPromptTitleFont;
        HUD.bezelView.layer.cornerRadius = self.class.loadingPromptCornerRadius;
        HUD.margin = self.class.loadingPromptMargin;
        self.HUD = HUD;
    }
    
    HUD.mode = autoHidden ? MBProgressHUDModeText : MBProgressHUDModeIndeterminate;
    [HUD setMBProgressHUDLook:(MBProgressHUDTheme)self.preferredLoadingPromptTheme];
    [HUD setActivityIndicatorTransformScale:self.class.loadingIndicatorTransformScale];
    [HUD showAnimated:YES];
    
    HUD.detailsLabel.text = (text && text.length > 0) ? text : nil;
    // HUD.label.font = [UIFont systemFontOfSize:14];
}

- (void)handleHideTimer:(NSTimer *)timer
{
    self.hideDelayTimer = nil;
    
    [self hideLoadingView];
}

- (void)hideLoadingView
{
    [self doExtraWhenHideLoading];
    
    if (self.hideDelayTimer.isValid)
    {
        [self.hideDelayTimer invalidate];
    }
    
    if (self.hideDelayTimer)
    {
        self.hideDelayTimer = nil;
    }
    
    if (self.HUD)
    {
        [self.HUD hideAnimated:YES];
        self.HUD = nil;
    }
}

@end
