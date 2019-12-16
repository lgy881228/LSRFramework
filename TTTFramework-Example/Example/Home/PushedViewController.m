//
//  PushedViewController.m
//  TTTFramework-Testing
//
//  Created by jia on 2017/10/2.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "PushedViewController.h"
#import <TTTFramework/TTTFramework.h>
#import <Masonry/Masonry.h>

@interface PushedViewController ()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation PushedViewController

#pragma mark - Lazy Load
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton new];
        _leftButton.backgroundColor = [UIColor greenColor];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton new];
        _rightButton.backgroundColor = [UIColor yellowColor];
    }
    return _rightButton;
}

#pragma mark - Life Cycle
- (void)dealloc {
#if DEBUG
    NSLog(@"dealloc: %@", NSStringFromClass(self.class));
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftButton.frame = CGRectMake(0, 0, 50, 30);
    self.rightButton.frame = CGRectMake(0, 0, 50, 30);
    
    // UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:0];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    
    //    [self addNavigationBarRightButtonItem:rightItem];
    
    [self addNavigationBarRightButtonItems:@[rightItem, @"present"]
                                     types:@[@(BarButtonItemTypeItem), @(BarButtonItemTypeTitle)]
                                   actions:nil];
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)setupSubviews {
    __weak __typeof(self) wself = self;
    
    UIButton *button1 = [self buttonWithTitle:@"Alert" selector:@selector(testLoading:)];
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

- (void)testLoading:(id)sender {
    __weak __typeof(self) wself = self;
    [self showAlertWithTitle:@"测试" message:@"注意：alert之后，页面返回dealloc是否执行" sureTitle:@"好的" sureHandler:^(UIAlertAction * _Nonnull action) {
        if (wself) {
            __strong __typeof(self) self = wself;
            [self process:@"loading" completion:^(BOOL succeed, NSString *message) {
                if (wself) {
                    __strong __typeof(self) self = wself;
                    if (succeed) {
                        [self promptMessage:message];
                    }
                }
            }];
        }
    }];
}

- (void)selectActions:(id)sender {

}

- (void)changeLaunchImage:(id)sender {
    
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

#pragma mark - Testing
- (void)process:(NSString *)process completion:(void (^)(BOOL succeed, NSString *message))completionHandler {
    [self showLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLoading];
        [self promptMessage:[NSString stringWithFormat:@"%@ 开始处理", process]];
        
        if (completionHandler)
        {
            completionHandler(YES, [NSString stringWithFormat:@"%@ 处理完成", process]);
        }
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
