//
//  UIViewController+Share.h
//  Folder
//
//  Created by jia on 2017/2/7.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> // for E-Mail

@interface UIViewController (Share)
<MFMessageComposeViewControllerDelegate,
MFMailComposeViewControllerDelegate,
UIDocumentInteractionControllerDelegate>

- (void)sendMailWithSubject:(NSString *)subject
                messageBody:(NSString *)mailBody
                attachments:(NSArray *)attachmentData
               toRecipients:(NSArray *)recepters;

- (void)shareItems:(NSArray<id<NSSecureCoding>> *)items customized:(void (^)(UIActivityViewController *activityViewController))customized completion:(void (^)(BOOL completed, NSString *message))completionHandler;

@end
