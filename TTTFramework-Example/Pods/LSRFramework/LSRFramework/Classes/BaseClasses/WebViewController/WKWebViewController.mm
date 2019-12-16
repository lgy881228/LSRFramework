//
//  WKWebViewController.m
//  TTTFramework
//
//  Created by jia on 2017/7/14.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "WKWebViewController.h"
#import "UIViewController+.h"
#import "NSString+Encoding.h"
#import "TTTFrameworkCommonDefines.h"
#import <MobileCoreServices/UTType.h>
#import <Masonry/Masonry.h>

#define RotationObservingForVideoEnabled 0

@interface WKWebViewController ()
@property (nonatomic, readwrite) BOOL statusBarHidden;
@end

@implementation WKWebViewController

- (WKWebView *)webView
{
    if (_webView && ![_webView isKindOfClass:WKWebView.class])
    {
        _webView = nil;
    }
    
    if (!_webView)
    {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (BOOL)customizedEnabled
{
    return YES;
}

#pragma mark - Life Cycle
- (void)dealloc
{
    self.webView.navigationDelegate = nil;
    self.webView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    if (self.autoLayoutEnabled)
    {
        if ([self respondsToSelector:@selector(customizeWebViewConstraints)])
        {
            [self customizeWebViewConstraints];
        }
        else
        {
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self.view);
            }];
        }
    }
    else
    {
        self.webView.frame = self.view.bounds;
    }
    
    self.webView.navigationDelegate = self; // 需要实现 <span style="font-family: monospace; white-space: pre; background-color: rgb(240, 240, 240);">WKNavigationDelegate </span>
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startFullScreenObserving];
    
    if (self.isFirstTimeViewAppear)
    {
        // 加载数据
        [self loadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopFullScreenObserving];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Inner Methods
- (BOOL)loadData
{
    if (self.fileURL)
    {
        // 本地有 则用本地的
        if (self.isLocalFile)
        {
            return [self loadLocalDocument];
        }
        else
        {
            return [self loadWebPage];
        }
    }
    else if (self.htmlString)
    {
        return [self loadHTMLString];
    }
    else
    {
        // do nothing
        return NO;
    }
}

- (void)reloadData
{
    [self.webView reload];
}

- (BOOL)loadLocalDocument
{
    NSURL *url = [NSURL fileURLWithPath:self.fileURL];
    if (!url)
    {
        return NO;
    }
    
    NSString *mimeType = [self fileMimeType:self.fileURL];
    if (mimeType)
    {
        if ([mimeType hasPrefix:@"text/"]) // txt file
        {
            if ([mimeType hasPrefix:@"text/plain"])
            {
#if 0
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                // NSStringEncoding encodeing = NSUTF8StringEncoding;
                NSStringEncoding encodeing = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *body = [[NSString alloc] initWithData:data encoding:encodeing];
                
                // 带编码头的如utf-8等，这里会识别出来
                // NSString *body = [NSString stringWithContentsOfFile:self.fileURL usedEncoding:&useEncodeing error:nil];
                // 识别不到，按GBK编码再解码一次.这里不能先按GB18030解码，否则会出现整个文档无换行bug。
                if (!body)
                {
                    body = [NSString stringWithContentsOfFile:self.fileURL encoding:0x80000632 error:nil];
                }
                // 还是识别不到，按GB18030编码再解码一次.
                if (!body)
                {
                    body = [NSString stringWithContentsOfFile:self.fileURL encoding:0x80000631 error:nil];
                }
                
                // 展现
                if (body)
                {
                    [self.webView loadHTMLString:body baseURL: nil];
                }
                else
                {
                    NSString *urlString = [[NSBundle mainBundle] pathForAuxiliaryExecutable:self.fileURL];
                    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                    NSURL *requestUrl = [NSURL URLWithString:urlString];
                    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
                    [self.webView loadRequest:request];
                    
                }
#else
                NSData *txtData = [NSData dataWithContentsOfFile:self.fileURL];
                NSString *encoding = self.fileURL.contentTextCharSet;
                
                [self.webView loadData:txtData MIMEType:mimeType characterEncodingName:encoding baseURL:[NSURL fileURLWithPath:NSBundle.mainBundle.bundlePath]];
#endif
            }
            else
            {
                // 加载文件
                if (SYSTEM_VERSION >= 9.0)
                {
                    [self.webView loadFileURL:url allowingReadAccessToURL:url];
                }
                else
                {
                    [self loadFileURLBeforeIOS9:url];
                }
            }
        }
        else
        {
            // 加载文件
            if (SYSTEM_VERSION >= 9.0)
            {
                [self.webView loadFileURL:url allowingReadAccessToURL:url];
            }
            else
            {
                [self loadFileURLBeforeIOS9:url];
            }
        }
    }
    else
    {
        // format txt to html, then load html string.
        NSData *txtData = [NSData dataWithContentsOfURL:url];
        NSString *txtString = [[NSString alloc] initWithData:txtData encoding:NSUTF8StringEncoding];
        NSString* htmlString = [NSString stringWithFormat:
                                @"<HTML>"
                                "<head>"
                                "<title>Text View</title>"
                                "</head>"
                                "<BODY>"
                                "<pre>"
                                "%@"
                                "</pre>"
                                "</BODY>"
                                "</HTML>",
                                txtString];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
    
    return YES;
}

- (BOOL)loadWebPage
{
    // [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.fileURL]]];
    
    // 使用默认缓存策略
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.fileURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    [self.webView loadRequest:request];
    
    return YES;
}

- (BOOL)loadHTMLString
{
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    
    return YES;
}

- (NSString *)fileMimeType:(NSString *)fileNameOrPath
{
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[fileNameOrPath pathExtension], NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (uti, kUTTagClassMIMEType);
    
    return (__bridge NSString *)(mimeType);
}

//// API is expired.
//- (NSString *)getMimeType:(NSString *)fileAbsolutePath error:(NSError *)error
//{
//    NSString *fullPath = [fileAbsolutePath stringByExpandingTildeInPath];
//    NSURL *fileUrl = [NSURL fileURLWithPath:fullPath];
//    NSURLRequest *fileUrlRequest = [NSURLRequest requestWithURL:fileUrl];
//    NSURLResponse *response = nil;
//    [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];
//    return [response MIMEType];
//}

- (BOOL)isLocalFile
{
    return [self.fileURL isAbsolutePath];
}

- (void)loadFileURLBeforeIOS9:(NSURL *)url
{
    // iOS8. Things can be workaround-ed
    // Brave people can do just this
    // fileURL = try! pathForBuggyWKWebView8(fileURL)
    // webView.loadRequest(NSURLRequest(URL: fileURL))
    
    NSURL *fileURL = [self fileURLForBuggyWKWebView8:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [self.webView loadRequest:request];
}

// 将文件copy到tmp目录
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL
{
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error])
    {
        return nil;
    }
    
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[self class] localFileLoadingBugFixingTemporaryDirectory];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

+ (NSURL *)localFileLoadingBugFixingTemporaryDirectory
{
    return [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
}

#pragma mark - WKNavigationDelegate
- (BOOL)validateRequestURL:(NSURL *)requestURL
{
    return YES;
}

#pragma mark - WKNavigationDelegate
// 接收到服务器跳转请求之后调用 (服务器端redirect)，不一定调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 1 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    
    if ([self validateRequestURL:url])
    {
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        // 不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self showLoading];
}

// 3 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    // navigationAction.request.URL.host
    NSLog(@"WKwebView ... didCommitNavigation ..");
    
    [NSThread delaySeconds:0.1f perform:^{
        
        [self hideLoading];
    }];
}

// 5a 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (!self.isLocalFile && !self.navigationBarTitle && webView.title)
    {
        self.navigationBarTitle = webView.title;
    }
    
    [NSThread delaySeconds:0.1f perform:^{
        
        [self hideLoading];
    }];
    
    // 屏蔽运营商广告 开始
    [webView evaluateJavaScript:@"document.documentElement.getElementsByClassName('c60_fbar_buoy ng-isolate-scope')[0].style.display = 'none'" completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        
        if (!error)
        {
            // succeed
        }
    }];
    // [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementById('tlbstoolbar')[0].style.display = 'none'"];
    // 屏蔽运营商广告 结束
    
    //    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    //    NSLog(@"%@", currentURL);
}

// 5b 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"加载失败");
    
    [self hideLoading];
    
    if (self.isLocalFile) return;
    
    if ([self isNoNetwork])
    {
        [self promptMessage:kNetworkUnavailable];
    }
    else
    {
        [self promptMessage:kLoadDataFailed];
    }
}

#pragma mark - Full Screen
- (void)startFullScreenObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil]; // 进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil]; // 退出全屏
}

- (void)stopFullScreenObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)enterFullScreen
{
    if (self.statusBarAppearanceByViewController)
    {
        self.statusBarHidden = self.prefersStatusBarHidden;
    }
    else
    {
        self.statusBarHidden = UIApplication.sharedApplication.isStatusBarHidden;
    }
    
    if ([self respondsToSelector:@selector(webViewDidEnterFullScreen)])
    {
        [self webViewDidEnterFullScreen];
    }
}

- (void)exitFullScreen
{
    if (self.statusBarAppearanceByViewController)
    {
        self.prefersStatusBarHidden = self.statusBarHidden;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:self.statusBarHidden withAnimation:UIStatusBarAnimationNone];
    }
    
    [self statusBarStyleToFit];
    
    if ([self respondsToSelector:@selector(webViewDidExitFullScreen)])
    {
        [self webViewDidExitFullScreen];
    }
}

- (BOOL)statusBarAppearanceByViewController
{
    NSNumber *viewControllerBased = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
    if (viewControllerBased && !viewControllerBased.boolValue)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#if RotationObservingForVideoEnabled
- (void)retainStatusBar
{
    if (self.statusBarAppearanceByViewController)
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
}

#pragma mark iOS 8 Prior
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.view layoutSubviews];
    
    [self retainStatusBar];
}

#pragma mark ios 8 Later
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        [self retainStatusBar];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        //
    }];
}
#endif

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
