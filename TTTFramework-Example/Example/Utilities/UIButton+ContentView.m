//
//  UIButton+ContentView.m
//  ECEJ
//
//  Created by jia on 16/7/4.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "UIButton+ContentView.h"
#import <objc/runtime.h>

@implementation UIButton (ContentView)

#pragma mark - Getter & Setter
- (ContentLayout)contentLayout
{
    NSNumber *contentLayout = objc_getAssociatedObject(self, @selector(contentLayout));
    if (contentLayout)
    {
        return contentLayout.unsignedIntegerValue;
    }
    return ContentLayoutHorizontalImageTitle; // default
}

- (void)setContentLayout:(ContentLayout)contentLayout
{
    objc_setAssociatedObject(self, @selector(contentLayout), @(contentLayout), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self layoutContentViews];
}

- (CGFloat)imageTitleSpacing
{
    NSNumber *imageTitleSpacing = objc_getAssociatedObject(self, @selector(imageTitleSpacing));
    if (imageTitleSpacing)
    {
        return imageTitleSpacing.doubleValue;
    }
    return 0.0f;
}

- (void)setImageTitleSpacing:(CGFloat)imageTitleSpacing
{
    objc_setAssociatedObject(self, @selector(imageTitleSpacing), @(imageTitleSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self layoutContentViews];
}

// - (CGSize)imageSize

#pragma mark - Functions
- (void)layoutContentViews
{
    switch (self.contentLayout)
    {
        case ContentLayoutCentral:
        {
            // TODO:
            break;
        }
        case ContentLayoutHorizontalTitleImage:
        {
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (self.frame.size.width - self.titleLabel.intrinsicContentSize.width)/2);
            
            CGFloat imageTitleSpacing = self.imageTitleSpacing;
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (self.frame.size.width + self.titleLabel.intrinsicContentSize.width)/2 + imageTitleSpacing, 0, 0);
            
            break;
        }
        case ContentLayoutVerticalImageTitle:
        {
            self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height - self.imageTitleSpacing, 0, 0, -self.titleLabel.intrinsicContentSize.width);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height - self.imageTitleSpacing, 0);
            break;
        }
        case ContentLayoutVerticalTitleImage:
        {
            // TODO:
            break;
        }
        default: // to: ContentLayoutHorizontalImageTitle
        {
            // TODO:
            break;
        }
    }
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
    
    [self layoutContentViews];
}

- (void)setTitleFont:(UIFont *)font
{
    [self.titleLabel setFont:font];
    
    [self layoutContentViews];
}

- (void)setTitleColor:(UIColor *)color
{
    [self setTitleNMColor:color HLColor:color SELColor:color];
}

- (void)setImage:(UIImage *)image
{
    [self setNormalImage:image highlightedImage:image selectedImage:image];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [self setBackgroundNormalImage:image highlightedImage:image selectedImage:image];
}

- (void)setNormalImage:(UIImage *)nmImage highlightedImage:(UIImage *)hlImage selectedImage:(UIImage *)selImage
{
    [self setImage:nmImage forState:UIControlStateNormal];
    [self setImage:hlImage forState:UIControlStateHighlighted];
    [self setImage:selImage forState:UIControlStateSelected];
}

- (void)setBackgroundNormalImage:(UIImage *)nmImage highlightedImage:(UIImage *)hlImage selectedImage:(UIImage *)selImage
{
    [self setBackgroundImage:nmImage forState:UIControlStateNormal];
    [self setBackgroundImage:hlImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:selImage forState:UIControlStateSelected];
}

- (void)setTitleNMColor:(UIColor *)nmColor HLColor:(UIColor *)hlColor SELColor:(UIColor *)selColor
{
    [self setTitleColor:nmColor forState:UIControlStateNormal];
    [self setTitleColor:hlColor forState:UIControlStateHighlighted];
    [self setTitleColor:selColor forState:UIControlStateSelected];
}

@end
