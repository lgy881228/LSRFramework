//
//  Reachability+Extension.m
//  LeSearchSDK
//
//  Created by JiaJunbo on 15/4/18.
//  Copyright (c) 2015年 Leso. All rights reserved.
//

#import "Reachability+Extension.h"

@implementation LSRReachability (Extension)

+ (NSString *)currentNetType
{
    if ([[LSRReachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN)
    {
        return @"3g";
    }
    else if ([[LSRReachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi)
    {
        return @"wifi";
    }
    else
    {
        return @"none";
    }
}

@end
