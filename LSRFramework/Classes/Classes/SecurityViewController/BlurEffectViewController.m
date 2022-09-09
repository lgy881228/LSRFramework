//
//  BlurEffectViewController.m
//  Folder
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
    
    _blurEffectStyle = UIBlurEffectStyleExtraLight;
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark - Status Bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.prefersStatusBarStyleLightContent)
    {
        return UIStatusBarStyleLightContent;
    }
    else if (self.prefersStatusBarStyleDarkContent)
    {
        if (@available(iOS 13.0, *)) {
            return UIStatusBarStyleDarkContent;
        } else {
            // Automatically chooses light or dark content based on the user interface style
            return UIStatusBarStyleDefault;
        }
    }
    else
    {
        // Automatically chooses light or dark content based on the user interface style
        return UIStatusBarStyleDefault;
    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

#pragma mark - Member Methods
- (void)setupSubviews
{
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.effectView];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
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
