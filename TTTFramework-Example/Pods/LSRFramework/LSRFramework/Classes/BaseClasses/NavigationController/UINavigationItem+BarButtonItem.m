//
//  UINavigationItem+BarButtonItem.m
//  TTTFramework
//
//  Created by jia on 2017/3/11.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UINavigationItem+BarButtonItem.h"
#import "UINavigationItem+Global.h"
#import "UIBarButtonItem+Extension.h"
#import "UIButton+ImageWithColor.h"
#import "TTTFrameworkScreenParameters.h"
#import <objc/runtime.h>

@implementation UINavigationItem (BarButtonItem)

- (void)setLeftButtonItem:(UIBarButtonItem *)leftButtonItem
{
    objc_setAssociatedObject(self, @selector(leftButtonItem), leftButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)leftButtonItem
{
    return objc_getAssociatedObject(self, @selector(leftButtonItem));
}

- (void)setRightButtonItem:(UIBarButtonItem *)rightButtonItem
{
    objc_setAssociatedObject(self, @selector(rightButtonItem), rightButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)rightButtonItem
{
    return objc_getAssociatedObject(self, @selector(rightButtonItem));
}

- (void)setLeftButtonItemTitle:(NSString *)leftButtonItemTitle
{
    if (!self.leftButtonItem)
    {
        return;
    }
    
    if (self.leftButtonItem.customView && [self.leftButtonItem.customView isKindOfClass:UIButton.class])
    {
        [((UIButton *)self.leftButtonItem.customView) setTitle:leftButtonItemTitle forState:UIControlStateNormal];
    }
    else
    {
        self.leftButtonItem.title = leftButtonItemTitle;
    }
}

- (NSString *)leftButtonItemTitle
{
    if (!self.leftButtonItem)
    {
        return nil;
    }
    
    if (self.leftButtonItem.customView && [self.leftButtonItem.customView isKindOfClass:UIButton.class])
    {
        return [((UIButton *)self.leftButtonItem.customView) titleForState:UIControlStateNormal];
    }
    else
    {
        return self.leftButtonItem.title;
    }
}

- (void)setRightButtonItemTitle:(NSString *)rightButtonItemTitle
{
    if (!self.rightButtonItem)
    {
        return;
    }
    
    if (self.rightButtonItem.customView && [self.rightButtonItem.customView isKindOfClass:UIButton.class])
    {
        [((UIButton *)self.rightButtonItem.customView) setTitle:rightButtonItemTitle forState:UIControlStateNormal];
    }
    else
    {
        self.rightButtonItem.title = rightButtonItemTitle;
    }
}

- (NSString *)rightButtonItemTitle
{
    if (!self.rightButtonItem)
    {
        return nil;
    }
    
    if (self.rightButtonItem.customView && [self.rightButtonItem.customView isKindOfClass:UIButton.class])
    {
        return [((UIButton *)self.rightButtonItem.customView) titleForState:UIControlStateNormal];
    }
    else
    {
        return self.rightButtonItem.title;
    }
}

- (UIButton *)leftButton
{
    if (self.leftButtonItem)
    {
        return self.leftButtonItem.customView;
    }
    return nil;
}

- (UIButton *)rightButton
{
    if (self.rightButtonItem)
    {
        return self.rightButtonItem.customView;
    }
    return nil;
}

- (void)setBackButtonItem:(UIBarButtonItem *)backButtonItem
{
    objc_setAssociatedObject(self, @selector(backButtonItem), backButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)backButtonItem
{
    return objc_getAssociatedObject(self, @selector(backButtonItem));
}

- (void)setCloseButtonItem:(UIBarButtonItem *)closeButtonItem
{
    objc_setAssociatedObject(self, @selector(closeButtonItem), closeButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)closeButtonItem
{
    return objc_getAssociatedObject(self, @selector(closeButtonItem));
}

#pragma mark - Style
- (void)barButtonItemsStyleToFit
{
    UIColor *itemColor = self.barButtonItemColor;
    UIFont *itemFont = self.barButtonItemFont;
    
    for (UIBarButtonItem *barButtonItem in self.barLeftButtonItems)
    {
        if ([barButtonItem isEqual:self.backButtonItem])
        {
            [barButtonItem styleToFitColor:self.backButtonItemColor font:itemFont];
        }
        else if ([barButtonItem isEqual:self.closeButtonItem])
        {
            [barButtonItem styleToFitColor:self.closeButtonItemColor font:itemFont];
        }
        else
        {
            [barButtonItem styleToFitColor:itemColor font:itemFont];
        }
    }
    
    for (UIBarButtonItem *barButtonItem in self.barRightButtonItems)
    {
        [barButtonItem styleToFitColor:itemColor font:itemFont];
    }
}

- (void)backButtonItemStyleToFit
{
    [self.backButtonItem styleToFitColor:self.backButtonItemColor font:self.barButtonItemFont];
}

- (void)closeButtonItemStyleToFit
{
    [self.closeButtonItem styleToFitColor:self.closeButtonItemColor font:self.barButtonItemFont];
}

- (NSArray *)barLeftButtonItems
{
    if (self.leftBarButtonItems)
    {
        return self.leftBarButtonItems;
    }
    else
    {
        if (self.leftBarButtonItem)
        {
            return @[self.leftBarButtonItem];
        }
        else
        {
            return nil;
        }
    }
}

- (NSArray *)barRightButtonItems
{
    if (self.rightBarButtonItems)
    {
        return self.rightBarButtonItems;
    }
    else
    {
        if (self.rightBarButtonItem)
        {
            return @[self.rightBarButtonItem];
        }
        else
        {
            return nil;
        }
    }
}

#pragma mark - Left
- (UIBarButtonItem *)addLeftBarButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)leftItemSelector
{
    return [self addLeftBarButtonItemWithImage:image tintColor:self.barButtonItemColor target:target action:leftItemSelector];
}

- (UIBarButtonItem *)addLeftBarButtonItemWithImage:(UIImage *)image tintColor:(UIColor *)tintColor target:(id)target action:(SEL)leftItemSelector
{
    UIButton *button = nil;
    NSString *selectorString = leftItemSelector ? NSStringFromSelector(leftItemSelector) : nil;
    UIBarButtonItem *item = [self barButtonItemWithImage:image color:tintColor target:target selectorString:selectorString button:&button];
    
    self.leftButtonItem = item;
    
    CGSize imageSize = image.size;
    CGSize buttonSize = button.frame.size;
    CGFloat spaceWidth = [self computeImageButtonItemSideSpacing:imageSize buttonSize:buttonSize forBackButton:NO];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:0];
    space.width = spaceWidth;
    
    [self removeLeftBarButtonItems];
    self.leftBarButtonItems = @[space, item];
    
    return item;
}

- (UIBarButtonItem *)addBackButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)leftItemSelector
{
    self.backButtonItem = [self addFunctionalButtonItemWithImage:image forBack:YES tintColor:self.backButtonItemColor target:target action:leftItemSelector];
    return self.backButtonItem;
}

- (UIBarButtonItem *)addCloseBarButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)leftItemSelector
{
    self.closeButtonItem = [self addFunctionalButtonItemWithImage:image forBack:NO tintColor:self.closeButtonItemColor target:target action:leftItemSelector];
    return self.closeButtonItem;
}

// 返回或关闭按钮的图片
- (UIBarButtonItem *)addFunctionalButtonItemWithImage:(UIImage *)image forBack:(BOOL)forBack tintColor:(UIColor *)tintColor target:(id)target action:(SEL)leftItemSelector
{
    if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3 && SYSTEM_VERSION >= 11.0)
    {
        // 图片内容左对齐
        UIImage *backImage = [self functionalButtonImageWithImage:image size:(forBack ? self.backButtonItemSize : self.closeButtonItemSize)];
        
        UIButton *button = nil;
        NSString *selectorString = leftItemSelector ? NSStringFromSelector(leftItemSelector) : nil;
        UIBarButtonItem *item = [self backButtonItemWithImage:backImage color:tintColor target:target selectorString:selectorString button:&button];
        
        self.leftButtonItem = item;
        
        [self removeLeftBarButtonItems];
        self.leftBarButtonItems = @[item];
        
        return item;
    }
    else
    {
        UIImage *backImage = image;
        
        UIButton *button = nil;
        NSString *selectorString = leftItemSelector ? NSStringFromSelector(leftItemSelector) : nil;
        UIBarButtonItem *item = [self backButtonItemWithImage:backImage color:tintColor target:target selectorString:selectorString button:&button];
        
        self.leftButtonItem = item;
        
        CGSize imageSize = backImage.size;
        CGSize buttonSize = button.frame.size;
        CGFloat spaceWidth = [self computeImageButtonItemSideSpacing:imageSize buttonSize:buttonSize forBackButton:YES];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:0];
        space.width = spaceWidth;
        
        [self removeLeftBarButtonItems];
        self.leftBarButtonItems = @[space, item];
        
        return item;
    }
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:0];
    space.width = self.computeBarButtonItemSideSpacing;
    
    self.leftButtonItem = leftBarButtonItem;
    
    [self removeLeftBarButtonItems];
    self.leftBarButtonItems = @[space, leftBarButtonItem];
}

- (UIBarButtonItem *)addLeftBarButtonItem:(id)item type:(BarButtonItemType)type target:(id)target action:(SEL)leftItemSelector
{
    return [self addBarButtonItems:@[item] types:@[@(type)] target:target actions:@[NSStringFromSelector(leftItemSelector)] atLeft:YES].firstObject;
}

- (NSArray *)addLeftBarButtonItems:(NSArray *)items types:(NSArray *)types target:(id)target actions:(NSArray *)selectorStrings
{
    return [self addBarButtonItems:items types:types target:target actions:selectorStrings atLeft:YES];
}

- (void)removeLeftBarButtonItems
{
    self.leftBarButtonItem = nil;
    self.leftBarButtonItems = nil;
    
    self.hidesBackButton = YES;
}

#pragma mark - Right
- (void)addRightBarButtonItem:(UIBarButtonItem *)rightButtonItem
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:0];
    space.width = self.computeBarButtonItemSideSpacing;
    
    self.rightButtonItem = rightButtonItem;
    
    [self removeRightBarButtonItems];
    self.rightBarButtonItems = @[space, rightButtonItem];
}

- (UIBarButtonItem *)addRightBarButtonItem:(id)item type:(BarButtonItemType)type target:(id)target action:(SEL)rightItemSelector
{
    return [self addBarButtonItems:@[item] types:@[@(type)] target:target actions:@[NSStringFromSelector(rightItemSelector)] atLeft:NO].firstObject;
}

- (NSArray *)addRightBarButtonItems:(NSArray *)items types:(NSArray *)types target:(id)target actions:(NSArray *)selectorStrings
{
    return [self addBarButtonItems:items types:types target:target actions:selectorStrings atLeft:NO];
}

- (void)removeRightBarButtonItems
{
    self.rightBarButtonItems = nil;
    self.rightBarButtonItem = nil;
}

// 减的多(返回值小)，往边上偏；减的少(返回值大)，往中间偏
- (CGFloat)computeTitleButtonItemSideSpacing
{
    CGFloat spacing = self.titleButtonItemSideSpacing;
    
    if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3 && SYSTEM_VERSION >= 11.0)
    {
        // 之前的系统默认留边过宽，传入负数可以调整，ios11之后设负数没有效果了
        return 0.0;
    }
    else if (SYSTEM_VERSION >= 10.0)
    {
        if (SCREEN_WIDTH >= 414)
        {
            // plus 大屏
            return spacing - 20.0; // ok
        }
        else if (SCREEN_WIDTH >= 375)
        {
            // 中屏
            return spacing - 16.0; // ok
        }
        else
        {
            // 小屏
            return spacing - 8.0; // ok
        }
    }
    else if (SYSTEM_VERSION >= 9.0)
    {
        if (SCREEN_WIDTH >= 414)
        {
            // plus 大屏
            return spacing - 12.0; // ok
        }
        else if (SCREEN_WIDTH >= 375)
        {
            // 中屏
            return spacing - 8.0; // ok
        }
        else
        {
            // 小屏
            return spacing - 8.0; // ok
        }
    }
    else
    {
        if (SCREEN_WIDTH >= 414)
        {
            // plus 大屏
            return spacing - 12.0;
        }
        else if (SCREEN_WIDTH >= 375)
        {
            // 中屏
            return spacing - 8.0; // ok
        }
        else
        {
            // 小屏
            return spacing - 8.0;
        }
    }
}

// 减的多(返回值小)，往边上偏；减的少(返回值大)，往中间偏
- (CGFloat)computeBarButtonItemSideSpacing
{
    CGFloat spacing = self.barButtonItemSideSpacing;
    
    if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3 && SYSTEM_VERSION >= 11.0)
    {
        // 之前的系统默认留边过宽，传入负数可以调整，ios11之后设负数没有效果了
        return 0.0;
    }
    else if (SYSTEM_VERSION >= 10.0)
    {
        if (SCREEN_WIDTH >= 414)
        {
            // plus 大屏
            return spacing - 20.0; // ok
        }
        else if (SCREEN_WIDTH >= 375)
        {
            // 中屏
            return spacing - 16.0; // ok
        }
        else
        {
            // 小屏
            return spacing - 16.0; // ok
        }
    }
    else if (SYSTEM_VERSION >= 9.0)
    {
        if (SCREEN_WIDTH >= 414)
        {
            // plus 大屏
            return spacing - 20.0; // ok
        }
        else if (SCREEN_WIDTH >= 375)
        {
            // 中屏
            return spacing - 16.0; // ok
        }
        else
        {
            // 小屏
            return spacing - 16.0; // ok
        }
    }
    else
    {
        if (SCREEN_WIDTH >= 414)
        {
            // plus 大屏
            return spacing - 20.0;
        }
        else if (SCREEN_WIDTH >= 375)
        {
            // 中屏
            return spacing - 16.0; // ok
        }
        else
        {
            // 小屏
            return spacing - 16.0;
        }
    }
}

// 减的多(返回值小)，往边上偏；减的少(返回值大)，往中间偏
- (CGFloat)computeImageButtonItemSideSpacing:(CGSize)imageSize buttonSize:(CGSize)buttonSize forBackButton:(BOOL)forBackButton
{
    CGFloat spacing = forBackButton ? self.backButtonItemSideSpacing : self.imageButtonItemSideSpacing;
    spacing = spacing + (imageSize.width - buttonSize.width)/2;
    
    if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3 && SYSTEM_VERSION >= 11.0)
    {
        // 之前的系统默认留边过宽，传入负数可以调整，ios11之后设负数没有效果了
        return 0.0;
    }
    else if (SYSTEM_VERSION >= 10.0)
    {
        if (SCREEN_WIDTH >= 414)
        {
            // plus 大屏
            return spacing - 20.0; // ok
        }
        else if (SCREEN_WIDTH >= 375)
        {
            // 中屏
            return spacing - 16.0; // ok
        }
        else
        {
            // 小屏
            return spacing - 16.0; // ok
        }
    }
    else if (SYSTEM_VERSION >= 9.0)
    {
        if (SCREEN_WIDTH >= 414)
        {
            // plus 大屏
            return spacing - 20.0; // ok
        }
        else if (SCREEN_WIDTH >= 375)
        {
            // 中屏
            return spacing - 16.0; // ok
        }
        else
        {
            // 小屏
            return spacing - 16.0;
        }
    }
    else
    {
        if (SCREEN_WIDTH >= 414)
        {
            // plus 大屏
            return spacing - 20.0;
        }
        else if (SCREEN_WIDTH >= 375)
        {
            // 中屏
            return spacing - 16.0; // ok
        }
        else
        {
            // 小屏
            return spacing - 16.0;
        }
    }
}

- (CGFloat)computeImageButtonItemSideSpacing:(CGSize)imageSize buttonSize:(CGSize)buttonSize
{
    return [self computeImageButtonItemSideSpacing:imageSize buttonSize:buttonSize forBackButton:NO];
}

#pragma mark - Tools
- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color target:(id)target selectorString:(NSString *)selectorString button:(UIButton **)button
{
    // Global
    // [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateNormal];
    
    SEL selector = selectorString ? NSSelectorFromString(selectorString) : 0;
    
    if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3 && SYSTEM_VERSION >= 11.0)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 0, self.barButtonItemSize.height);
        btn.backgroundColor = [UIColor clearColor];
        
        [btn setTitle:title withColor:color];
        [btn.titleLabel setFont:font];
        
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        *button = btn;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        return item;
    }
    else
    {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title
                                                                 style:UIBarButtonItemStylePlain
                                                                target:target
                                                                action:selector];
        [item styleToFitColor:color font:font];
        
        return item;
    }
}

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)originalImage color:(UIColor *)color target:(id)target selectorString:(NSString *)selectorString button:(UIButton **)button
{
    CGRect frame = CGRectZero;
    UIImage *image = nil;
    
    CGSize barButtonItemSize = self.barButtonItemSize;
    if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3 && SYSTEM_VERSION >= 11.0)
    {
        frame.size = barButtonItemSize;
        image = originalImage;
    }
    else
    {
        frame.size = barButtonItemSize;
        image = [UIImage imageWithImage:originalImage size:frame.size];
    }
    
    SEL selector = selectorString ? NSSelectorFromString(selectorString) : 0;
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    
    [btn setImage:image withColor:color];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    if (button) *button = btn;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}

- (UIBarButtonItem *)backButtonItemWithImage:(UIImage *)originalImage color:(UIColor *)color target:(id)target selectorString:(NSString *)selectorString button:(UIButton **)button
{
    CGRect frame = CGRectZero;
    UIImage *image = nil;
    
    CGSize barButtonItemSize = self.backButtonItemSize;
    if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3 && SYSTEM_VERSION >= 11.0)
    {
        frame.size = CGSizeMake(originalImage.size.width, barButtonItemSize.height);
        image = originalImage;
    }
    else
    {
        frame.size = barButtonItemSize;
        image = [UIImage imageWithImage:originalImage size:frame.size];
    }
    
    SEL selector = selectorString ? NSSelectorFromString(selectorString) : 0;
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    
    [btn setImage:image withColor:color];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    if (button) *button = btn;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}

// 图片内容左对齐
- (UIImage *)functionalButtonImageWithImage:(UIImage *)image size:(CGSize)size
{
    float x = MAX(UINavigationItem.global.backButtonImageOffset.x, 0);
    float y = (size.height - image.size.height) * 0.5 + UINavigationItem.global.backButtonImageOffset.y;
    CGRect imageToRect = CGRectMake(x, y, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
    
    [image drawInRect:imageToRect];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

// when items has only one object, then return the object(type: UIBarButtonItem)
- (NSArray *)addBarButtonItems:(NSArray *)items types:(NSArray *)types target:(id)target actions:(NSArray *)selectorStrings atLeft:(BOOL)atLeft
{
    if (items.count != types.count)
    {
        return nil;
    }
    
    NSMutableArray *returnItems = [[NSMutableArray alloc] init]; // 函数返回值
    
    NSMutableArray *totalItems = [[NSMutableArray alloc] initWithCapacity:items.count + 1];
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:0];
    [totalItems addObject:extraSpace]; // 添加到totalItems最后会加到navigation item上
    
    for (int i = 0; i < types.count; ++i)
    {
        NSNumber *typeNumber = types[i];
        UIButton *button = nil;
        UIBarButtonItem *item = nil;
        NSString *selectorString = nil;
        if (selectorStrings && selectorStrings.count > i && [selectorStrings[i] isKindOfClass:[NSString class]])
        {
            selectorString = selectorStrings[i];
        }
        
        if (BarButtonItemTypeTitle == typeNumber.integerValue)
        {
            NSString *title = items[i];
            if (![title isKindOfClass:NSString.class])
            {
                continue;
            }
            item = [self barButtonItemWithTitle:title font:self.barButtonItemFont color:self.barButtonItemColor target:target selectorString:selectorString button:&button];
            
            if (0 == i)
            {
                extraSpace.width = self.computeTitleButtonItemSideSpacing;
            }
        }
        else if (BarButtonItemTypeImage == typeNumber.integerValue ||
                 BarButtonItemTypeImageName == typeNumber.integerValue)
        {
            UIImage *image;
            if (BarButtonItemTypeImage == typeNumber.integerValue)
            {
                image = items[i];
                if (![image isKindOfClass:UIImage.class])
                {
                    continue;
                }
            }
            else
            {
                NSString *imageName = items[i];
                if (![imageName isKindOfClass:NSString.class])
                {
                    continue;
                }
                image = [UIImage imageNamed:items[i] withTintColor:self.barButtonItemColor];
            }
            item = [self barButtonItemWithImage:image color:self.barButtonItemColor target:target selectorString:selectorString button:&button];
            
            if (0 == i)
            {
                CGSize imageSize = image.size;
                CGSize buttonSize = button.frame.size;
                
                extraSpace.width = [self computeImageButtonItemSideSpacing:imageSize buttonSize:buttonSize];
            }
        }
        else if (BarButtonItemTypeItem == typeNumber.integerValue)
        {
            item = items[i];
            if (![item isKindOfClass:UIBarButtonItem.class])
            {
                continue;
            }
            
            if (selectorString)
            {
                item.action = NSSelectorFromString(selectorString);
            }
            
            button = item.customView;
            
            if (0 == i)
            {
                extraSpace.width = self.computeBarButtonItemSideSpacing;
            }
        }
        else if (BarButtonItemTypeSpace == typeNumber.integerValue)
        {
            NSNumber *spacingNumber = items[i];

            UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:0];
            spaceItem.width = MAX(spacingNumber.floatValue, 8.0); // 系统默认有8dp的空白
            if (SYSTEM_VERSION < 11.0)
            {
                spaceItem.width = MAX(spacingNumber.floatValue/2.0, 6.0); // 系统默认有6dp的空白，11.0以下间距除以2才能得到正确的
            }
            
            item = spaceItem;
        }
        else
        {
            // error !!!
            continue;
        }
        
        [totalItems addObject:item]; // 添加到totalItems最后会加到navigation item上
        [returnItems addObject:item]; // 函数返回值
        
        if (0 == i)
        {
            if (atLeft)
            {
                self.leftButtonItem = item;
            }
            else
            {
                self.rightButtonItem = item;
            }
        }
    }
    
    if (atLeft)
    {
        [self removeLeftBarButtonItems];
        self.leftBarButtonItems = totalItems;
    }
    else
    {
        [self removeRightBarButtonItems];
        self.rightBarButtonItems = totalItems;
    }
    
    return returnItems;
}

@end
