//
//  UITableViewController+VisibleArea.h
//  TTTFramework
//
//  Created by jia on 2017/1/11.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableViewControllerVisibleAreaProtocol <NSObject>

@property (nonatomic, readonly) UIView *visibleAreaView;
@property (nonatomic, readonly) NSLayoutConstraint *visibleAreaViewVerticalOffsetConstraint;

@end

@interface UITableViewController (VisibleArea) <UITableViewControllerVisibleAreaProtocol>

- (void)updateVisibleAreaViewConstraints;

@end
