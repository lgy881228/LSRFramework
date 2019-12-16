//
//  UITableViewController+VisibleArea.m
//  TTTFramework
//
//  Created by jia on 2017/1/11.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UITableViewController+VisibleArea.h"
#import "PureLayout.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

#define contentOffsetKeyPath @"contentOffset"

@implementation UITableViewController (VisibleArea)

#pragma mark - Properties
- (void)setVisibleAreaView:(UIView *)visibleAreaView
{
    objc_setAssociatedObject(self, @selector(visibleAreaView), visibleAreaView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)visibleAreaView
{
    UIView *visibleAreaView = objc_getAssociatedObject(self, @selector(visibleAreaView));
    if (!visibleAreaView)
    {
        visibleAreaView = [UIView new];
        
        [self.view addSubview:visibleAreaView];
        
        [visibleAreaView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
        [visibleAreaView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view];
        [visibleAreaView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
        self.visibleAreaViewVerticalOffsetConstraint = [visibleAreaView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:self.visibleAreaViewVerticalOffset];
        
        [self.view addObserver:self forKeyPath:contentOffsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
        
        self.visibleAreaView = visibleAreaView;
    }
    
    return visibleAreaView;
}

- (void)setVisibleAreaViewVerticalOffsetConstraint:(NSLayoutConstraint *)visibleAreaViewVerticalOffsetConstraint
{
    objc_setAssociatedObject(self, @selector(visibleAreaViewVerticalOffsetConstraint), visibleAreaViewVerticalOffsetConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)visibleAreaViewVerticalOffsetConstraint
{
    return objc_getAssociatedObject(self, @selector(visibleAreaViewVerticalOffsetConstraint));
}

- (void)updateVisibleAreaViewConstraints
{
    self.visibleAreaViewVerticalOffsetConstraint.constant = self.visibleAreaViewVerticalOffset;
}

- (CGFloat)visibleAreaViewVerticalOffset
{
//    CGFloat offset = 0.0f;
//    if (!self.prefersStatusBarHidden)
//    {
//        offset -= CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
//    }
//    
//    if (self.navigationController && !self.navigationController.navigationBar.hidden)
//    {
//        offset -= CGRectGetHeight(self.navigationController.navigationBar.frame);
//    }
//    
//    if (self.tabBarController && !self.tabBarController.tabBar.hidden)
//    {
//        offset -= CGRectGetHeight(self.tabBarController.tabBar.frame);
//    }
    
    return self.visibleAreaFrame.origin.y;
}

- (CGRect)visibleAreaFrame
{
    CGRect frame = self.view.bounds;
    if ([self.view isKindOfClass:UITableView.class])
    {
        UITableView *tableView = (UITableView *)self.view;
        frame.origin.y = tableView.contentOffset.y;
    }
    
    return frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:contentOffsetKeyPath])
    {
        return;
    }
    
    if (![self.view isKindOfClass:UITableView.class])
    {
        return;
    }
    
//    UITableView *tableView = (UITableView *)self.view;
//    
//    CGRect frame = self.view.frame;
//    CGRect loading = self.loadingSuperView.frame;
//    CGPoint offset = tableView.contentOffset;
//    NSLog(@"height: %f, loading: %f offset: %f", CGRectGetHeight(frame), CGRectGetHeight(loading), offset.y);
    
    [self updateVisibleAreaViewConstraints];
}

#pragma mark - Swizzle
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:NSSelectorFromString(@"dealloc") withSelector:@selector(uitableviewcontroller_dealloc)];
    });
}

- (void)uitableviewcontroller_dealloc
{
    if ([self.view isKindOfClass:UITableView.class] && objc_getAssociatedObject(self, @selector(visibleAreaView)))
    {
        [self.view removeObserver:self forKeyPath:contentOffsetKeyPath];
    }
    
    [self uitableviewcontroller_dealloc];
}

#pragma mark - Scroll Enabled
- (UIView *)loadingSuperView
{
    return self.visibleAreaView;
}

- (void)doExtraWhenShowLoading
{
    self.tableViewScrollEnabled = NO;
}

- (void)doExtraWhenHideLoading
{
    self.tableViewScrollEnabled = YES;
}

- (void)setTableViewScrollEnabled:(BOOL)enabled
{
    self.tableView.scrollEnabled = enabled;
    
    self.visibleAreaView.hidden = enabled;
    
    if (!enabled)
    {
        [self.view bringSubviewToFront:self.visibleAreaView];
    }
}

@end
