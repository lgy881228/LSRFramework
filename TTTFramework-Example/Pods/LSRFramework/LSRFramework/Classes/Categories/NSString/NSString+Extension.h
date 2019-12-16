//
//  NSString+Extension.h
//  MyBox
//
//  Created by jiajunbo on 14-8-20.
//  Copyright (c) 2014年 OrangeTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSAttributedString)

/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

//计算文本的size
- (CGSize)boundingRectWithSize:(CGSize)size
                  withTextFont:(UIFont *)font
               withLineSpacing:(CGFloat)lineSpacing;

//sting转AttributedString
- (NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                 withLineSpacing:(CGFloat)lineSpacing;
@end

@interface NSString (UTI)

- (NSString *)fileUTI;
- (NSString *)fileMimeType;

@end

@interface NSString (Substring)

- (NSString *)removeSubstring:(NSString *)substring;

@end

