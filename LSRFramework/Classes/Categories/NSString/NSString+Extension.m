//
//  NSString+Extension.m
//  MyBox
//
//  Created by jiajunbo on 14-8-20.
//  Copyright (c) 2014年 OrangeTeam. All rights reserved.
//

#import "NSString+Extension.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreFoundation/CoreFoundation.h>

@implementation NSString (NSAttributedString)

// 返回字符串所占用的尺寸.
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)boundingRectWithSize:(CGSize)size
                  withTextFont:(UIFont *)font
               withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedString = [self attributedStringFromStingWithFont:font withLineSpacing:lineSpacing];
    
    CGRect rect = [attributedString boundingRectWithSize:size
                                                 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 context:nil];
    return rect.size;
}

- (NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                 withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [self length])];
    return attributedStr;
}

@end


@implementation NSString (UTI)

- (NSString *)fileUTI
{
    return [self preferredUTIForExtention:self.pathExtension];
}

- (NSString *)fileMimeType
{
    return [[self class] mimeTypeForFileAtPath:self];
}

- (NSString *)preferredUTIForExtention:(NSString *)ext
{
    // Request the UTI via the file extension
    NSString *theUTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)(ext), NULL);
    return theUTI ?: @"";
}

- (NSString *)preferredUTIForMIMEType:(NSString *)mime
{
    // request the UTI via the file extention
    NSString *theUTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,(__bridge CFStringRef)mime, NULL);
    return theUTI;
}

- (NSString *)extensionForUTI:(NSString *)aUTI
{
    CFStringRef theUTI = (__bridge CFStringRef)aUTI;
    CFStringRef results = UTTypeCopyPreferredTagWithClass(theUTI, kUTTagClassFilenameExtension);
    return (__bridge_transfer NSString *)results;
}

- (NSString *)mimeTypeForUTI:(NSString *)aUTI
{
    CFStringRef theUTI = (__bridge CFStringRef) aUTI;
    CFStringRef results = UTTypeCopyPreferredTagWithClass(theUTI, kUTTagClassMIMEType);
    return (__bridge_transfer NSString *)results;
}

+ (NSString *)mimeTypeForFileAtPath:(NSString *)filePath
{
    NSString *extension = [[[filePath lastPathComponent] pathExtension] lowercaseString];
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (uti, kUTTagClassMIMEType);
    CFRelease(uti);
    
    return (__bridge NSString *)mimeType ?: @"";
}

@end

@implementation NSString (Substring)

- (NSString *)removeSubstring:(NSString *)substring
{
    if ([self rangeOfString:substring].location != NSNotFound)
    {
        NSRange range = [self rangeOfString:substring];
        NSString *leftString = [self substringWithRange:NSMakeRange(0, range.location)];
        NSString *rightString = [self substringWithRange:NSMakeRange(range.location + range.length, (self.length - (range.location + range.length)))];
        return [NSString stringWithFormat:@"%@%@", leftString, rightString];
    }
    return self;
}

@end
