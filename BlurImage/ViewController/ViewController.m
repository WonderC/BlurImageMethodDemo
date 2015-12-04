//
//  ViewController.m
//  BlurImage
//
//  Created by 美房圈 on 15/12/4.
//  Copyright © 2015年 美房圈. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Extension.h"
#import "BlurViewController.h"

#define buttonWidth ([[UIScreen mainScreen] bounds].size.width- 30)/2

@interface ViewController ()
@property (nonatomic,assign) BOOL clickFlag;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.clickFlag = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Blur Image";
    
    NSArray *showTitle = @[@"Core Image",@"GPUImage",@"SystemBlur",@"rt_tintedImageWithColor+blur",@"noBlurSetting"];
    
    for (int i = 0; i< [showTitle count]; i++) {
        UIButton *btn = [UIButton buttonWithTitle:showTitle[i] frame:CGRectMake(10+(buttonWidth+10)*(i%2), 64+(100+10)*(i/2), buttonWidth, 100)];
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag  = 100000+i;
        [self.view addSubview:btn];
    }
}

-(void)BtnClick:(UIButton *)sender{
    if (!self.clickFlag) {
        return;
    }
    self.clickFlag = NO;
    BlurViewController *blur  = [[BlurViewController alloc] init];
    blur.showNo = sender.tag - 100000;
    [self.navigationController pushViewController:blur animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
