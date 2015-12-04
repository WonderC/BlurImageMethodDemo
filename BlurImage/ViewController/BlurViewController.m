
//  BlurViewController.m
//  UnitTest
//
//  Created by 美房圈 on 15/12/3.
//  Copyright © 2015年 美房圈. All rights reserved.
//

#import "BlurViewController.h"
#import "UIImage+Extension.h"
#import "GPUImage.h"
#import <Accelerate/Accelerate.h>
#import "UIButton+Extension.h"

@implementation BlurViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showBlur];
    
}
-(void)BackButton:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showBlur{
    
    switch (self.showNo) {
        case 0:
            [self showCoreImage];
            break;
        case 1:
            [self showGPUImage];
            break;
        case 2:
            [self showSystemBlur];
            break;
        case 3:
            [self rt_tintedImageWithColor_blur];
            break;
        case 4:
            [self noBlur];
            break;
        default:
            break;
    }
}

-(void)showCoreImage{
    //Core Image 55M  内存消耗
    UIImageView *bgImageView= [[UIImageView alloc] initWithFrame:self.view.frame];
    UIImage *bgImage = [UIImage imageNamed:@"Blur_bj"];
    UIImage *image = [UIImage blurryImage:bgImage withBlurLevel:0.1];
    bgImageView.image = image;
    [self.view addSubview:bgImageView];
}

-(void)showGPUImage
{
    //GPUImage 61M
    UIImageView *bgImageView= [[UIImageView alloc] initWithFrame:self.view.frame];
    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 2.0;
    UIImage * image = [UIImage imageNamed:@"Blur_bj"];
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    bgImageView.image = blurredImage;
    [self.view addSubview:bgImageView];
}
-(void)showSystemBlur{
    UIImageView *bgi = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgi.image = [UIImage imageNamed:@"bgView.jpg"];
    [self.view addSubview:bgi];
    //系统的 5M
    UIImageView *bgImageView= [[UIImageView alloc] initWithFrame:self.view.frame];
    UIImage *bgImage = [UIImage blurrymage:[UIImage imageNamed:@"Blur_bj"] withBlurLevel:0.1];
    bgImageView.image = bgImage;
    bgImageView.alpha = 0.9;
    [self.view addSubview:bgImageView];
    UIView *imageV = [[UIView alloc] initWithFrame:self.view.frame];
    imageV.backgroundColor =[UIColor greenColor];
    imageV.alpha = 0.1;
    [self.view addSubview:imageV];
}

-(void)rt_tintedImageWithColor_blur{
    //5M
    UIImageView *bgImageView= [[UIImageView alloc] initWithFrame:self.view.frame];
    UIImage *bgI = [[UIImage imageNamed:@"bgView"] rt_tintedImageWithColor:[UIColor greenColor] rect:self.view.frame level:0.5];
    bgImageView.image = [UIImage blurrymage:bgI withBlurLevel:0.11];
    [self.view addSubview:bgImageView];
}

-(void)noBlur{
    //5M
    UIImageView *bgImageView= [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImageView.image = [UIImage imageNamed:@"blur_bgView"];
    [self.view addSubview:bgImageView];
    UIView *topBGView = [[UIView alloc] initWithFrame:self.view.frame];
    topBGView.backgroundColor = [UIColor redColor];
    topBGView.alpha = 0.2;
    [self.view addSubview:topBGView];
}


@end
