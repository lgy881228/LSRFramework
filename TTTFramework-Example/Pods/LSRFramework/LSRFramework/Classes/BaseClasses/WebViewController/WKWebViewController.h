//
//  WKWebViewController.h
//  TTTFramework
//
//  Created by jia on 2017/7/14.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol WKWebViewLayoutDelegate <NSObject>
@optional
- (void)customizeWebViewConstraints;
@end

@protocol WKWebViewLoadDataDelegate <NSObject>
- (BOOL)loadData;
- (BOOL)validateRequestURL:(NSURL *)requestURL;
@end

@protocol WKWebViewFullScreenDelegate <NSObject>
@optional
- (void)webViewDidEnterFullScreen;
- (void)webViewDidExitFullScreen;
@end

@interface WKWebViewController : UIViewController <WKNavigationDelegate, WKWebViewLayoutDelegate, WKWebViewLoadDataDelegate, WKWebViewFullScreenDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSString *fileURL;
@property (nonatomic, strong) NSString *htmlString;

@property (nonatomic, readwrite) BOOL autoLayoutEnabled;

// this class always return YES, subclass must to override, not using:(.customizedEnabled = ?).
- (BOOL)customizedEnabled;

- (BOOL)isLocalFile;

#pragma mark - tmp file directory
+ (NSURL *)localFileLoadingBugFixingTemporaryDirectory;

@end
