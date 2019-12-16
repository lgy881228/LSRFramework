//
//  TTTFrameworkResourcesLoader.m
//  TTTFramework
//
//  Created by jia on 2019/7/22.
//

#import "TTTFrameworkResourcesLoader.h"

NSString *const TTTFrameworkResourcesBundleName = @"TTTFramework";

@implementation TTTFrameworkResourcesLoader

+ (NSBundle *)frameworkBundle
{
    NSString *bundleName = TTTFrameworkResourcesBundleName;
    
    NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [podBundle pathForResource:bundleName ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

+ (UIImage *)imageNamed:(NSString *)imageName inAssets:(NSString *)assetsName
{
    NSBundle *bundle = [self frameworkBundle];
    
    if (bundle) {
        // NSLog(@"Testing Framework 里bundle path: %@", [libBundle resourcePath]);
        
        NSString *path = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xcassets", assetsName]];
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.imageset", imageName]];
        path = [path stringByAppendingPathComponent:imageName];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        
        // NSLog(@"Testing Framework image size: %f, %f", image.size.width, image.size.height);
        return image;
    }
    return nil;
}

@end
