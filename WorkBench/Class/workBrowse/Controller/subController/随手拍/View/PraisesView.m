//
//  PraisesView.m
//  WorkBench
//
//  Created by xiaos on 15/12/9.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "PraisesView.h"

@interface PraisesView ()

@property (nonatomic,weak) UILabel *praisesLabel;

@end

@implementation PraisesView

- (instancetype)init
{
    if (self = [super init]) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview {
    UILabel *praisesLabel = [UILabel new];
    [self addSubview:praisesLabel];
    self.praisesLabel = praisesLabel;
    praisesLabel.numberOfLines = 0;
    praisesLabel.font = [UIFont systemFontOfSize:12.0f];
}


- (void)setPraisesStr:(NSString *)praisesStr {
    _praisesStr = praisesStr;
    self.praisesLabel.text = praisesStr;
    [self setNeedsLayout];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.praisesLabel.frame = self.bounds;
}

@end
