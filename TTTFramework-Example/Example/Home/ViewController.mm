//
//  ViewController.m
//  TTTFramework-Testing
//
//  Created by jia on 2016/11/2.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+ContentView.h"
#import "UIImage+Color.h"
#import "PushedViewController.h"
#import <TTTFramework/TTTFramework.h>
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Life Cycle
- (BOOL)customizedEnabled
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    UINavigationItem *selfNavigationItem = self.navigationItem;
//    UINavigationItem *naviNavigationItem = self.navigationController.navigationItem;
//    UINavigationItem *topNaviNavigationItem = self.navigationController.navigationBar.topItem;
//    NSArray *navigationItems = self.navigationController.navigationBar.items;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Member Methods
- (void)setupNavigationBar
{
    self.navigationBarTitle = @"首页";
    
    if ([self.navigationController isKindOfClass:NavigationController.class]) {
        NavigationController *navi = (NavigationController *)self.navigationController;
        navi.navigationBarTranslucent = YES;
    } else {
        self.navigationController.navigationBar.translucent = YES;
    }
    
    self.preferredNavigationBarColor = UIColor.clearColor;
    self.preferredNavigationBarTitleColor = UIColor.whiteColor;
    self.wantedNavigationItem.barButtonItemColor = UIColor.whiteColor;
    
    CGRect frame = self.navigationController.navigationBar.bounds;
    frame.origin.y -= STATUS_BAR_HEIGHT;
    frame.size.height += STATUS_BAR_HEIGHT;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    UIColor *startColor = RGBACOLOR(0, 0, 0, 0.5);
    UIColor *endColor   = RGBACOLOR(0, 0, 0, 0);
    
    // 渐变色
    gradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    // 将渐变往上提
    // gradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor, (id)endColor.CGColor];
    // gradient.locations = @[@(0.0), @(0.9), @(1.0)];
    
    // [self.navigationController.navigationBar.layer addSublayer:gradient];
    
    // 左侧按钮
#if 0
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:0];
    [self addNavigationBarLeftButtonItem:item];
    
    
    //     [self addNavigationBarLeftButtonItemWithTitle:@"DDD" action:nil];
    
    //     [self addNavigationBarLeftButtonItemWithImageName:@"navigation_bar_add" action:nil];
    
    // UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.navigationBarLocationButton];
#elif 1
    [self addNavigationBarLeftButtonItems:@[@"home_navigation_bar_scan",
                                            @(10),
                                            @"home_navigation_bar_scan"]
                                    types:@[@(BarButtonItemTypeImageName),
                                            @(BarButtonItemTypeSpace),
                                            @(BarButtonItemTypeImageName)]
                                  actions:@[NSStringFromSelector(@selector(pushViewController)),
                                            [NSNull null],
                                            NSStringFromSelector(@selector(pushViewController))]];
#else
    [self addNavigationBarLeftButtonItems:@[@"左侧间距", @(10)]
                                    types:@[@(BarButtonItemTypeTitle), @(BarButtonItemTypeSpace)]
                                  actions:nil];
#endif
    
    // 右侧按钮
#if 0
    [self addNavigationBarRightButtonItems:@[@"push", @"present"]
                                     types:@[@(BarButtonItemTypeTitle), @(BarButtonItemTypeTitle)]
                                   actions:@[NSStringFromSelector(@selector(pushViewController)), NSStringFromSelector(@selector(presentViewController))]];
#elif 0
    [self addNavigationBarRightButtonItemWithTitle:@"Push" action:@selector(pushViewController)];
#elif 1
    // 先添加的在右边
    [self addNavigationBarRightButtonItems:@[@"home_navigation_bar_scan",
                                             @(10),
                                             @"home_navigation_bar_scan"]
                                     types:@[@(BarButtonItemTypeImageName),
                                             @(BarButtonItemTypeSpace),
                                             @(BarButtonItemTypeImageName)]
                                   actions:@[NSStringFromSelector(@selector(pushViewController)),
                                             [NSNull null],
                                             NSStringFromSelector(@selector(pushViewController))]];
#else
    NSString *imageName = @"home_navigation_bar_scan";
    
    /*
     UIImage *image = [UIImage imageNamed:imageName];
     [self addNavigationBarRightButtonItemWithImage:image action:@selector(pushViewController)];
     */
    
    [self addNavigationBarRightButtonItemWithImageName:imageName action:@selector(pushViewController)];
#endif
    
}

- (void)setupSubviews
{
    [self setupBackgroundView];
    
    __weak __typeof(self) wself = self;
    
    UIButton *button1 = [self buttonWithTitle:@"Loading" selector:@selector(testLoading:)];
    [self.view addSubview:button1];
    
    UIButton *button2 = [self buttonWithTitle:@"选择操作" selector:@selector(selectActions:)];
    [self.view addSubview:button2];
    
    UIButton *button3 = [self buttonWithTitle:@"修改启动图" selector:@selector(changeLaunchImage:)];
    [self.view addSubview:button3];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 30));
        make.centerX.equalTo(wself.view);
        make.top.equalTo(wself.view).offset([[UIScreen mainScreen] bounds].size.height > 568.0 ? 150 : 90);
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 30));
        make.centerX.equalTo(wself.view);
        make.top.equalTo(button1.mas_bottom).offset(30);
    }];
    
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 30));
        make.centerX.equalTo(wself.view);
        make.top.equalTo(button2.mas_bottom).offset(30);
    }];
}

- (void)setupBackgroundView
{
#if 1
    // 用图片设置背景色
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"home_background" ofType:@"JPG"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *bgImage = [[UIImage alloc] initWithData:imageData scale:SCREEN_SCALE];
    // bgImage = [bgImage scaleToSize:self.view.frame.size];
    
    // bgImage = [UIImage imageToTransparent:bgImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
#else
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"home_background" ofType:@"JPG"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData scale:SCREEN_SCALE];
    self.view.layer.contents = (id) image.CGImage;
    // 如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    // self.view.backgroundColor = [UIColor whiteColor];
#endif
}

- (void)testLoading:(id)sender
{
    static int i = 0;
    if (++i % 2)
    {
        self.preferredLoadingPromptTheme = LoadingPromptThemeLight;
    }
    else
    {
        self.preferredLoadingPromptTheme = LoadingPromptThemeDark;
    }
    
    [self promptMessage:@"测试prompt"];
    
    [NSThread delaySeconds:1.0 perform:^{
        
        [self showLoading:@"不等prompt结束 测试loading...10s"];
        [NSThread delaySeconds:10.0 perform:^{
            
            [self hideLoading];
        }];
        
        [NSThread delaySeconds:2.0 perform:^{
            
            [self promptMessage:@"不等loading 测试prompt"];
        }];
    }];
}

- (void)selectActions:(id)sender
{
#if 0
    // textfield
    [self showAlertWithTitle:@"你好" message:@"滴滴答答滴滴答答的多" textFieldConfig:^(UITextField * _Nonnull textField) {
        //
    } cancelTitle:@"好的" sureTitle:@"不要" cancelHandler:^(UIAlertAction * _Nonnull action) {
        //
    } sureHandler:^(UIAlertAction * _Nonnull action) {
        //
    }];
#else
    
    ActionHandler takePhotoHandler = ^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    };
    
    ActionHandler selectImagesHandler = ^(UIAlertAction * _Nonnull action) {
        [self selectAssets];
    };
    
    ActionHandler sendMailHandler = ^(UIAlertAction * _Nonnull action) {
        [self sendMail];
    };
    
    [self showActionSheetWithTitle:@"标题 标题"
                           message:@"描述描述描述\n描述描述描述描述描述描述描述描述描述描述描述描述描述描述来\n描述描述描述描述描述来\n描述\n嘛描述描述描述描述描述"
                       cancelTitle:NSLocalizedString(@"取消", nil)
                        sureTitles:@[NSLocalizedString(@"拍照", nil), NSLocalizedString(@"相册选择", nil), NSLocalizedString(@"发送邮件", nil)]
                     cancelHandler:^(UIAlertAction * _Nonnull action) {
                         // do nothing
                     }
                      sureHandlers:@[takePhotoHandler, selectImagesHandler, sendMailHandler]];
#endif
}

- (void)changeLaunchImage:(id)sender
{
    
}

#pragma mark - Tools
- (UIButton *)buttonWithTitle:(NSString *)title selector:(SEL)selector
{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.65];
    button.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 3.0;
    [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)selectAssets
{
    [self dispatchAssetsPicker:^(CTAssetsPickerController *picker) {
        
        if (picker)
        {
            [self presentViewController:picker animated:YES completion:^{
                //
            }];
        }
    }];
}

- (void)sendMail
{
    //    [self sendMailWithSubject:@"邮件描述"
    //                  messageBody:@"邮\n件\n内\n容\n"
    //                  attachments:nil
    //                 toRecipients:@[@"wind.like.the.man@icloud.com"]];
}

- (void)pushViewController
{
    UIViewController *vc = [[PushedViewController alloc] init];
    vc.navigationBarTitle = @"Push";
    vc.customizedEnabled = YES;
    // vc.preferredNavigationBarColor = nil;
    // vc.prefersNavigationBarHidden = YES;
    vc.preferredNavigationBarTitleColor = (UIColor *)[NSNull null];
    vc.preferredNavigationBarTitleFont = [UIFont systemFontOfSize:25];
    
    vc.wantedNavigationItem.barButtonItemColor = [UIColor redColor];
    vc.wantedNavigationItem.barButtonItemFont = [UIFont systemFontOfSize:25];
    
    [self pushViewController:vc];
}

- (void)presentViewController
{
    UIViewController *vc = [UIViewController new];
    vc.navigationBarTitle = @"Present";
    // vc.customizedEnabled = NO;
    
    [self presentRootViewController:vc];
}

#pragma mark - 拍照
- (void)takePhoto
{
    [self dispatchPhotoCameraPicker:^(UIImagePickerController * _Nullable cameraController) {
        
        if (cameraController)
        {
            [self presentRootViewController:cameraController];
            
            [NSThread delaySeconds:0.2f perform:^{
                // 设置状态栏
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
            }];
        }
    }];
}

// 拍照后回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 设置状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [picker dismiss];
    
    // 拍照后回先保存
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(originalImage,
                                   self,
                                   @selector(image: didFinishSavingWithError: contextInfo:),
                                   nil);
}

// 取消拍照后回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 设置状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [picker dismiss];
}

// 保存图片后到相册后，回调是否保存成功
- (void)image:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo
{
    if (!paramError)
    {
        NSLog(@"Image was saved successfully.");
    }
    else
    {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
    }
}

#pragma mark - CTAssetsPickerControllerDelegate Methods
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker dismiss];
    
    [self promptMessage:[NSString stringWithFormat:@"您选择了%ld张图片", assets.count]];
}

@end
