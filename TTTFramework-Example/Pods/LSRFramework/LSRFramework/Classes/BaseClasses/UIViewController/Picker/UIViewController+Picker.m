//
//  UIViewController+Picker.m
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UIViewController+Picker.h"
// #import "RSKImageCropViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+Alert.h"
#import "UIViewController+.h"

@implementation UIViewController (Picker)

#pragma mark - Assets
#if 0
- (UIViewController *)imageCropperWithImage:(UIImage *)image
{
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = (id<RSKImageCropViewControllerDelegate>)self;
    return imageCropVC;
}
#endif

#if (TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0)
- (AssetPickerViewController *)assetPicker
{
    AssetPickerViewController *picker = [[AssetPickerViewController alloc] init];
    picker.maximumNumberOfSelection = 100000;
    picker.assetsFilter = [ALAssetsFilter allAssets];
    picker.showEmptyGroups = NO;
    picker.pickerDelegate = (id<AssetPickerViewControllerDelegate>)self;
    picker.navigationBar.translucent = YES;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 0;
        } else {
            return YES;
        }
    }];
    
    return picker;
}
#endif

#if (TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0)
- (void)dispatchAssetsPicker:(void (^__nullable)(CTAssetsPickerController *__nullable picker))pickerCallback
{
    // 判断是否已授权
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            [self requestAuthorizationBeforeDispatchAssetsPicker:^(CTAssetsPickerController * _Nullable picker) {
                if (pickerCallback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        pickerCallback(picker);
                    });
                }
            }];
            break;
        }
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showPhotoAccessDenied];
                
                if (pickerCallback) {
                    pickerCallback(nil);
                }
            });
            break;
        }
        case PHAuthorizationStatusAuthorized:
        default: {
            [self dispatchAssetsPickerFinally:^(CTAssetsPickerController * _Nullable picker) {
                if (pickerCallback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        pickerCallback(picker);
                    });
                }
            }];
            break;
        }
    }
}

#pragma mark - Tools
- (void)requestAuthorizationBeforeDispatchAssetsPicker:(void (^__nullable)(CTAssetsPickerController *__nullable picker))pickerCallback
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized: {
                [self dispatchAssetsPickerFinally:pickerCallback];
                break;
            }
            default: {
                [self showPhotoAccessDenied];
                
                if (pickerCallback) {
                    pickerCallback(nil);
                }
                break;
            }
        }
    }];
}

- (void)showPhotoAccessDenied
{
    // Alert will be in main thread
    [self showAlertWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请前往设置->隐私->相册 授权应用访问相册权限", nil) sureTitle:NSLocalizedString(@"确定", nil) sureHandler:nil];
}

- (void)dispatchAssetsPickerFinally:(void (^__nullable)(CTAssetsPickerController *__nullable picker))pickerCallback
{
    // init picker
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    
    // set delegate
    picker.delegate = (id<CTAssetsPickerControllerDelegate>)self;
    picker.showsEmptyAlbums = NO;
    picker.preferredNavigationBarColor = self.preferredNavigationBarColor;
    
    // to present picker as a form sheet in iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        picker.modalPresentationStyle = UIModalPresentationFormSheet;
    } else {
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    if (pickerCallback) {
        pickerCallback(picker);
    }
}

#endif

#pragma mark - Camera
- (void)dispatchPhotoCameraPicker:(void (^__nullable)(UIImagePickerController *__nullable picker))pickerCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dispatchMediaTypes:@[(__bridge NSString *)kUTTypeImage] cameraPicker:^(UIImagePickerController * _Nullable photoCameraPicker) {
            
            if (photoCameraPicker) {
                photoCameraPicker.allowsEditing = NO;
            }
            
            if (pickerCallback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    pickerCallback(photoCameraPicker);
                });
            }
        }];
    });
}

- (void)dispatchVideoCameraPicker:(void (^__nullable)(UIImagePickerController *__nullable picker))pickerCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dispatchMediaTypes:@[(__bridge NSString *)kUTTypeMovie] cameraPicker:^(UIImagePickerController * _Nullable videoCameraPicker) {
            
            if (videoCameraPicker) {
                videoCameraPicker.allowsEditing = NO;
            }
            
            if (pickerCallback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    pickerCallback(videoCameraPicker);
                });
            }
        }];
    });
}

- (void)dispatchCameraPicker:(void (^__nullable)(UIImagePickerController *__nullable picker))pickerCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dispatchMediaTypes:@[(__bridge NSString *)kUTTypeImage, (__bridge NSString *)kUTTypeMovie] cameraPicker:^(UIImagePickerController * _Nullable cameraPicker) {
            
            if (cameraPicker) {
                cameraPicker.allowsEditing = NO;
            }
            
            if (pickerCallback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    pickerCallback(cameraPicker);
                });
            }
        }];
    });
}

#pragma mark - Tools
- (void)dispatchMediaTypes:(NSArray *)mediaTypes cameraPicker:(void (^__nullable)(UIImagePickerController *__nullable picker))pickerCallback
{
    // 判断是否已授权
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            [self requestAuthorizationBeforeDispatchMediaTypes:mediaTypes cameraPicker:pickerCallback];
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            [self showCameraAccessDenied];
            if (pickerCallback) {
                pickerCallback(nil);
            }
            break;
        }
        case AVAuthorizationStatusAuthorized:
        default: {
            [self dispatchMediaTypes:mediaTypes finallyCameraPicker:pickerCallback];
            break;
        }
    }
}

- (void)requestAuthorizationBeforeDispatchMediaTypes:(NSArray *)mediaTypes cameraPicker:(void (^__nullable)(UIImagePickerController *__nullable picker))pickerCallback
{
    // 相机权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            [self dispatchMediaTypes:mediaTypes finallyCameraPicker:pickerCallback];
        } else {
            [self showCameraAccessDenied];
            if (pickerCallback)
            {
                pickerCallback(nil);
            }
        }
    }];
}

- (void)showCameraAccessDenied
{
    // Alert will be in main thread
    [self showAlertWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请前往设置->隐私->相机 授权应用拍照权限", nil) sureTitle:NSLocalizedString(@"确定", nil) sureHandler:nil];
}

- (void)dispatchMediaTypes:(NSArray *)mediaTypes finallyCameraPicker:(void (^__nullable)(UIImagePickerController *__nullable picker))pickerCallback
{
    // 判断是否可以打开相机
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // Alert will be in main thread
        [self showAlertWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您没有相机", nil) sureTitle:NSLocalizedString(@"确定", nil) sureHandler:nil];
        
        if (pickerCallback) {
            pickerCallback(nil);
        }
        return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
    ipc.allowsEditing = YES;
    ipc.videoQuality = UIImagePickerControllerQualityTypeHigh;
    // ipc.videoMaximumDuration = 30.0f;
    
    // kUTTypeImage kUTTypeJPEG kUTTypeMovie kUTTypeMPEG4
    ipc.mediaTypes = mediaTypes;
    
    ipc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    if (pickerCallback) {
        pickerCallback(ipc);
    }
}

@end
