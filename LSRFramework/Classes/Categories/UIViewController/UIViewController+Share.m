//
//  UIViewController+Share.m
//  Folder
//
//  Created by jia on 2017/2/7.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "UIViewController+Share.h"
#import <TTTFramework/UIViewController+.h>
#import <TTTFramework/NSString+Extension.h>
#import <TTTFramework/NSObject+Helper.h>
#import <TTTFramework/UINavigationItem+BarButtonItem.h>
#import <TTTFramework/NSBundle+TTTFramework.h>

#define kEmailAttachmentNameKey       @"EmailAttachmentName"
#define kEmailAttachmentMimeTypeKey   @"EmailAttachmentMimeType"
#define kEmailAttachmentDataKey       @"EmailAttachmentData"

@implementation UIViewController (Share)

#pragma mark --- SMS
- (void)showSMSPicker
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));

    if (messageClass) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        } else {
            NSString *title = nil;
            NSString *message = TTTFrameworkLocalizedString(@"设备不支持短信功能", nil);
            // __weak __typeof(self) wself = self;
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:TTTFrameworkLocalizedString(@"确定", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *sureAction) {
                //
            }];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:sureAction];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
                //
            }];
        }
    } else {
        //
    }
}

- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSString *smsBody = [NSString stringWithFormat:TTTFrameworkLocalizedString(@"我分享了文件给您，地址是：%@", nil), @""];
    picker.body = smsBody;

    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        picker.modalPresentationStyle = UIModalPresentationPageSheet;
    } else {
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //
}

#pragma mark --- Send Mail
- (void)sendMailWithSubject:(NSString *)subject
                messageBody:(NSString *)mailBody
                attachments:(NSArray *)attachmentData
               toRecipients:(NSArray *)recepters
{
    // 1. 先判断能否发送邮件
    if (![MFMailComposeViewController canSendMail]) {
        // 提示用户设置邮箱
        [self showAlertWithTitle:TTTFrameworkLocalizedString(@"提示", nil) message:TTTFrameworkLocalizedString(@"您不能发送邮件 请前往“设置 > 邮件”添加邮箱帐户", nil) sureTitle:TTTFrameworkLocalizedString(@"确定", nil) sureHandler:nil];
        return;
    }

    MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
    emailer.mailComposeDelegate = self;
    [emailer setSubject:subject];
    [emailer setMessageBody:mailBody isHTML:NO];
    // [emailer setMessageBody:@"<HTML><B>Hello, Joe!</B><BR/>What do you know?</HTML>" isHTML:YES];
    [emailer setToRecipients:recepters];

    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        emailer.modalPresentationStyle = UIModalPresentationPageSheet;
    } else {
        emailer.modalPresentationStyle = UIModalPresentationFullScreen;
    }

    //    [emailer setToRecipients:toRecipients];
    //    [emailer setCcRecipients:ccRecipients];
    //    [emailer setBccRecipients:bccRecipients];

    if (attachmentData && attachmentData.count > 0) {
        for (NSDictionary *attachment in attachmentData) {
            [emailer addAttachmentData:[attachment objectForKey:kEmailAttachmentDataKey]
                              mimeType:[attachment objectForKey:kEmailAttachmentMimeTypeKey]
                              fileName:[attachment objectForKey:kEmailAttachmentNameKey]];
        }
    }

    UIViewController *vc = emailer.topViewController;
    vc.preferredNavigationBarColor = (UIColor *)[NSNull null]; // 表示使用系统默认
    vc.preferredNavigationBarTitleColor = (UIColor *)[NSNull null]; // 表示使用系统默认
    vc.wantedNavigationItem.barButtonItemColor = (UIColor *)[NSNull null]; // 表示使用系统默认
    vc.wantedNavigationItem.backButtonItemColor = (UIColor *)[NSNull null]; // 表示使用系统默认
    vc.wantedNavigationItem.closeButtonItemColor = (UIColor *)[NSNull null]; // 表示使用系统默认
    vc.prefersNavigationBarLeftSideCloseButtonWhenPresented = NO;
    vc.customizedEnabled = YES;

    [self presentViewController:emailer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    NSString *msg;

    switch (result) {
        case MFMailComposeResultCancelled:
            msg = TTTFrameworkLocalizedString(@"取消发送", nil);
            break;
        case MFMailComposeResultSaved:
            msg = TTTFrameworkLocalizedString(@"已保存邮件", nil);
            break;
        case MFMailComposeResultSent:
            msg = TTTFrameworkLocalizedString(@"发送成功", nil);
            break;
        case MFMailComposeResultFailed:
            msg = TTTFrameworkLocalizedString(@"发送失败", nil);
            break;
        default:
            break;
    }

    [self dismissViewControllerAnimated:YES completion:^{
        [self promptMessage:msg];
    }];
}

#pragma mark - Image
- (void)shareItems:(NSArray<id<NSSecureCoding>> *)items customized:(void (^)(UIActivityViewController *activityViewController))customized completion:(void (^)(BOOL completed, NSString *message))completionHandler
{
    if (!items.count) {
        [self promptMessage:TTTFrameworkLocalizedString(@"发生异常错误，请稍后重试", nil)];
        return;
    }

    [self showLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLoading];
    });

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(NSString *__nullable activityType, BOOL completed, NSArray *__nullable returnedItems, NSError *__nullable activityError) {
        NSString *msg = nil;
        if (completed) {
            if ([activityType isEqualToString:UIActivityTypeSaveToCameraRoll]) {
                msg = TTTFrameworkLocalizedString(@"已保存到相册", nil);
            } else if ([activityType isEqualToString:UIActivityTypeCopyToPasteboard]) {
                msg = TTTFrameworkLocalizedString(@"已拷贝到粘贴板", nil);
            } else if ([activityType isEqualToString:UIActivityTypeAssignToContact]) {
                msg = TTTFrameworkLocalizedString(@"已指定给联系人", nil);
            } else if ([activityType isEqualToString:UIActivityTypeAirDrop]) {
                msg = TTTFrameworkLocalizedString(@"AirDrop 分享成功", nil);
            } else {
                msg = TTTFrameworkLocalizedString(@"分享成功", nil);
            }
        } else {
            // msg = OLocalizedString(@"已取消", nil);
            msg = nil;
        }

        if (completionHandler) {
            completionHandler(completed, msg);
        }
    };

    if (customized) {
        customized(activityViewController);
    }

    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
