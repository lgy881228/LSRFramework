//
//  CTAssetsPickerSettings.m
//  TTTFramework
//
//  Created by jia on 2019/11/21.
//

#import "CTAssetsPickerSettings.h"

@implementation CTAssetsPickerSettings

#pragma mark - Singleton
+ (CTAssetsPickerSettings *)defaultSettings
{
    static CTAssetsPickerSettings *__defaultSettings = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{
        __defaultSettings = [[super allocWithZone:nil] init];
    });
    return __defaultSettings;
}

- (instancetype)init
{
    if (self = [super init]) {
        // init
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (self.class == CTAssetsPickerSettings.class) {
        return self.class.defaultSettings;
    } else {
        return [super allocWithZone:zone];
    }
}

+ (instancetype)alloc
{
    if (self.class == CTAssetsPickerSettings.class) {
        return self.class.defaultSettings;
    } else {
        return [super alloc];
    }
}

+ (instancetype)new
{
    if (self.class == CTAssetsPickerSettings.class) {
        return self.class.defaultSettings;
    } else {
        return [super new];
    }
}

#ifndef OBJC_ARC_UNAVAILABLE
+ (id)copyWithZone:(struct _NSZone *)zone
{
    if (self.class == CTAssetsPickerSettings.class) {
        return self.class.defaultSettings;
    } else {
        return [super copyWithZone:zone];
    }
}

#endif

#pragma mark - Settings
- (UIColor *(^)(void))backgroundColor
{
    if (!_backgroundColor) {
        return ^UIColor * _Nullable{
            return [UIColor whiteColor];
        };
    }
    return _backgroundColor;
}

- (UIColor *(^)(void))cellSelectedColor
{
    if (!_cellSelectedColor) {
        return ^UIColor * _Nullable{
            return [UIColor grayColor];
        };
    }
    return _cellSelectedColor;
}

@end
