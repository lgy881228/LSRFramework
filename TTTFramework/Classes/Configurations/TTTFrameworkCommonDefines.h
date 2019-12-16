//
//  TTTFrameworkCommonDefines.h
//  TTTFramework
//
//  Created by jia on 15/11/18.
//  Copyright © 2015年 www.enn.cn. All rights reserved.
//

#ifndef TTTFrameworkCommonDefines_h
#define TTTFrameworkCommonDefines_h

#define APP_VERSION            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUILD_VERSION      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APP_NAME               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define APP_BUNDLE_ID          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

#define SYSTEM_VERSION         [[[UIDevice currentDevice] systemVersion] floatValue]

#define NSStringFromInt(intValue)               [NSString stringWithFormat:@"%d", (int)(intValue)]
#define NSStringFromNSInteger(integerValue)     [NSString stringWithFormat:@"%ld", (long)(integerValue)]
#define NSStringFromNSUInteger(uintegerValue)   [NSString stringWithFormat:@"%lu", (unsigned long)(uintegerValue)]
#define NSStringFromLongLongInt(llInt)          [NSString stringWithFormat:@"%lld", llInt]
#define NSStringFromUnsignedLongLongInt(ullInt) [NSString stringWithFormat:@"%llu", ullInt]
#define NSStringFromCGFloat(floatValue)         [[NSNumber numberWithFloat:floatValue] stringValue]
#define NSStringFromDouble(doubleValue)         [[NSNumber numberWithDouble:doubleValue] stringValue]

#define RGBCOLOR(r,g,b)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBSCOLOR(sameValue)   [UIColor colorWithRed:(sameValue)/255.0 green:(sameValue)/255.0 blue:(sameValue)/255.0 alpha:1]
#define RGBVCOLOR(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)\
((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif /* TTTFrameworkCommonDefines_h */
