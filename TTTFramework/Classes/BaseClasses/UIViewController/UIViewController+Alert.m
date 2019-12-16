//
//  UIViewController+Alert.m
//  FileBox
//
//  Created by jia on 16/4/11.
//  Copyright © 2016年 OrangeTeam. All rights reserved.
//

#import "UIViewController+Alert.h"
#import "NSObject+Helper.h"
#import <objc/runtime.h>

@implementation UIAlertController (Alignment)

- (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment {
    if (self.view.subviews.count > 0) {
        UIView *subView1 = self.view.subviews[0];
        
        if (subView1.subviews.count > 0) {
            UIView *subView2 = subView1.subviews[0];
            
            if (subView2.subviews.count > 0) {
                UIView *subView3 = subView2.subviews[0];
                
                if (subView3.subviews.count > 0) {
                    UIView *subView4 = subView3.subviews[0];
                    
                    if (subView4.subviews.count > 0) {
                        UIView *subView5 = subView4.subviews[0];
                        
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0) {
                            UILabel *message = subView5.subviews[2];
                            message.textAlignment = messageTextAlignment;
                        } else {
                            // 取title和message：
                            // UILabel *title = subView5.subviews[0];
                            UILabel *message = subView5.subviews[1];
                            message.textAlignment = messageTextAlignment;
                            // title.textAlignment = NSTextAlignmentLeft;
                        }
                    }
                }
            }
        }
    }
}

- (NSTextAlignment)messageTextAlignment {
    if (self.view.subviews.count > 0) {
        UIView *subView1 = self.view.subviews[0];
        
        if (subView1.subviews.count > 0) {
            UIView *subView2 = subView1.subviews[0];
            
            if (subView2.subviews.count > 0) {
                UIView *subView3 = subView2.subviews[0];
                
                if (subView3.subviews.count > 0) {
                    UIView *subView4 = subView3.subviews[0];
                    
                    if (subView4.subviews.count > 0) {
                        UIView *subView5 = subView4.subviews[0];
                        
                        UILabel *message = subView5.subviews[1];
                        return message.textAlignment;
                    }
                }
            }
        }
    }
    return NSTextAlignmentCenter; // 可能没取到label，但系统AlertView默认是居中
}

@end

@implementation UIAlertControllerParams

@end

@implementation UIViewController (Alert)

- (void)setAlertControllerParams:(UIAlertControllerParams *)alertControllerParams {
    objc_setAssociatedObject(self, @selector(alertControllerParams), alertControllerParams, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIAlertControllerParams *)alertControllerParams {
    return objc_getAssociatedObject(self, @selector(alertControllerParams));
}

- (void)setAlertControllers:(NSMutableArray *)alertControllers {
    objc_setAssociatedObject(self, @selector(alertControllers), alertControllers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)alertControllers {
    NSMutableArray *alertControllers = objc_getAssociatedObject(self, @selector(alertControllers));
    if (!alertControllers) {
        alertControllers = [[NSMutableArray alloc] init];
        self.alertControllers = alertControllers;
    }
    return alertControllers;
}

#pragma mark - Alert
- (UIAlertController * __nullable)showAlertWithTitle:(NSString * __nullable)title
                                             message:(NSString * __nullable)message
                                           sureTitle:(id __nullable)sureTitle
                                         sureHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))sureHandler {
    UIAlertController *vc = [self showAlertWithTitle:title message:message textFieldConfig:nil cancelTitle:sureTitle sureTitle:nil cancelHandler:sureHandler sureHandler:nil];
    return vc;
}

- (UIAlertController * __nullable)showAlertWithTitle:(NSString * __nullable)title
                                             message:(NSString * __nullable)message
                                         cancelTitle:(id __nullable)cancelTitle
                                           sureTitle:(id __nullable)sureTitle
                                       cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                         sureHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))sureHandler {
    UIAlertController *vc = [self showAlertWithTitle:title message:message textFieldConfig:nil cancelTitle:cancelTitle sureTitle:sureTitle cancelHandler:cancelHandler sureHandler:sureHandler];
    return vc;
}

// use text fileld or not
- (UIAlertController * __nullable)showAlertWithTitle:(NSString * __nullable)title
                                             message:(NSString * __nullable)message
                                     textFieldConfig:(void (^ __nullable)(UITextField * __nonnull textField))textFieldConfig
                                         cancelTitle:(id __nullable)cancelTitle
                                           sureTitle:(id __nullable)sureTitle
                                       cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                         sureHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))sureHandler {
    // alert 必须有一个按钮
    if (!sureTitle && !cancelTitle) {
        cancelTitle = NSLocalizedString(@"好的", nil);
        
        if (!cancelHandler) cancelHandler = sureHandler;
    }
    
    NSArray *sureTitles = sureTitle ? @[sureTitle] : nil;
    NSArray *sureHandlers = sureHandler ? @[sureHandler] : nil;
    
    UIAlertController *vc = [self showAlertWithTitle:title message:message textFieldConfig:textFieldConfig cancelTitle:cancelTitle sureTitles:sureTitles cancelHandler:cancelHandler sureHandlers:sureHandlers];
    return vc;
}

// use text fileld or not
- (UIAlertController * __nullable)showAlertWithTitle:(NSString * __nullable)title
                                             message:(NSString * __nullable)message
                                     textFieldConfig:(void (^ __nullable)(UITextField * __nonnull textField))textFieldConfig
                                         cancelTitle:(id __nullable)cancelTitle
                                          sureTitles:(NSArray * __nullable)sureTitles
                                       cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                        sureHandlers:(NSArray * __nullable)sureHandlers NS_ENUM_AVAILABLE_IOS(8_0) {
    UIAlertController *alertController = [self alertControllerWithTitle:title message:message style:UIAlertControllerStyleAlert textFieldConfig:textFieldConfig cancelTitle:cancelTitle sureTitles:sureTitles cancelHandler:cancelHandler sureHandlers:sureHandlers];
    
    [self presentAlertController:alertController animated:YES completion:^{
        // todo
    }];
    
    return alertController;
}

#pragma mark - Action Sheet
- (UIAlertController * __nullable)showActionSheetWithTitle:(NSString * __nullable)title
                                                   message:(NSString * __nullable)message
                                               cancelTitle:(id __nullable)cancelTitle
                                                 sureTitle:(id __nullable)sureTitle
                                             cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                               sureHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))sureHandler {
    // action sheet 要干事，不能有确定没取消
    if (!cancelTitle) cancelTitle = NSLocalizedString(@"取消", nil);
    
    if (!sureTitle) sureTitle = NSLocalizedString(@"确定", nil);
    
    NSArray *sureHandlers = sureHandler ? @[sureHandler] : nil;
    
    UIAlertController *vc = [self showActionSheetWithTitle:title message:message cancelTitle:cancelTitle sureTitles:@[sureTitle] cancelHandler:cancelHandler sureHandlers:sureHandlers];
    return vc;
}

- (UIAlertController * __nullable)showActionSheetWithTitle:(NSString * __nullable)title
                                                   message:(NSString * __nullable)message
                                               cancelTitle:(id __nullable)cancelTitle
                                                sureTitles:(NSArray * __nullable)sureTitles
                                             cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                              sureHandlers:(NSArray * __nullable)sureHandlers {
    UIAlertController *alertController = [self alertControllerWithTitle:title message:message style:UIAlertControllerStyleActionSheet textFieldConfig:nil cancelTitle:cancelTitle sureTitles:sureTitles cancelHandler:cancelHandler sureHandlers:sureHandlers];
    
    [self presentAlertController:alertController animated:YES completion:^{
        // todo
    }];
    
    return alertController;
}

#pragma mark - Functions
// use text fileld or not
- (UIAlertController * __nullable)alertControllerWithTitle:(NSString * __nullable)title
                                                   message:(NSString * __nullable)message
                                                     style:(UIAlertControllerStyle)style
                                           textFieldConfig:(void (^ __nullable)(UITextField * __nonnull textField))textFieldConfig
                                               cancelTitle:(id __nullable)cancelTitle
                                                sureTitles:(NSArray * __nullable)sureTitles
                                             cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                              sureHandlers:(NSArray * __nullable)sureHandlers {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    if (textFieldConfig) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertController addTextFieldWithConfigurationHandler:textFieldConfig];
        });
    }
    
    __weak __typeof(self) wself = self;
    __weak __typeof(alertController) wselfController = alertController;
    
    if (cancelTitle) {
#if 1
        UIAlertAction *oneAction = [cancelTitle isKindOfClass:[UIAlertAction class]] ? (UIAlertAction *)cancelTitle : nil;
        NSString *actionTitle = oneAction ? oneAction.title : cancelTitle;
        UIAlertActionStyle style = oneAction ? oneAction.style : UIAlertActionStyleCancel;
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:actionTitle style:style handler:^(UIAlertAction *cancelAction) {
            if (cancelHandler) {
                cancelHandler(cancelAction);
            }
            
            // 可能没有handler，但alertController在数组里
            [wself handleActionFinished:wselfController];
        }];
        
        [alertController addAction:cancelAction];
#else
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancelAction) {
            [wself handleActionFinished:wselfController];
        }];
        
        [alertController addAction:cancelAction];
#endif
    }
    
    if (sureTitles && sureTitles.count > 0) {
#if 1
        for (NSInteger i = 0; i < sureTitles.count; ++i) {
            UIAlertAction *oneAction = [sureTitles[i] isKindOfClass:[UIAlertAction class]] ? sureTitles[i] : nil;
            NSString *actionTitle = oneAction ? oneAction.title : sureTitles[i];
            UIAlertActionStyle style = oneAction ? oneAction.style : UIAlertActionStyleDefault;
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:actionTitle style:style handler:^(UIAlertAction *action) {
                
                if (sureHandlers && sureHandlers.count > i) {
                    ActionHandler actionHandler = (void (^)(UIAlertAction *action))sureHandlers[i];
                    actionHandler(action);
                }
                
                // 可能没有handler，但alertController在数组里
                [wself handleActionFinished:wselfController];
            }];
            sureAction.enabled = oneAction ? oneAction.isEnabled : YES;
            
            [alertController addAction:sureAction];
        }
#else
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [wself handleActionFinished:wselfController];
        }];
        sureAction.enabled = YES;
        
        [alertController addAction:sureAction];
#endif
    }
    
    return alertController;
}

- (void)presentAlertController:(UIViewController *)alertController animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    @synchronized(self) {
#if 1
        if (!self.alertControllers.count) {
            [self.alertControllers addObject:alertController];
            
            __weak __typeof(self) wself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself presentViewController:alertController animated:flag completion:completion];
            });
        } else {
            UIAlertControllerParams *params = [[UIAlertControllerParams alloc] init];
            params.animated = flag;
            params.completion = completion;
            alertController.alertControllerParams = params;
            
            [self.alertControllers addObject:alertController];
        }
#else
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:flag completion:completion];
        });
#endif
    }
}

- (void)handleActionFinished:(UIViewController *)alertController {
    if ([self.alertControllers containsObject:alertController]) {
        [self.alertControllers removeObject:alertController];
    }
    
    if (self.alertControllers.count) {
        UIViewController *controller = self.alertControllers.firstObject;
        UIAlertControllerParams *params = controller.alertControllerParams;
        
        __weak __typeof(self) wself = self;
        [NSThread delaySeconds:0.35 perform:^{
            if (params) {
                [wself presentViewController:controller animated:params.animated completion:params.completion];
                
                controller.alertControllerParams = nil;
            } else {
                [wself presentViewController:controller animated:YES completion:^{
                    //
                }];
            }
        }];
    } else {
        self.alertControllers = nil;
    }
}

@end
