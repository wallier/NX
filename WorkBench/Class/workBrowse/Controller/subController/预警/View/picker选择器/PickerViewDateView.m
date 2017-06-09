//
//  PickerViewDateView.m
//  BIBuilderApp
//
//  Created by mac on 15/6/18.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import "PickerViewDateView.h"
#define color(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation PickerViewDateView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.customPickerView];
    }
    return self;
}

-(UIView*)customPickerView{

    if (!_customPickerView) {
        _customPickerView = [[UIView alloc] initWithFrame:self.bounds];
        _pickerView.backgroundColor = [UIColor whiteColor];
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _customPickerView.bounds.size.width, 40)];
        headView.backgroundColor = color(39, 48, 63, 1);
        [_customPickerView addSubview:headView];
        
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
        self.pickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, headView.bounds.size.height, _customPickerView.bounds.size.width,216)];
        
        //self.pickerView.maximumDate = [NSDate date];
        [self.pickerView setDatePickerMode:UIDatePickerModeDate];
        self.pickerView.backgroundColor= color(220, 220, 220, 1);
        [_customPickerView addSubview:self.pickerView];

        
        
    }
    
    return _customPickerView;
}
-(void)cancel{
    if (self.send) {
        self.send(0);
    }
}
-(void)complete{
    if (self.send)
        self.send(1);
   if (_dates) {
            NSDateFormatter *fromater = [[NSDateFormatter alloc] init];
            [fromater setDateFormat:@"yyyy/MM/dd"];
            NSString *str = [fromater stringFromDate:_pickerView.date];
            [fromater setDateFormat:@"yyyyMMdd"];
            NSString *str2 = [fromater stringFromDate:_pickerView.date];
       
            _dates(str,str2);
        }
    
}

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

@end
