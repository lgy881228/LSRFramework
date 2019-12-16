//
//  TTTFrameworkResourcesLoader.h
//  TTTFramework
//
//  Created by jia on 2019/7/22.
//

#import <Foundation/Foundation.h>

@interface TTTFrameworkResourcesLoader : NSObject

+ (NSBundle *)frameworkBundle;

+ (UIImage *)imageNamed:(NSString *)imageName inAssets:(NSString *)assetsName;

@end
