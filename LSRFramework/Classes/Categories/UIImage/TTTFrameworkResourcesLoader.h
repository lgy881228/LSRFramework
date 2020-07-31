//
//  TTTFrameworkResourcesLoader.h
//  TTTFramework
//
//  Created by jia on 2019/7/22.
//

#import <Foundation/Foundation.h>

@interface TTTFrameworkResourcesLoader : NSObject

+ (NSBundle *)frameworkBundleWithBundleName:(NSString *)bundleName;

+ (UIImage *)imageNamed:(NSString *)imageName inAssets:(NSString *)assetsName bundleName:(NSString *)bundleName;

@end
