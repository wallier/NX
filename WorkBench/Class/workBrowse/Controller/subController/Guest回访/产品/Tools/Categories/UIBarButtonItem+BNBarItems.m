//
//  UIBarButtonItem+BNBarItems.m
//  WorkBench
//
//  Created by wanwan on 16/8/23.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "UIBarButtonItem+BNBarItems.h"

@implementation UIBarButtonItem (BNBarItems)

+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName withHighLightedImage:(NSString *)hlImageName withTarget:(id)target withAction:(SEL)action {
    //UIButton
    UIButton *button = [UIButton new];
    //设置button属性
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hlImageName] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //返回已经创建好的item
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
