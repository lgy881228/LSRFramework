//
//  UINavigationItem+BarButtonItem.h
//  TTTFramework
//
//  Created by jia on 2017/3/11.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UINavigationItem+Customized.h"
#import "UIImage+Extension.h"
#import "UIColor+Extension.h"

typedef NS_ENUM(NSInteger, BarButtonItemType)
{
    BarButtonItemTypeSpace = -1,
    BarButtonItemTypeImage = 0,
    BarButtonItemTypeImageName,
    BarButtonItemTypeTitle,
    BarButtonItemTypeItem,
};

@protocol UINavigationItemBarButtonItemProtocol <NSObject>

@property (nonatomic, strong) UIBarButtonItem *leftButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;

// 如果是文字样式的item，可以获得title
@property (nonatomic, strong) NSString *leftButtonItemTitle;
@property (nonatomic, strong) NSString *rightButtonItemTitle;

// 如果导航栏左右的ButtonItem是用UIButton初始化的，使用下面2个方法可以获得
@property (nonatomic, strong, readonly) UIButton *leftButton;
@property (nonatomic, strong, readonly) UIButton *rightButton;

@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;

@end

@interface UINavigationItem (BarButtonItem) <UINavigationItemBarButtonItemProtocol>

#pragma mark - Style
- (void)barButtonItemsStyleToFit;

- (void)backButtonItemStyleToFit;
- (void)closeButtonItemStyleToFit;

#pragma mark - Left
- (UIBarButtonItem *)addLeftBarButtonItemWithImage:(UIImage *)leftItemImage target:(id)target action:(SEL)leftItemSelector;

- (UIBarButtonItem *)addBackButtonItemWithImage:(UIImage *)leftItemImage target:(id)target action:(SEL)leftItemSelector;
- (UIBarButtonItem *)addCloseBarButtonItemWithImage:(UIImage *)leftItemImage target:(id)target action:(SEL)leftItemSelector;

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
- (UIBarButtonItem *)addLeftBarButtonItem:(id)item type:(BarButtonItemType)type target:(id)target action:(SEL)rightItemSelector;

// when items has only one object, then return the object(type: UIBarButtonItem)
- (NSArray *)addLeftBarButtonItems:(NSArray *)items types:(NSArray *)types target:(id)target actions:(NSArray *)selectorStrings;

- (void)removeLeftBarButtonItems;

#pragma mark - Right
- (void)addRightBarButtonItem:(UIBarButtonItem *)rightButtonItem;
- (UIBarButtonItem *)addRightBarButtonItem:(id)item type:(BarButtonItemType)type target:(id)target action:(SEL)rightItemSelector;

// when items has only one object, then return the object(type: UIBarButtonItem)
- (NSArray *)addRightBarButtonItems:(NSArray *)items types:(NSArray *)types target:(id)target actions:(NSArray *)selectorStrings;

- (void)removeRightBarButtonItems;


@end
