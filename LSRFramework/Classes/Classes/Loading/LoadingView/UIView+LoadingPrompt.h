//
//  UIView+LoadingPrompt.h
//  ennew
//
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <UIKit/UIKit.h>

// 之所以不把loading放在UIView上，是因为view的subview涉及反复添加和移除的执行，而一个界面的UIView太多了，影响效率。
// 目前的做法是把loading放在vc里，因为vc是唯一的。
// 另一个原因是，升级ios11之后，右滑返回手势中途放弃，因为给UIView动态绑定了数据，移除数据工作带来了意外的返回按钮丢失的问题。
#define UIViewLoadingPromptEnabled  0

#if UIViewLoadingPromptEnabled
@protocol UIViewLoadingPromptProtocol <NSObject>

@property (nonatomic, readonly) UIView *subviewOfLoadingView;
@property (nonatomic, readonly) UIView *subviewOfPromptView;

@end

@interface UIView (LoadingPrompt) <UIViewLoadingPromptProtocol>

- (void)showLoadingViewWithText:(NSString *)text;

- (void)hideLoadingView;

- (void)showPromptWithMessage:(NSString *)message;

@end
#endif
