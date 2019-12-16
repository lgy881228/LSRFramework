//
//  UIViewController+Picker.h
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"
#import "CTAssetCheckmark.h"

@interface UIViewController (Picker)

#pragma mark - Assets
#if 0
- (UIViewController *)imageCropperWithImage:(UIImage *)image;
#endif

#if (TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0)
- (void)dispatchAssetsPicker:(void (^__nullable)(CTAssetsPickerController *__nullable picker))pickerCallback;
#endif

#pragma mark - Camera
- (void)dispatchPhotoCameraPicker:(void (^__nullable)(UIImagePickerController *__nullable picker))pickerCallback;
- (void)dispatchVideoCameraPicker:(void (^__nullable)(UIImagePickerController *__nullable picker))pickerCallback;

// both photo and video
- (void)dispatchCameraPicker:(void (^__nullable)(UIImagePickerController *__nullable picker))pickerCallback;

@end
