//
//  BlurEffectViewController.h
//  Folder
//
//  Created by jia on 2017/1/14.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlurEffectViewController : UIViewController

@property (nonatomic, strong) UIImage *blurBackgroundImage;

@property (nonatomic, readwrite) UIBlurEffectStyle blurEffectStyle;
@property (nonatomic, readonly) UIVisualEffectView *effectView;

@end
