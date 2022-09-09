//
//  TTTFrameworkResources.h
//  TTTFramework
//
//  Created by jia on 2019/7/22.
//

#import <Foundation/Foundation.h>

@interface TTTFrameworkResources : NSObject

+ (NSBundle *)frameworkBundle;

+ (NSString *)currentLanguage;

+ (UIImage *)imageNamed:(NSString *)imageName inAssets:(NSString *)assetsName;

@end
