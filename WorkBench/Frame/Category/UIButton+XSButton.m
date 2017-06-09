//
//  UIButton+XSButton.m
//  发微博界面1
//
//  Created by xiaos on 15/11/24.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//

#import "UIButton+XSButton.h"

@implementation UIButton (XSButton)

+ (UIButton *)setUpButtonsWithColor:(UIColor *)color isEnabled:(BOOL)enabled title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.enabled = enabled;
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    return btn;
}

@end
