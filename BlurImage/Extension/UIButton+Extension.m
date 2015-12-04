//
//  UIButton+Extension.m
//  UnitTest
//
//  Created by 美房圈 on 15/12/1.
//  Copyright © 2015年 美房圈. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)
+(UIButton *)buttonWithTitle:(NSString *)buttonTitle frame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:buttonTitle forState:UIControlStateNormal];
    btn.frame= frame;
    btn.backgroundColor =[UIColor lightGrayColor];
    return btn;
}
@end
