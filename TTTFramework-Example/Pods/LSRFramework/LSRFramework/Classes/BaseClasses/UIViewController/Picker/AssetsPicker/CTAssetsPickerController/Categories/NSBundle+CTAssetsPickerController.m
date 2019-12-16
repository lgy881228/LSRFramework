/*
 
 MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "NSBundle+CTAssetsPickerController.h"
#import "CTAssetsPickerController.h"
#import <objc/runtime.h>

#ifdef CTAssetsPickerInFramework
#import "TTTFrameworkResourcesLoader.h"
#import "NSObject+Swizzle.h"
#endif

@implementation NSBundle (CTAssetsPickerController)

#ifdef CTAssetsPickerInFramework
+ (void)setCurrentLanguage:(NSString *)currentLanguage
{
    // 因为类名不同，self也就是不用的类名，数据会绑定到不同的类上，这里只想唯一绑定一次，不能用self，全用UIViewController
    objc_setAssociatedObject(NSBundle.class, @selector(currentLanguage), currentLanguage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSString *)currentLanguage
{
    // 因为类名不同，self也就是不用的类名，数据会绑定到不同的类上，这里只想唯一绑定一次，不能用self，全用UIViewController
    return objc_getAssociatedObject(NSBundle.class, @selector(currentLanguage));
}

+ (NSString *)ctassetsPickerLocalizedStringWithKey:(NSString *)key comment:(NSString *)comment
{
    NSBundle *libBundle = [TTTFrameworkResourcesLoader frameworkBundle];
    
    NSString *currentLanguage = self.currentLanguage;
    if (!currentLanguage)
    {
        NSArray *arLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        currentLanguage = (NSString *)[arLanguages objectAtIndex:0];
        if (currentLanguage && [currentLanguage hasPrefix:@"zh"])
        {
            if ([currentLanguage rangeOfString:@"Hans"].location != NSNotFound)
            {
                // 简体中文
                // language = [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"zh-Hans-CN" : @"zh-Hans"; // 这是读取的系统语言
                currentLanguage = @"zh-Hans"; // 这是本工程的语言包
            }
            else
            {
                // zh-Hant\zh-HK\zh-TW\zh-MO\zh-SG
                currentLanguage = @"zh-Hant"; // 繁體中文
            }
        }
        self.currentLanguage = currentLanguage;
    }
    
    NSString *path = [libBundle pathForResource:@"CTAssetsPicker" ofType:@"strings" inDirectory:nil forLocalization:currentLanguage];
    NSDictionary *tableContent = path ? [NSDictionary dictionaryWithContentsOfFile:path] : nil;
    if (tableContent)
    {
        NSString *content = tableContent[key];
        if (content)
        {
            return content;
        }
    }
    return key;
}
#else

+ (NSBundle *)ctassetsPickerBundle
{
    return [NSBundle bundleWithPath:[NSBundle ctassetsPickerBundlePath]];
}

+ (NSString *)ctassetsPickerBundlePath
{
    return [[NSBundle bundleForClass:[CTAssetsPickerController class]]
            pathForResource:@"CTAssetsPickerController" ofType:@"bundle"];
}
#endif

@end
