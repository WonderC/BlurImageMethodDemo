//
//  UIImage+Extension.m
//  UnitTest
//
//  Created by 美房圈 on 15/12/3.
//  Copyright © 2015年 美房圈. All rights reserved.
//

#import "UIImage+Extension.h"
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (Extension)

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
#if 0
    if (image == nil) {
        return nil;
    }
    
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
    
    //    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
    //                                  keysAndValues:kCIInputImageKey, inputImage, nil];
    //    [filter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
    
    CIImage *outputImage = gaussianBlurFilter.outputImage;
    CGRect rect             = [outputImage extent];
    rect.origin.x          += (rect.size.width  - image.size.width ) / 2;
    rect.origin.y          += (rect.size.height - image.size.height) / 2;
    rect.size               = image.size;

    
    CIImage* croppedImage = [outputImage imageByCroppingToRect:rect];
    UIImage * blurryImage = [UIImage imageWithCIImage:croppedImage];
    
    //该方法有内存泄露的问题
    //    CIContext *context = [CIContext contextWithOptions:nil]; // save it to self.context
    //    CGImageRef outImage = [context createCGImage:outputImage fromRect:rect];
    //    UIImage * blurryImage = [UIImage imageWithCGImage:outImage];
    //    CGImageRelease(outImage);
    
    return blurryImage;
#else
    
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur), nil];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return returnImage;
#endif
}

+ (UIImage *)blurrymage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    return returnImage;
}


-(UIImage*)rt_tintedImageWithColor:(UIColor*)color rect:(CGRect)rect level:(CGFloat)level {
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawInRect:imageRect];
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetAlpha(ctx, level);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, rect);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *darkImage = [UIImage imageWithCGImage:imageRef
                                             scale:self.scale
                                       orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    UIGraphicsEndImageContext();
    
    return darkImage;
}


@end
