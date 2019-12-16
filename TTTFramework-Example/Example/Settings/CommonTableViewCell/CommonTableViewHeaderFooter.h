//
//  CommonTableViewHeaderFooter.h
//  FileBox
//
//  Created by jia on 15/9/23.
//  Copyright © 2015年 OrangeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonTableViewHeaderFooter : UITableViewHeaderFooterView

+ (float)defaultHeight;
+ (float)textingHeight;

- (void)setFont:(UIFont *)titleFont;
- (void)setTitle:(NSString *)title;

@end
