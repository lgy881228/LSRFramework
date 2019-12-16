//
//  NSString+Encoding.m
//  TTTFramework
//
//  Created by jia on 2016/12/30.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "NSString+Encoding.h"
#include "uchardet.h"

#define NUMBER_OF_SAMPLES   (2048)

@implementation NSString (Encoding)

- (NSString *)contentTextCharSet
{
    FILE *file;
    char buf[NUMBER_OF_SAMPLES];
    size_t len;
    uchardet_t ud;
    
    /* 打开被检测文本文件，并读取一定数量的样本字符 */
    file = fopen(self.UTF8String, "rt");
    if (file == NULL)
    {
        printf("文件打开失败！\n");
        return nil;
    }
    len = fread(buf, sizeof(char), NUMBER_OF_SAMPLES, file);
    fclose(file);
    
    ud = uchardet_new();
    if(uchardet_handle_data(ud, buf, len) != 0)
    {
        printf("分析编码失败！\n");
        return nil;
    }
    uchardet_data_end(ud);
    printf("文本的编码方式是%s。\n", uchardet_get_charset(ud));
    
    const char *encode = uchardet_get_charset(ud);
    
    uchardet_delete(ud);
    
    return [[NSString alloc] initWithCString:encode encoding:NSUTF8StringEncoding];
}

- (NSStringEncoding)contentTextEncoding
{
    CFStringEncoding cfEncode = 0;
    NSString *encode = [self contentTextCharSet];
    if (encode)
    {
        if ([encode isEqualToString:@"gb18030"])
        {
            cfEncode = kCFStringEncodingGB_18030_2000;
        }
        else if([encode isEqualToString:@"Big5"])
        {
            cfEncode = kCFStringEncodingBig5;
        }
        else if([encode isEqualToString:@"UTF-8"])
        {
            cfEncode = kCFStringEncodingUTF8;
        }
        else if([encode isEqualToString:@"Shift_JIS"])
        {
            cfEncode = kCFStringEncodingShiftJIS;
        }
        else if([encode isEqualToString:@"windows-1252"])
        {
            cfEncode = kCFStringEncodingWindowsLatin1;
        }
        else if([encode isEqualToString:@"x-euc-tw"])
        {
            cfEncode = kCFStringEncodingEUC_TW;
        }
        else if([encode isEqualToString:@"EUC-KR"])
        {
            cfEncode = kCFStringEncodingEUC_KR;
        }
        else if([encode isEqualToString:@"EUC-JP"])
        {
            cfEncode = kCFStringEncodingEUC_JP;
        }
        else
        {
            // do nothing
        }
    }
    
    return CFStringConvertEncodingToNSStringEncoding(cfEncode);
}

@end
