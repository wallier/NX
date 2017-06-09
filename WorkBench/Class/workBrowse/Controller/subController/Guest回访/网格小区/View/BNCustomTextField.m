//
//  BNCustomTextField.m
//  WorkBench
//
//  Created by wanwan on 16/9/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNCustomTextField.h"

@implementation BNCustomTextField

// 自定义TextField
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 2.0, CGRectGetWidth(self.frame), 2.0));
}


@end
