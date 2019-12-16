//
//  NSObject+Helper.h
//  TTTFramework
//
//  Created by Frank.he on 16/1/4.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Helper)

- (id)CheckError;

- (NSString *)stringObject;

// 获取Documents目录路径
- (NSString *)documentDirectory;
+ (NSString *)documentDirectory;

// 文件归档
+ (BOOL)archive:(id)object toDocumentDirectory:(NSString *)fileName;
+ (BOOL)archive:(id)object toDirectory:(NSString *)directory;

// 文件解归档
+ (id)unarchiveFromDocumentDirectory:(NSString *)fileName;
+ (id)unarchiveFromDirectory:(NSString *)directory;

#pragma mark Delay Perform
+ (void)delaySeconds:(float)seconds perform:(dispatch_block_t)block;

@end
