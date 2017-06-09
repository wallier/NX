//
//  MyDatePickerView.m
//  BIBuilderApp
//
//  Created by GuoYongming on 15/5/12.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import "MyDatePickerView.h"
#import "CustomDatePickerView.h"

#define color(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


@interface MyDatePickerView () <CustomDatePickerViewDelegate>
@property (nonatomic,strong) UIView *customDatePicker;
@property (nonatomic,strong) CustomDatePickerView *datePickerView;
@property (nonatomic,strong) NSString *selectDate;
@property (nonatomic,strong) NSString *date;


@end

@implementation MyDatePickerView

#pragma mark - system methods
- (instancetype)initWithFrame:(CGRect)frame andSelectMonth:(NSString *)str
{
    self = [super initWithFrame:frame];
    if (self) {
        self.date = str;
        [self addSubview:self.customDatePicker];
    }
    return self;
}

#pragma mark - getters
-(UIView *)customDatePicker{
    if (!_customDatePicker) {
        _customDatePicker = [[UIView alloc]initWithFrame:self.bounds];
        _customDatePicker.backgroundColor = [UIColor whiteColor];
        _customDatePicker.clipsToBounds = YES;
        [self addSubview:_customDatePicker];
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _customDatePicker.bounds.size.width, 40)];
        headView.backgroundColor = color(39, 48, 63, 1);
        [_customDatePicker addSubview:headView];
        
        // 中间日期
        UIButton *date = [[UIButton alloc]initWithFrame:headView.bounds];
        [date setTitle:@"日期" forState:UIControlStateNormal];
        [date setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        date.titleLabel.font = [UIFont systemFontOfSize:15];
        [headView addSubview:date];
        
        // 左侧取消按钮
        [self createDatePickerButtonWithFrame:CGRectMake(5, 5, 60, headView.bounds.size.height - 10) Title:@"取消" BackgroundColor:color(164, 170, 176, 1) NormalColor:[UIColor whiteColor] HighlightedColor:[UIColor darkGrayColor] action:@selector(cancel) SuperView:headView];
        
        //右侧完成按钮
        [self createDatePickerButtonWithFrame:CGRectMake(headView.bounds.size.width - 65, 5, 60, headView.bounds.size.height - 10) Title:@"完成" BackgroundColor:[UIColor orangeColor] NormalColor:[UIColor whiteColor] HighlightedColor:[UIColor darkGrayColor] action:@selector(complete) SuperView:headView];
        
        // 下方日期选择器
        self.datePickerView =_date?[[CustomDatePickerView alloc] initWithFrame:CGRectMake(0, headView.bounds.size.height, _customDatePicker.bounds.size.width,216) andSelectMonth:_date andFlag:YES]: [[CustomDatePickerView alloc]initWithFrame:CGRectMake(0, headView.bounds.size.height, _customDatePicker.bounds.size.width,216)];
        self.datePickerView.customDelegate = self;
        self.datePickerView.backgroundColor = color(220, 220, 220, 1);
        [_customDatePicker addSubview:self.datePickerView];
    }
    return _customDatePicker;
}

#pragma mark - CustomDatePickerViewDelegate
-(void)didSelectDate:(NSString *)date{
    self.selectDate = date;
}

/**
 *  创建时间选择器顶部按钮
 *
 *  @param frame            位置
 *  @param title            名称
 *  @param backgroundColor  背景颜色
 *  @param normalColor      普通字体颜色
 *  @param highlightedColor 高亮字体颜色
 *  @param action           事件
 *  @param superView        父视图
 */
-(void)createDatePickerButtonWithFrame:(CGRect)frame Title:(NSString *)title BackgroundColor:(UIColor *)backgroundColor NormalColor:(UIColor *)normalColor HighlightedColor:(UIColor *)highlightedColor action:(SEL)action SuperView:(UIView *)superView
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
}
-(void)cancel{
    if (self.superview)
        [self removeFromSuperview];
}
-(void)complete{
    if (self.selectDate == nil) {
        self.selectDate = [self.datePickerView currentSelectDate];
    }
    if ([self.delegate respondsToSelector:@selector(didFinishSelectedDate:)]) {
        [self.delegate didFinishSelectedDate:self.selectDate];
    }
    [self cancel];  
}

@end
