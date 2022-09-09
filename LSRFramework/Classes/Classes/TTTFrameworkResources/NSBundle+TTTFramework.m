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

#import "NSBundle+TTTFramework.h"
#import "CTAssetsPickerController.h"

#ifdef CTAssetsPickerInFramework
#import "TTTFrameworkResources.h"
#endif

@implementation NSBundle (TTTFramework)

#ifdef CTAssetsPickerInFramework

+ (NSString *)ctassetsPickerLocalizedStringWithKey:(NSString *)key comment:(NSString *)comment
{
    NSBundle *libBundle = [TTTFrameworkResources frameworkBundle];
    NSString *currentLanguage = [TTTFrameworkResources currentLanguage];
    
    NSString *path = [libBundle pathForResource:@"CTAssetsPicker" ofType:@"strings" inDirectory:nil forLocalization:currentLanguage];
    NSDictionary *tableContent = path ? [NSDictionary dictionaryWithContentsOfFile:path] : nil;
    if (tableContent) {
        NSString *content = tableContent[key];
        if (content) {
            return content;
        }
    }
    return key;
}

+ (NSString *)tttFrameworkLocalizedStringWithKey:(NSString *)key comment:(NSString *)comment
{
    NSBundle *libBundle = [TTTFrameworkResources frameworkBundle];
    NSString *currentLanguage = [TTTFrameworkResources currentLanguage];
    
    NSString *path = [libBundle pathForResource:@"TTTFramework" ofType:@"strings" inDirectory:nil forLocalization:currentLanguage];
    NSDictionary *tableContent = path ? [NSDictionary dictionaryWithContentsOfFile:path] : nil;
    if (tableContent) {
        NSString *content = tableContent[key];
        if (content) {
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
