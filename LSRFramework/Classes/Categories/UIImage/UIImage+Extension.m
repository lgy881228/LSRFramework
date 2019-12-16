//
//  UIImage+Extension.m
//  乐拍
//
//  Created by junbo jia on 14-7-24.
//  Copyright (c) 2014年 Letv. All rights reserved.
//

#import "UIImage+Extension.h"

#define kShowImageInfoIcon YES

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size = size;

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [UIImage imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

// 改变图片颜色
- (UIImage *)fitThatColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//遍历图片像素，更改图片颜色
void DataProviderReleaseDataCallback(void *info, const void *data, size_t size)
{
    free((void *)data);
}

- (UIImage *)imageBlackToTransparent:(UIImage *)image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);

    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);

    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00) {  // 将白色变成透明
            uint8_t *ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        } else {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t *ptr = (uint8_t *)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
    }

    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, DataProviderReleaseDataCallback);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);

    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef];

    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free

    return resultUIImage;
}

//设置图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);

    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);

    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

    CGContextSetAlpha(ctx, alpha);

    CGContextDrawImage(ctx, area, image.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}

@end

@implementation UIImage (CacheMode)

+ (UIImage *)imageUsingCacheMode:(NSString *)imageName
{
    return [UIImage imageNamed:imageName];
}

+ (UIImage *)imageNotUsingCacheMode:(NSString *)imageName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    return [[UIImage alloc] initWithContentsOfFile:path];
}

// for bar, using our image
+ (UIImage *)originalImageNamed:(NSString *)imageName
{
    UIImage *image;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        image = [UIImage imageNamed:imageName];
    }

    return image;
}

- (UIImage *)originalImage
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        return self;
    }
}

@end

@implementation UIImage (Tint)

+ (UIImage *)imageNamed:(NSString *)name withTintColor:(UIColor *)tintColor
{
    UIImage *image = [UIImage imageNamed:name];

    return [image imageWithCustomTintColor:tintColor];
}

- (UIImage *)imageWithCustomTintColor:(UIColor *)tintColor
{
    if (@available(iOS 13.0, *)) {
        return [self imageWithTintColor:tintColor];
    }
    return [self imageWithCustomTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithCustomTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithCustomTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);

    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];

    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }

    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return tintedImage;
}

@end

#define kShowImageInfoIcon YES

@implementation UIImage (Thumbnails)

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    return [self imageByScalingAndCroppingForSize:targetSize alignmentCenter:NO];
}

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize alignmentCenter:(BOOL)isCenter
{
    CGSize scaledSize = targetSize;
    CGPoint thumbnailPoint = CGPointZero;

    BOOL isLongImage = NO;

    if (!CGSizeEqualToSize(self.size, targetSize)) {
        CGFloat widthFactor = targetSize.width / self.size.width;
        CGFloat heightFactor = targetSize.height / self.size.height;
        CGFloat scaleFactor = 0.0;

        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }

        scaledSize.width = self.size.width * scaleFactor;
        scaledSize.height = self.size.height * scaleFactor;

        // center the image
        if (widthFactor > heightFactor) {
            if (!isCenter) {
                // 和王建伟在风行时的需求 剧照墙好多是竖图照片 往上裁剪 来看到人头
                // thumbnailPoint.y = (targetSize.height - scaledSize.height) * 0.5 * 0.5;

                // 缩略图来看到图片最上边 大图预览所看到的图的最上部分
                thumbnailPoint.y = 0;
            } else {
                thumbnailPoint.y = (targetSize.height - scaledSize.height) * 0.5;
            }
        } else {
            if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetSize.width - scaledSize.width) * 0.5;
            }
        }

        float our = self.size.height / self.size.width;
        float screen = [[UIScreen mainScreen] bounds].size.height / [[UIScreen mainScreen] bounds].size.width;
        if (our > screen) {
            isLongImage = YES;
        }
    }

    // this will crop
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size = scaledSize;          // size控制原图缩放多少
    thumbnailRect.origin = thumbnailPoint;    // origin控制在缩放后图取的起始点
    [self drawInRect:thumbnailRect];

#if 0
    // 蒙上一个长图提示
    if (isLongImage && kShowImageInfoIcon) {
        UIImage *image = [UIImage imageNamed:@"thumb_image_info_long"];

        float pixelMultiple = [[UIScreen mainScreen] scale];

        CGRect infoIconRect;
        infoIconRect.origin.x = targetSize.width - (image.size.width + 6) * pixelMultiple;
        infoIconRect.origin.y = targetSize.height - (image.size.height + 6) * pixelMultiple;
        infoIconRect.size.width = image.size.width * pixelMultiple;
        infoIconRect.size.height = image.size.height * pixelMultiple;

        [image drawInRect:infoIconRect];
    }
#endif
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

// 等比缩放 来匹配尺寸 可能不满
- (UIImage *)scaleToFit:(CGSize)targetSize
{
    CGSize imageRealSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);

    float widthFactor = imageRealSize.width / targetSize.width;
    float heightFactor = imageRealSize.height / targetSize.height;
    CGRect rect = CGRectMake(0, 0, targetSize.width, targetSize.height);

    if (widthFactor >= heightFactor) {
        float realHeight = imageRealSize.height / widthFactor;
        rect.origin.y = (rect.size.height - realHeight) / 2;
        rect.size.height = realHeight;
    } else {
        float realWidth = imageRealSize.width / heightFactor;
        rect.origin.x = (rect.size.width - realWidth) / 2;
        rect.size.width = realWidth;
    }

    UIImage *outputImage;
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:rect];
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return outputImage;
}

// 等比缩放 来填充尺寸 超出的自动裁剪
- (UIImage *)scaleToFill:(CGSize)targetSize
{
    CGSize imageRealSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);

    float widthFactor = targetSize.width / imageRealSize.width;
    float heightFactor = targetSize.height / imageRealSize.height;
    CGRect rect = CGRectMake(0, 0, targetSize.width, targetSize.height);

    if (widthFactor >= heightFactor) {
        float realHeight = imageRealSize.height * widthFactor;
        rect.origin.x = 0.0f;
        rect.origin.y = (targetSize.height - realHeight) / 2;
        rect.size.height = realHeight;
    } else {
        float realWidth = imageRealSize.width * heightFactor;
        rect.origin.y = 0.0f;
        rect.origin.x = (targetSize.width - realWidth) / 2;
        rect.size.width = realWidth;
    }

    UIImage *outputImage;
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:rect];
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return outputImage;
}

@end

// 2张图合成1张
@implementation UIImage (MakeImage)

// place upper image in origin (0, 0)
+ (UIImage *)addImage:(UIImage *)upperImage toImage:(UIImage *)baseImage
{
    return [self addImage:upperImage toImage:baseImage inCenter:NO];
}

// place upper image in origin center ? center : (0, 0)
+ (UIImage *)addImage:(UIImage *)upperImage toImage:(UIImage *)baseImage inCenter:(BOOL)center
{
    CGSize baseSize = CGSizeMake(baseImage.size.width * baseImage.scale, baseImage.size.height * baseImage.scale);
    CGSize upperImageSize = CGSizeMake(upperImage.size.width * upperImage.scale, upperImage.size.height * upperImage.scale);
    CGRect upperImageRect;
    if (center) {
        float x = (baseSize.width - upperImageSize.width) / 2.0f;
        float y = (baseSize.height - upperImageSize.height) / 2.0f;
        upperImageRect = CGRectMake(x, y, upperImageSize.width, upperImageSize.height);
    } else {
        upperImageRect = CGRectMake(0, 0, upperImageSize.width, upperImageSize.height);
    }

    return [UIImage addImage:upperImage toImage:baseImage inRect:upperImageRect];
}

// place upper image in rect
+ (UIImage *)addImage:(UIImage *)upperImage toImage:(UIImage *)baseImage inRect:(CGRect)rect
{
    CGSize baseSize = CGSizeMake(baseImage.size.width * baseImage.scale, baseImage.size.height * baseImage.scale);

    UIGraphicsBeginImageContext(baseSize);

    [baseImage drawInRect:CGRectMake(0, 0, baseSize.width, baseSize.height)];

    [upperImage drawInRect:rect];

    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resultingImage;
}

+ (UIImage *)addResources:(NSArray *)rss inRects:(NSArray *)rects toImage:(UIImage *)baseImage
{
    if (!rss || !rects || ![rss isKindOfClass:[NSArray class]] || ![rects isKindOfClass:[NSArray class]] || rss.count != rects.count) {
        return nil;
    }

    CGSize baseSize = CGSizeMake(baseImage.size.width * baseImage.scale, baseImage.size.height * baseImage.scale);

    UIGraphicsBeginImageContext(baseSize);

    [baseImage drawInRect:CGRectMake(0, 0, baseSize.width, baseSize.height)];

    for (int i = 0; i < rss.count; ++i) {
        id item = rss[i];
        if ([item isKindOfClass:[UIImage class]]) {
            UIImage *subImage = item;
            [subImage drawInRect:CGRectFromString(rects[i])];
        } else if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *textRss = item;

#if 0
            CGContextSetFillColorWithColor(context, ((UIColor *)textRss[kTextRssColorKey]).CGColor);
            [(NSString *)textRss[kTextRssTextKey] drawInRect:CGRectFromString(rects[i])
                                                    withFont:(UIFont *)textRss[kTextRssFontKey]
                                               lineBreakMode:NSLineBreakByWordWrapping
                                                   alignment:NSTextAlignmentCenter];
#else
            [(NSString *)textRss[kTextRssTextKey] drawInRect:CGRectFromString(rects[i])
                                              withAttributes:@{ NSFontAttributeName: textRss[kTextRssFontKey],
                                                                              NSForegroundColorAttributeName: textRss[kTextRssColorKey],
                                                                              NSParagraphStyleAttributeName: textRss[kTextRssParagraphKey] }];
#endif
        } else {
            continue;
        }
    }

    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resultingImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image size:(CGSize)size
{
    return [self imageWithImage:image size:size xPosition:0.5 yPosition:0.5];
}

+ (UIImage *)imageWithImage:(UIImage *)image size:(CGSize)size xPosition:(CGFloat)xPosition yPosition:(CGFloat)yPosition
{
#if 0 // no scale

    BOOL center = YES;
    CGSize baseSize = CGSizeMake(size.width * image.scale, size.height * image.scale);
    CGSize upperImageSize = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);
    CGRect upperImageRect;

    if (center) {
        float x = (baseSize.width - upperImageSize.width) * xPosition;
        float y = (baseSize.height - upperImageSize.height) * yPosition;
        upperImageRect = CGRectMake(x, y, upperImageSize.width, upperImageSize.height);
    } else {
        upperImageRect = CGRectMake(0, 0, upperImageSize.width, upperImageSize.height);
    }

    UIGraphicsBeginImageContext(baseSize);

    [image drawInRect:upperImageRect];

    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resultingImage;

#else // with scale

    BOOL center = YES;
    CGRect imageToRect;

    if (center) {
        float x = (size.width - image.size.width) * xPosition;
        float y = (size.height - image.size.height) * yPosition;
        imageToRect = CGRectMake(x, y, image.size.width, image.size.height);
    } else {
        imageToRect = CGRectMake(0, 0, image.size.width, image.size.height);
    }

    UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);

    [image drawInRect:imageToRect];

    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resultingImage;
#endif
}

// 将UIImage缩放到指定大小尺寸：
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

// 根据图片的大小等比例压缩返回图片
- (UIImage *)fitSmallImage:(UIImage *)image size:(CGSize)size
{
    if (nil == image) {
        return nil;
    }
    if (image.size.width > 200 && image.size.height > 200) {
        return image;
    }
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:rect];
    UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newing;
}

@end

@implementation UIImage (Reflection)

- (UIImage *)addReflection:(CGFloat)reflectionScale
{
    int reflectionHeight = self.size.height * reflectionScale;

    // create a 2 bit CGImage containing a gradient that will be used for masking the
    // main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
    // function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
    CGImageRef gradientMaskImage = NULL;

    // gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

    // create the bitmap context
    CGContextRef gradientBitmapContext = CGBitmapContextCreate(nil, 1, reflectionHeight, 8, 0, colorSpace, kCGBitmapByteOrderDefault);

    // define the start and end grayscale values (with the alpha, even though
    // our bitmap context doesn't support alpha the gradient requires it)
    CGFloat colors[] = { 0.0, 1.0, 1.0, 1.0 };

    // create the CGGradient and then release the gray color space
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);

    // create the start and end points for the gradient vector (straight down)
    CGPoint gradientStartPoint = CGPointMake(0, reflectionHeight);
    CGPoint gradientEndPoint = CGPointZero;

    // draw the gradient into the gray bitmap context
    CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
                                gradientEndPoint, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(grayScaleGradient);

    // add a black fill with 50% opacity
    CGContextSetGrayFillColor(gradientBitmapContext, 0.0, 0.5);
    CGContextFillRect(gradientBitmapContext, CGRectMake(0, 0, 1, reflectionHeight));

    // convert the context into a CGImageRef and release the context
    gradientMaskImage = CGBitmapContextCreateImage(gradientBitmapContext);
    CGContextRelease(gradientBitmapContext);

    // create an image by masking the bitmap of the mainView content with the gradient view
    // then release the  pre-masked content bitmap and the gradient bitmap
    CGImageRef reflectionImage = CGImageCreateWithMask(self.CGImage, gradientMaskImage);
    CGImageRelease(gradientMaskImage);

    CGSize size = CGSizeMake(self.size.width, self.size.height + reflectionHeight);

    UIGraphicsBeginImageContext(size);

    [self drawAtPoint:CGPointZero];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, CGRectMake(0, self.size.height, self.size.width, reflectionHeight), reflectionImage);

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(reflectionImage);

    return result;
}

@end

@implementation UIImage (Bundle)

// 启动图
+ (UIImage *)launchImage
{
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"

    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);

        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            NSString *launchImage = dict[@"UILaunchImageName"];
            return [UIImage imageNamed:launchImage];
        }
    }
    return nil;
}

@end
