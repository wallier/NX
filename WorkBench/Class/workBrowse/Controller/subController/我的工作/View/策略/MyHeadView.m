//
//  MyHeadView.m
//  BIBuilderApp
//
//  Created by mac on 15/6/26.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import "MyHeadView.h"

@implementation MyHeadView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(frame)/4, CGRectGetHeight(frame))];
        _lab.backgroundColor = [UIColor clearColor];
        [self addSubview:_lab];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(CGRectGetWidth(frame)-90, 0, 90, 40)];
        [btn setTitle:@"更多>>" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(getMoreData) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
    }
    return self;
}

-(void)getMoreData{
    if (self.getmore) {
        self.getmore();
    }
}

@end
