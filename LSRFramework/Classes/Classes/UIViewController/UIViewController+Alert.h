//
//  UIViewController+Alert.h
//  FileBox
//
//  Created by jia on 16/4/11.
//  Copyright © 2016年 OrangeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Alignment)

@property (nonatomic, readwrite) NSTextAlignment messageTextAlignment;

@end

@class UIAlertControllerParams;
@protocol UIViewControllerAlertProtocol <NSObject>

@property (nonatomic, readonly) UIAlertControllerParams * _Nullable alertControllerParams;

@property (nonatomic, readonly) NSMutableArray * _Nullable alertControllers;

@end

@interface UIAlertControllerParams : NSObject

@property (nonatomic, readwrite) BOOL animated;
@property (nonatomic, copy) void (^ _Nullable completion)(void);

@end

typedef void (^ActionHandler)(UIAlertAction * __nullable action);

@interface UIViewController (Alert) <UIViewControllerAlertProtocol>

#if (TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0)

#pragma mark - Alert
- (UIAlertController * __nullable)showAlertWithTitle:(NSString * __nullable)title
                                             message:(NSString * __nullable)message
                                           sureTitle:(id __nullable)sureTitle
                                         sureHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))sureHandler NS_ENUM_AVAILABLE_IOS(8_0);

- (UIAlertController * __nullable)showAlertWithTitle:(NSString * __nullable)title
                                             message:(NSString * __nullable)message
                                         cancelTitle:(id __nullable)cancelTitle
                                           sureTitle:(id __nullable)sureTitle
                                       cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                         sureHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))sureHandler NS_ENUM_AVAILABLE_IOS(8_0);

- (UIAlertController * __nullable)showAlertWithTitle:(NSString * __nullable)title
                                             message:(NSString * __nullable)message
                                     textFieldConfig:(void (^ __nullable)(UITextField * __nonnull textField))textFieldConfig
                                         cancelTitle:(id __nullable)cancelTitle
                                           sureTitle:(id __nullable)sureTitle
                                       cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                         sureHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))sureHandler NS_ENUM_AVAILABLE_IOS(8_0);

- (UIAlertController * __nullable)showAlertWithTitle:(NSString * __nullable)title
                                             message:(NSString * __nullable)message
                                     textFieldConfig:(void (^ __nullable)(UITextField * __nonnull textField))textFieldConfig
                                         cancelTitle:(id __nullable)cancelTitle
                                          sureTitles:(NSArray * __nullable)sureTitles
                                       cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                        sureHandlers:(NSArray * __nullable)sureHandlers NS_ENUM_AVAILABLE_IOS(8_0);
#pragma mark - Action Sheet
- (UIAlertController * __nullable)showActionSheetWithTitle:(NSString * __nullable)title
                                                   message:(NSString * __nullable)message
                                               cancelTitle:(id __nullable)cancelTitle
                                                 sureTitle:(id __nullable)sureTitle
                                             cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                               sureHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))sureHandler NS_ENUM_AVAILABLE_IOS(8_0);

- (UIAlertController * __nullable)showActionSheetWithTitle:(NSString * __nullable)title
                                                   message:(NSString * __nullable)message
                                               cancelTitle:(id __nullable)cancelTitle
                                                sureTitles:(NSArray * __nullable)sureTitles
                                             cancelHandler:(void (^ __nullable)(UIAlertAction * __nonnull action))cancelHandler
                                              sureHandlers:(NSArray * __nullable)sureHandlers NS_ENUM_AVAILABLE_IOS(8_0);

#endif

@end
