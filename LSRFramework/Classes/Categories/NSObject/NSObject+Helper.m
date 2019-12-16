//
//  NSObject+Helper.m
//  TTTFramework
//
//  Created by Frank.he on 16/1/4.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "NSObject+Helper.h"

@implementation NSObject (Helper)

- (id)CheckError
{
    if ([self isKindOfClass:[NSNull class]] || !self)
        return [[NSArray alloc] init];
    else
        return self;
}

- (NSString *)stringObject
{
    return [NSString stringWithFormat:@"%@", (self && ![self isKindOfClass:[NSNull class]]) ? self : @""];
}

- (NSString *)documentDirectory
{
    return [NSObject documentDirectory];
}

+ (NSString *)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}

+ (BOOL)archive:(id)object toDocumentDirectory:(NSString *)fileName
{
    return [self archive:object toDirectory:[[self documentDirectory] stringByAppendingPathComponent:fileName]];
}

+ (BOOL)archive:(id)object toDirectory:(NSString *)directory
{
    BOOL success = [NSKeyedArchiver archiveRootObject:object toFile:directory];
    if (!success)
    {
        NSLog(@">>>archive failed!!!");
    }
    return success;
}

+ (id)unarchiveFromDocumentDirectory:(NSString *)fileName
{
    return [self unarchiveFromDirectory:[[self documentDirectory] stringByAppendingPathComponent:fileName]];
}

+ (id)unarchiveFromDirectory:(NSString *)directory
{
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:directory];
    
    return obj;
}

#pragma mark Delay Perform
+ (void)delaySeconds:(float)seconds perform:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@end
