//
//  BlurEffectViewController.m
//  TTTFramework-Testing
//
//  Created by jia on 2017/1/14.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "BlurEffectViewController.h"
#import <TTTFramework/TTTFramework.h>
#import <Masonry/Masonry.h>

@interface BlurEffectViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation BlurEffectViewController

- (BOOL)customizedEnabled
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *))
    {
        self.wantedNavigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _blurEffectStyle = UIBlurEffectStyleExtraLight;
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy load
- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [UIImageView new];
    }
    return _backgroundImageView;
}

- (UIVisualEffectView *)effectView
{
    if (!_effectView)
    {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        // UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        // effectView.alpha = 0.9;
        _effectView = effectView;
    }
    return _effectView;
}

#pragma mark - Member Methods
- (void)setupSubviews
{
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.effectView];
    
    __weak __typeof(self) wself = self;
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(wself.view);
    }];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(wself.view);
    }];
}

- (void)setBlurBackgroundImage:(UIImage *)blurBackgroundImage
{
    self.backgroundImageView.image = blurBackgroundImage;
}

- (UIImage *)blurBackgroundImage
{
    return self.backgroundImageView.image;
}

- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
{
    _blurEffectStyle = blurEffectStyle;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
    self.effectView.effect = blurEffect;
}

@end
