//
//  UIView+LoadingPrompt.m
//  ennew
//
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "UIView+LoadingPrompt.h"

#if UIViewLoadingPromptEnabled
#import <objc/runtime.h>
#import "LoadingView.h"
#import "MBProgressHUD+Extension.h"
#import "UIColor+Extension.h"
#import "NSObject+Swizzle.h"

#define kLoadingUsingHUD 1

@implementation UIView (LoadingPrompt)

#pragma mark - Properties
- (void)setSubviewOfLoadingView:(UIView *)subviewOfLoadingView
{
    objc_setAssociatedObject(self, @selector(subviewOfLoadingView), subviewOfLoadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)subviewOfLoadingView
{
    return objc_getAssociatedObject(self, @selector(subviewOfLoadingView));
}

- (void)setSubviewOfPromptView:(UIView *)subviewOfPromptView
{
    objc_setAssociatedObject(self, @selector(subviewOfPromptView), subviewOfPromptView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)subviewOfPromptView
{
    return objc_getAssociatedObject(self, @selector(subviewOfPromptView));
}

#pragma mark - Swizzle
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // [self swizzleInstanceSelector:NSSelectorFromString(@"removeFromSuperview") withSelector:@selector(uiview_removeFromSuperview)];
        [self swizzleInstanceSelector:NSSelectorFromString(@"willRemoveSubview:") withSelector:@selector(uiview_willRemoveSubview:)];
    });
}

//- (void)uiview_removeFromSuperview
//{
//    if (self.subviewOfLoadingView)
//    {
//        if (self.subviewOfLoadingView.superview)
//        {
//            [self.subviewOfLoadingView removeFromSuperview];
//        }
//        self.subviewOfLoadingView = nil;
//    }
//
//    if (self.subviewOfPromptView)
//    {
//        if (self.subviewOfPromptView.superview)
//        {
//            [self.subviewOfPromptView removeFromSuperview];
//        }
//        self.subviewOfPromptView = nil;
//    }
//
//    [self uiview_removeFromSuperview];
//}

/*
 - (void)didAddSubview:(UIView *)subview;
 - (void)willRemoveSubview:(UIView *)subview;
 这两个是需要有子视图才能执行，暂时不做讨论。
 
只会执行一次的方法有removeFromSuperview、dealloc两个方法(layoutSubviews在子视图布局变动时会多次调用)。
 
 willRemoveSubview是在dealloc后面执行的，通过断点我们发现确实是最后执行的。而且如果有多个子视图，willRemoveSubview会循环执行，直到移除所有子视图。
 
 - (void)willMoveToSuperview:(nullable UIView *)newSuperview;
 - (void)willMoveToWindow:(nullable UIWindow *)newWindow;
 这俩个方法可以根据参数是否为nil判断是创建操作还是销毁操作，nil则为销毁，反之，则为创建；
 
 - (void)didMoveToSuperview;
 - (void)didMoveToWindow;
有视图(Superview或者Window)的时候代表该View在创建过程中,当为nil的时候,为移除和销毁的时候。
 
 */
- (void)uiview_willRemoveSubview:(UIView *)subview
{
    if ([subview isEqual:self.subviewOfLoadingView])
    {
        self.subviewOfLoadingView = nil;
    }
    else if ([subview isEqual:self.subviewOfPromptView])
    {
        self.subviewOfPromptView = nil;
    }
    else
    {
        // do nothing
    }
    
    [self uiview_willRemoveSubview:subview];
}

#pragma mark - Tools
- (void)showLoadingViewWithText:(NSString *)text
{
    if (!self.subviewOfLoadingView)
    {
#if kLoadingUsingHUD
        MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self];
        progressHUD.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
        self.subviewOfLoadingView = progressHUD;
#else
        self.subviewOfLoadingView = [[LoadingView alloc] initWithSize:self.bounds.size];
#endif
    }
    
#if kLoadingUsingHUD
    MBProgressHUD *hud = (MBProgressHUD *)self.subviewOfLoadingView;
    hud.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
    [self addSubview:[self customHUD:hud text:text mode:MBProgressHUDModeIndeterminate]];
    
    [hud showAnimated:YES];
#else 
    [(LoadingView *)self.subviewOfLoadingView showLoadingText:text inView:self];
#endif
}

- (void)hideLoadingView
{
    if (self.subviewOfLoadingView)
    {
#if kLoadingUsingHUD
        [(MBProgressHUD *)self.subviewOfLoadingView removeFromSuperview];
#else
        [(LoadingView *)self.subviewOfLoadingView hide];
#endif
        // 并不需要手动设置为空，loading removeFromSuperview，会执行上面的 uiview_willRemoveSubview方法来将绑定数据置为空。
        // 另外，如果loading没有手动消除，view 会在dealloc执行之后，执行自己的uiview_willRemoveSubview方法，来将添加到自身的view移除，然后还是走上面一行执行的逻辑。
        // self.subviewOfLoadingView = nil;
    }
}

- (void)showPromptWithMessage:(NSString *)message
{
    if (!self.subviewOfPromptView)
    {
        MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self];
        progressHUD.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
        self.subviewOfPromptView = progressHUD;
    }
    
    MBProgressHUD *hud = (MBProgressHUD *)self.subviewOfPromptView;
    [self addSubview:[self customHUD:hud text:message mode:MBProgressHUDModeText]];
    
    [hud showAnimated:YES];
}

- (MBProgressHUD *)customHUD:(MBProgressHUD *)hud text:(NSString *)text mode:(MBProgressHUDMode)mode
{
//    hud.labelText = text;
    hud.detailsLabel.text = text;
    hud.mode = mode;
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.label.textColor = [UIColor whiteColor];
    
#if kCustomMBProgressHUD
    hud.margin = 15.0f;
    hud.cornerRadius = 8.0f;
    hud.opacity = 0.8f;
#endif
    
    return hud;
}

@end
#endif
