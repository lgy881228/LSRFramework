//
//  TTTFrameworkResources.m
//  TTTFramework
//
//  Created by jia on 2019/7/22.
//

#import "TTTFrameworkResources.h"
#import <objc/runtime.h>

NSString *const TTTFrameworkResourcesBundleName = @"TTTFramework";

@implementation TTTFrameworkResources

+ (NSBundle *)frameworkBundle
{
    NSString *bundleName = TTTFrameworkResourcesBundleName;
    
    NSBundle *podBundle = [NSBundle bundleForClass:self.class];
    NSString *bundlePath = [podBundle pathForResource:bundleName ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

+ (void)setCurrentLanguage:(NSString *)currentLanguage
{
    // 因为类名不同，self也就是不用的类名，数据会绑定到不同的类上，这里只想唯一绑定一次，不能用self，全用UIViewController
    objc_setAssociatedObject(self.class, @selector(currentLanguage), currentLanguage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSString *)currentLanguage
{
    NSString *currentLanguage = objc_getAssociatedObject(self.class, @selector(currentLanguage));
    if (!currentLanguage) {
        currentLanguage = [[NSBundle mainBundle] preferredLocalizations].firstObject;
        if ([currentLanguage hasPrefix:@"en"]) {
            currentLanguage = @"en";
        } else if ([currentLanguage hasPrefix:@"zh"]) {
            if ([currentLanguage rangeOfString:@"Hans"].location != NSNotFound) {
                // 简体中文
                // language = [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"zh-Hans-CN" : @"zh-Hans"; // 这是读取的系统语言
                currentLanguage = @"zh-Hans"; // 这是本工程的语言包
            } else {
                // zh-Hant\zh-HK\zh-TW\zh-MO\zh-SG
                currentLanguage = @"zh-Hant"; // 繁體中文
            }
        } else {
            currentLanguage = @"en";
        }
        self.currentLanguage = currentLanguage;
    }
    return currentLanguage;
}

+ (UIImage *)imageNamed:(NSString *)imageName inAssets:(NSString *)assetsName
{
    NSBundle *bundle = [self frameworkBundle];
    
    if (bundle) {
        // NSLog(@"Testing Framework 里bundle path: %@", [libBundle resourcePath]);
        
        NSString *path = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xcassets", assetsName]];
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.imageset", imageName]];
        path = [path stringByAppendingPathComponent:imageName];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        
        // NSLog(@"Testing Framework image size: %f, %f", image.size.width, image.size.height);
        return image;
    }
    return nil;
}

@end
