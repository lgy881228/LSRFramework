//
//  Reachability+Extension.m
//  LeSearchSDK
//
//  Created by JiaJunbo on 15/4/18.
//  Copyright (c) 2015年 Leso. All rights reserved.
//

#import "Reachability+Extension.h"

@implementation Reachability (Extension)

+ (NSString *)currentNetType
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN)
    {
        return @"3g";
    }
    else if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi)
    {
        return @"wifi";
    }
    else
    {
        return @"none";
    }
}

@end
