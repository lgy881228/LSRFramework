//
//  LoadingView.m
//  ennew
//
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "LoadingView.h"

#if UIViewLoadingPromptEnabled
#import "UIColor+Extension.h"

#define kDispaceLeft 54
#define kHorizonalSpacing 10

#define kActivityWith 20
#define kActivityHeigth 20

#define kLoadingViewColor RGBCOLOR(93, 93, 93)

#define kLoadingViewBackGroundColor RGBCOLOR(246, 246, 246)

@interface LoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, weak) UIView *superView;
@end

@implementation LoadingView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (instancetype)initWithSize:(CGSize)size
{
    CGRect superViewBounds;
    superViewBounds.origin = CGPointMake(0.0f, 0.0f);
    superViewBounds.size = size;
    
    if (self = [self initWithFrame:superViewBounds])
    {
        self.hidden = YES;
        
        UIActivityIndicatorView *activityIndicatoyView = [[UIActivityIndicatorView alloc] init];
        activityIndicatoyView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.activityIndicatorView = activityIndicatoyView;
        [self addSubview:self.activityIndicatorView];
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [loadLabel setFont:[UIFont systemFontOfSize:15]];
        [loadLabel setTextColor:kLoadingViewColor];
        self.textLabel = loadLabel;
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)showLoadingText:(NSString *)text inView:(UIView *)superView
{
    if (self.superview)
    {
        [self removeFromSuperview];
    }
    
    self.superView = superView;
    
    if (!text) text = @"";
    
    self.hidden = NO;
    [self.textLabel setText:text];
    [self addSubview:self.textLabel];
    
    [self.superView addSubview:self];
    [self.superView bringSubviewToFront:self];
    [self.activityIndicatorView startAnimating];
}

- (void)hide
{
    if (self.superview)
    {
        [self removeFromSuperview];
    }
    
    if ([self.activityIndicatorView isAnimating])
    {
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (![self.textLabel.text isEqualToString:@""])
    {
        // 有文字
        CGSize lableSize = [self labelTextSize:self.textLabel];
        
        CGRect subRect = CGRectZero;
        subRect.origin.x = (CGRectGetWidth(self.bounds) - kActivityWith - kHorizonalSpacing - lableSize.width) / 2.0;
        subRect.origin.y = (CGRectGetHeight(self.bounds) - kActivityHeigth) / 2.0;
        subRect.size.width = kActivityWith;
        subRect.size.height = kActivityHeigth;
        self.activityIndicatorView.frame = subRect;
        
        subRect.origin.x = CGRectGetMaxX(self.activityIndicatorView.frame) + kHorizonalSpacing;
        subRect.origin.y = (CGRectGetHeight(self.bounds) - lableSize.height) / 2.0;
        subRect.size = lableSize;
        
        self.textLabel.frame = subRect;
    }
    else
    {
        // 没有文字
        CGRect subRect = CGRectZero;
        subRect.origin.x = (CGRectGetWidth(self.bounds) - kActivityWith) / 2.0;
        subRect.origin.y = (CGRectGetHeight(self.bounds) - kActivityHeigth) / 2.0;
        subRect.size.width = kActivityWith;
        subRect.size.height = kActivityHeigth;
        self.activityIndicatorView.frame = subRect;
    }
}

#pragma mark - Label Content Size
- (CGSize)labelTextSize:(UILabel *)label
{
    if (!label.text)
    {
        return self.bounds.size;
    }
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize textSize;
    CGSize maximumLabelSize = CGSizeMake(CGRectGetWidth(self.bounds), MAXFLOAT);
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    // NSStringDrawingTruncatesLastVisibleLine: 如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略。
    textSize = [label.text boundingRectWithSize:maximumLabelSize
                                        options:(NSStringDrawingTruncatesLastVisibleLine
                                                 | NSStringDrawingUsesLineFragmentOrigin
                                                 | NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName : label.font,
                                                  NSParagraphStyleAttributeName : paragraphStyle}
                                        context:nil].size;
    textSize.width = ceil(textSize.width);
    textSize.height = ceil(textSize.height);
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = label.lineBreakMode;
        paragraphStyle.alignment = label.textAlignment;
        
        // NSStringDrawingTruncatesLastVisibleLine: 如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略。
        textSize = [label.text boundingRectWithSize:maximumLabelSize
                                           options:(NSStringDrawingTruncatesLastVisibleLine
                                                    | NSStringDrawingUsesLineFragmentOrigin
                                                    | NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName : label.font,
                                                     NSParagraphStyleAttributeName : paragraphStyle}
                                           context:nil].size;
        textSize.width = ceil(textSize.width);
        textSize.height = ceil(textSize.height);
    }
    else
    {
        //[self setNumberOfLines:0];
        //[self setLineBreakMode:NSLineBreakByWordWrapping];
        
        //CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,kMaxLabelHeight);
        textSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    }
#endif
    
    return textSize;
    
#if 0
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0f)
    {
        CGSize size = [self.text boundingRectWithSize:self.bounds.size withTextFont:self.font withLineSpacing:5];
        return size;
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text];
        // self.attributedText = attrStr;
        NSRange range = NSMakeRange(0, attrStr.length);
        NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];   // 获取该段attributedString的属性字典
        
        // 计算文本的大小
        CGSize textSize = [self.text boundingRectWithSize:self.bounds.size // 用于计算文本绘制时占据的矩形块
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                               attributes:dic        // 文字的属性
                                                  context:nil].size;
        
        return textSize;
    }
    else
    {
        CGSize size = [self.text sizeWithFont:self.font constrainedToSize:self.bounds.size lineBreakMode:self.lineBreakMode];
        return size;
    }
#endif
}
@end
#endif
