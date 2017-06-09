//
//  BNPolicyBtn.m
//  WorkBench
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNPolicyBtn.h"

@implementation BNPolicyBtn

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    self.imageView.width =self.height*2/3;
    self.imageView.height = self.height*2/3;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
