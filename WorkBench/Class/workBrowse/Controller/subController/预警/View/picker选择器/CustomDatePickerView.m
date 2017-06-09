//
//  CustomDatePickerView.m
//  BIBuilderApp
//
//  Created by GuoYongming on 15/5/12.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import "CustomDatePickerView.h"

#define kYear   0
#define kMonth  1

@interface CustomDatePickerView () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;
@property (nonatomic, strong) NSString *selectYear;
@property (nonatomic, strong) NSString *selectMonth;
@property (nonatomic, strong) NSString *minYear;
@property (nonatomic, strong) NSString *maxYear;
@property (nonatomic, strong) NSString *day;

@end

@implementation CustomDatePickerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectYear = [self currentYearName];
        self.selectMonth = [NSString stringWithFormat:@"%02d",([self currentMonthName].intValue)];
        self.minYear = @"1970";
        self.maxYear = [self currentYearName];
        self.years = [self years];
        self.months = [self months];
        self.todayIndexPath = [self todayPath];
        self.delegate = self;
        self.dataSource = self;
        [self selectToday];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame andSelectMonth:(NSString*)str andFlag:(BOOL)flag
{
    self = [super initWithFrame:frame];
    if (self) {
        _flag = flag;
        self.selectYear = [NSString stringWithFormat:@"%02d",[[str substringToIndex:4] intValue]];
        self.selectMonth = [NSString stringWithFormat:@"%02d",[[str substringFromIndex:4] intValue]];
        self.minYear = @"1970";
        self.maxYear = [self currentYearName];
        self.years = [self years];
        self.months = [self months];
        self.todayIndexPath = [self todayPath];
        self.delegate = self;
        self.dataSource = self;
        [self selectToday];
    }
    return self;
}
// 获取当前最新数据月份的滚轴位置
-(NSIndexPath *)todayPath{
    CGFloat yearRow = 0.f;
    CGFloat monthRow = 0.f;
    
    int year  = _flag?self.selectYear.intValue:[self currentYearName].intValue;
    int month = _flag?[self.selectMonth intValue]:[self currentMonthName].intValue;
    for(NSString *cellYear in self.years)
    {
        if(cellYear.intValue == year)
        {
            yearRow = [self.years indexOfObject:cellYear];
            break;
        }
    }
    for(NSString *cellMonth in self.months)
    {
        if(cellMonth.intValue == month )
        {
            monthRow =_flag?[self.months indexOfObject:self.selectMonth]:[self.months indexOfObject:cellMonth];
            break;
        }
    }
    return [NSIndexPath indexPathForRow:yearRow inSection:monthRow];
}
// 设置滚轮显示位置
-(void)selectToday{
    [self selectRow: self.todayIndexPath.row inComponent: kYear animated: NO];
    [self selectRow: self.todayIndexPath.section inComponent: kMonth animated: NO];
}

// 滚轮未滚动时的时间，外部调用
-(NSString *)currentSelectDate{
    self.selectYear = [self.selectMonth length]? self.selectYear : [self currentYearName];
    
    self.selectMonth =  [self.selectMonth length]?self.selectMonth :[self currentMonthName];
    return [NSString stringWithFormat:@"%@%02d",self.selectYear,(self.selectMonth.intValue - 1)];
}
// 所有年数据
-(NSArray *)years{
    NSMutableArray *years = [NSMutableArray array];
    
    for(NSInteger year = self.minYear.intValue; year <= self.maxYear.intValue; year++){
        NSString *yearStr = [NSString stringWithFormat:@"%ld", (long)year];
        [years addObject:yearStr];
    }
    return years;
}
// 所有月数组
-(NSArray *)months{
    return [NSArray arrayWithObjects:@"01", @"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
}
// 当前月
-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    return [formatter stringFromDate:[NSDate date]];
}
// 当年年
-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == kYear) {
        return self.years.count;
    }
    return self.months.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.bounds.size.width / 2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = (UILabel *)view;
    if (!label) {
       label = [[UILabel alloc]init];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20.0];
    if (component == kYear) {
        label.text = [NSString stringWithFormat:@"%@年",self.years[row]];
    }else{
        label.text = [NSString stringWithFormat:@"%@月",self.months[row]];
    }
    return label;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == kYear) {
        self.selectYear = self.years[row];
    }else{
        self.selectMonth = self.months[row];
    }
    if ([self.customDelegate respondsToSelector:@selector(didSelectDate:)]) {
        [self.customDelegate didSelectDate:[NSString stringWithFormat:@"%@%@",self.selectYear,self.selectMonth]];
    }
}

@end
