//
//  UIButton+ContentView.h
//  ECEJ
//
//  Created by jia on 16/7/4.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ContentLayout)
{
    ContentLayoutHorizontalImageTitle = 0,
    ContentLayoutHorizontalTitleImage,
    ContentLayoutVerticalImageTitle,
    ContentLayoutVerticalTitleImage,
    ContentLayoutCentral
};

@interface UIButton (ContentView)

@property (nonatomic, readwrite) ContentLayout contentLayout;
@property (nonatomic, readwrite) CGFloat imageTitleSpacing;
// @property (nonatomic, readwrite) CGSize imageSize;

- (void)setTitle:(NSString *)title;

- (void)setTitleFont:(UIFont *)font;

- (void)setTitleColor:(UIColor *)color;

- (void)setImage:(UIImage *)image;

- (void)setBackgroundImage:(UIImage *)image;

@end
