//
//  NavView.m
//  WorkBench
//
//  Created by mac on 15/10/23.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "NavView.h"
@interface NavView()
@property (nonatomic,weak) UILabel  *labTitle;
@property (nonatomic,weak) UIButton *backBtn;
@property (nonatomic,weak) UIButton *rightBtn;
@end

@implementation NavView
- (void)dealloc
{
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
        // RGB(0, 122, 255);
        self.backgroundColor = RGB(255, 188, 113);
    }
    return self;
}

#pragma mark - 初始化子控件
- (void)initSubviews {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [rightBtn addTarget:self action:@selector(rightBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    self.rightBtn = rightBtn;
    
    UILabel *labTitle = [UILabel new];
    labTitle.textColor = [UIColor whiteColor];
    [self addSubview:labTitle];
    self.labTitle = labTitle;
}

#pragma mark - 设置左边标题
- (void)setTitle:(NSString *)title
{
    _title = title;
   // self.labTitle.text = title;
    self.labTitle.text = @"";
}

#pragma mark - 设置右边按钮文字
- (void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = rightTitle;
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
}

#pragma mark - 设置右边按钮图片
- (void)setRightImage:(UIImage *)rightImage
{
    _rightImage = rightImage;
    self.rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.rightBtn setImage:rightImage forState:UIControlStateNormal];
}

#pragma mark - public 方法
- (UIButton *)rightButton
{
    return self.rightBtn;
}

#pragma mark - 事件和响应
- (void)leftBtnTapped
{
    if (self.Pop) {
        self.Pop();
    }
}

- (void)rightBtnTapped
{
    if (self.rightAction) {
        self.rightAction();
    }
}

#pragma mark - 重绘布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backBtn.frame = CGRectMake(5, 20, 50, 40);
    self.rightBtn.frame = CGRectMake(self.width - 55, 25, 50, 35);
    self.labTitle.frame = CGRectMake(60,10, self.width-100, self.height);
}

@end
