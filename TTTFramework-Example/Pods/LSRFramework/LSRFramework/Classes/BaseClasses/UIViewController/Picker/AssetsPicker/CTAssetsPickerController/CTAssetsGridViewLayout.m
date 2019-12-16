/*
 
 MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "CTAssetsGridViewLayout.h"

@implementation CTAssetsGridViewLayout

- (instancetype)initWithContentSize:(CGSize)contentSize traitCollection:(UITraitCollection *)traits
{
    if (self = [super init])
    {
        CGFloat scale = traits.displayScale;
        NSInteger numberOfColumns = [self numberOfColumnsForTraitCollection:traits];
        
        const CGFloat onePixel = 1 / scale;
        CGFloat spacing = onePixel;
        spacing = 1;
        CGFloat length;
        CGFloat left;
        CGFloat right;
        [self computeItemLength:&length interitemSpacing:&spacing insetLeft:&left insetRight:&right
                       withWidth:contentSize.width scale:scale columns:numberOfColumns spacing:spacing];
        

        // left / right insets (in point, 2 decimal)
        left    = floorf(left / scale * 100) / 100;
        right   = floorf(right / scale * 100) / 100;
        
        // item length (in point, 2 decimal)
        length  = floorf(length / scale * 100) / 100;
        
        // spacing is as small as possible
        self.minimumInteritemSpacing = spacing;
        self.minimumLineSpacing = spacing;
        self.itemSize = CGSizeMake(length, length);
        
        // collection view 's inset
        self.sectionInset = UIEdgeInsetsMake(0, left, 0, right);
        
        // collection view 's footer
        self.footerReferenceSize = CGSizeMake(contentSize.width, floor(length * 2/3));
    }
    
    return self;
}

- (void)computeItemLength:(CGFloat *)outputLength interitemSpacing:(CGFloat *)outputSpacing insetLeft:(CGFloat *)outputLeft insetRight:(CGFloat *)outputRight withWidth:(const CGFloat)width scale:(const CGFloat)scale columns:(const NSInteger)numberOfColumns spacing:(const CGFloat)inputSpacing
{
    // total spaces between items (in pixel)
    CGFloat spaces  = inputSpacing * (numberOfColumns - 1);
    
    // item length (in pixel)
    CGFloat length  = (scale * (width - spaces)) / numberOfColumns;
    
    // remaining spaces (in pixel) after rounding the length to integer
    CGFloat insets  = (length - floor(length)) * numberOfColumns;
    
    // round the length to integer (in pixel)
    length = floor(length);
    
    // divide insets to two
    CGFloat left = insets / 2;
    CGFloat right = insets / 2;
    
    // adjust if insets is odd
    if (fmodf(insets, 2.0) == 1.0f)
    {
        [self computeItemLength:outputLength interitemSpacing:outputSpacing insetLeft:outputLeft insetRight:outputRight withWidth:width scale:scale columns:numberOfColumns spacing:(inputSpacing + inputSpacing)];
    }
    else
    {
        *outputLength = length;
        *outputSpacing = inputSpacing;
        *outputLeft = left;
        *outputRight = right;
    }
}

//- (NSUInteger)thumbnailSize:(CGSize *)outputSize itemSpacing:(CGFloat *)outputSpacing toFitWidth:(const CGFloat)inputWidth columns:(const NSUInteger)inputColumns minItemSpacing:(CGFloat)minItemSpacing
//{
//    NSUInteger itemWidth = 0;
//    if ([self itemWidth:&itemWidth itemSpacing:outputSpacing toFitWidth:inputWidth columns:inputColumns recursive:YES])
//    {
//        // 能够满足要求
//        *outputSize = CGSizeMake(itemWidth, itemWidth);
//        return 0;
//    }
//    else
//    {
//        // 根本满足不了要求，那只能在tableview两侧加空白
//        *outputSpacing = minItemSpacing;
//        [self itemWidth:&itemWidth itemSpacing:outputSpacing toFitWidth:inputWidth columns:inputColumns recursive:NO];
//        *outputSize = CGSizeMake(itemWidth, itemWidth);
//        
//        return (inputWidth - itemWidth*inputColumns - *outputSpacing*(inputColumns - 1))/2;
//    }
//}
//
//- (BOOL)itemWidth:(NSUInteger *)itemWidth itemSpacing:(CGFloat *)itemSpacing  toFitWidth:(const NSUInteger)width columns:(const NSUInteger)columns recursive:(BOOL)recursive
//{
//    *itemWidth = floor((width - (columns-1)*(*itemSpacing))/columns);
//    
//    if (recursive)
//    {
//        if (width - *itemWidth*columns - *itemSpacing*(columns - 1))
//        {
//            if (*itemSpacing < kThumbnailMaxSpacing)
//            {
//                *itemSpacing += 1;
//                return [self itemWidth:itemWidth itemSpacing:itemSpacing toFitWidth:width columns:columns recursive:YES];
//            }
//            else
//            {
//                return NO;
//            }
//        }
//    }
//    
//    return YES;
//}


- (NSInteger)numberOfColumnsForTraitCollection:(UITraitCollection *)traits
{
    switch (traits.userInterfaceIdiom) {
        case UIUserInterfaceIdiomPad:
        {
            return 6;
            break;
        }
        case UIUserInterfaceIdiomPhone:
        {
            // iPhone 6+ landscape
            if (traits.horizontalSizeClass == UIUserInterfaceSizeClassRegular)
                return 4;
            // iPhone landscape
            else if (traits.verticalSizeClass == UIUserInterfaceSizeClassCompact)
                return 6;
            // iPhone portrait
            else
                return 4;
            break;
        }
        default:
            return 4;
            break;
    }
}

@end
