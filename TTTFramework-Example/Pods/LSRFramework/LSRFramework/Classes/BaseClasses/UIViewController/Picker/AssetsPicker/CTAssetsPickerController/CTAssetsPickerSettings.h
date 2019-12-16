//
//  CTAssetsPickerSettings.h
//  TTTFramework
//
//  Created by jia on 2019/11/21.
//

#import <Foundation/Foundation.h>

@interface CTAssetsPickerSettings : NSObject

+ (CTAssetsPickerSettings *)defaultSettings;

@property (nonatomic, copy) UIColor * (^backgroundColor)(void);
@property (nonatomic, copy) UIColor * (^cellSelectedColor)(void);

@end
