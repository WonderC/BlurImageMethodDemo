//
//  UIImage+Extension.h
//  UnitTest
//
//  Created by 美房圈 on 15/12/3.
//  Copyright © 2015年 美房圈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
+ (UIImage *)blurrymage:(UIImage *)image withBlurLevel:(CGFloat)blur;

-(UIImage*)rt_tintedImageWithColor:(UIColor*)color rect:(CGRect)rect level:(CGFloat)level;

@end
