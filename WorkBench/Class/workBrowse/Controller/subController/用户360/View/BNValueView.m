//
//  BNValueView.m
//  WorkBench
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNValueView.h"
@implementation BNValueView

- (void)awakeFromNib{
    [self setBackgroundColor:[UIColor redColor]];
    
    self.ValueWebView = [[WKWebView alloc] init];
    self.ValueWebView.layer.borderWidth = 2;
    self.ValueWebView.layer.borderColor = [UIColor orangeColor].CGColor;
    [self addSubview:self.ValueWebView];
    
    self.ValueTableView = [[UITableView alloc] init];
    [self addSubview:self.ValueTableView];
    

}

- (void)layoutSubviews{
    [self.ValueWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.ValueTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.ValueWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.and.right.equalTo(self);
        make.height.equalTo(@(self.frame.size.height/2));
    }];
    
    [self.ValueTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.bottom.height.equalTo(@(self.frame.size.height/2));
        make.left.and.right.equalTo(self);
    }];
    
}


@end
