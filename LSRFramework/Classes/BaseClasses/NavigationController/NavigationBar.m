//
//  NavigationBar.m
//  TTTFramework
//
//  Created by jia on 16/4/12.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "NavigationBar.h"
#import "UIImage+Extension.h"

static CGFloat const kDefaultColorLayerOpacity = 0.4f; // 不透明度 控制导航条下面内容的穿透效果
static CGFloat const kSpaceToCoverStatusBars = 20.0f;

static CGFloat const kOpacityFactorA = 0.13284; // (0.13280, [0.13284, 0.13290]
static CGFloat const kOpacityFactorB = (1 - kOpacityFactorA);

@interface NavigationBar ()
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation NavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        CALayer *colorLayer = [CALayer layer];
        colorLayer.opacity = kDefaultColorLayerOpacity;
        colorLayer.hidden = YES;
        [self.layer addSublayer:colorLayer];
        
        self.colorLayer = colorLayer;
    }
    return self;
}

/*
 默认 self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
 self.navigationController.navigationBar.translucent = YES;
 self.navigationController.navigationBar.tintColor = nil;`

 黑色不透明
 self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
 self.navigationController.navigationBar.translucent = NO;
 self.navigationController.navigationBar.tintColor = [UIColor whiteColor];`
 
 黑色透明
 self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
 self.navigationController.navigationBar.translucent = YES;
 self.navigationController.navigationBar.tintColor = [UIColor whiteColor];`
 */
- (void)setBarTintColor:(UIColor *)barTintColor
{
    if (self.translucent)
    {
        if (barTintColor)
        {
            CGFloat r, g, b, a;
            [barTintColor getRed:&r green:&g blue:&b alpha:&a];
            
            // 有透明度
            if (a >= 0.999999)
            {
                // 自定义效果
                if (self.prefersCustomizedTranslucent)
                {
                    UIColor *calibratedColor = [UIColor colorWithRed:r green:g blue:b alpha:0.66];
                    CGFloat opacity = kDefaultColorLayerOpacity;
                    CGFloat minVal = MIN(MIN(r, g), b);
                    
                    if ([self convertValue:minVal withOpacity:opacity] < 0)
                    {
                        opacity = [self minOpacityForValue:minVal];
                    }
                    
                    CGFloat red = [self convertValue:r withOpacity:opacity];
                    CGFloat green = [self convertValue:g withOpacity:opacity];
                    CGFloat blue = [self convertValue:b withOpacity:opacity];
                    CGFloat alpha = a;
                    
                    red = MAX(MIN(1.0, red), 0);
                    green = MAX(MIN(1.0, green), 0);
                    blue = MAX(MIN(1.0, blue), 0);
                    
                    self.colorLayer.opacity = opacity;
                    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor;
                    
                    [super setBarTintColor:calibratedColor];
                }
                else
                {
                    self.colorLayer.opacity = 0.0f;
                    
                    [super setBarTintColor:barTintColor];
                }
                
                [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            }
            else
            {
                self.colorLayer.opacity = 0.0f;
                
                [self setBackgroundImage:[UIImage imageWithColor:barTintColor] forBarMetrics:UIBarMetricsDefault];
            }
        }
        else
        {
            // blur + 不设颜色，用系统默认效果
            self.colorLayer.opacity = 0.0f;
            
            [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [super setBarTintColor:nil]; // ⚠️重点：nil
        }
    }
    else
    {
        // 没有blur，则用绝对颜色
        self.colorLayer.opacity = 0.0f;
        
        [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [super setBarTintColor:barTintColor];
    }
}

- (CGFloat)convertValue:(CGFloat)value withOpacity:(CGFloat)opacity
{
    return kOpacityFactorA * value / opacity + kOpacityFactorB * value - kOpacityFactorA / opacity + kOpacityFactorA;
}

- (CGFloat)minOpacityForValue:(CGFloat)value
{
    return (kOpacityFactorA - kOpacityFactorA * value) / (kOpacityFactorA + kOpacityFactorB * value);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.colorLayer)
    {
        self.colorLayer.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kSpaceToCoverStatusBars);
        
        [self.layer insertSublayer:self.colorLayer atIndex:1];
    }
}

- (void)setPrefersCustomizedTranslucent:(BOOL)prefersCustomizedTranslucent
{
    self.colorLayer.hidden = !prefersCustomizedTranslucent;
}

- (BOOL)prefersCustomizedTranslucent
{
    return !self.colorLayer.hidden;
}

@end
