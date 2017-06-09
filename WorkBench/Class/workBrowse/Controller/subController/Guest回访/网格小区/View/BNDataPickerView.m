//
//  BNDataPickerView.m
//  WorkBench
//
//  Created by wanwan on 16/9/23.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNDataPickerView.h"

@interface BNDataPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
// 网格/小区/楼号数组
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation BNDataPickerView

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _dataArray[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedData = self.dataArray[row];
    //[self selectedDate];
}
//- (void)selectedDate{
////    NSLog(@"HYM选择时间 %@ %@ %@",self.day,self.hour,self.minute);
////    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
////    [formatter setDateFormat:@"yyyy年"];
////    NSString *str = [formatter stringFromDate:[NSDate date]];
////    NSString *dateStr = [NSString stringWithFormat:@"%@%@ %@%@",str,self.day,self.hour,self.minute];
////    if([self.day isEqualToString:@"今天"]){
////        [formatter setDateFormat:@"MM月dd日EE"];
////        self.day = [formatter stringFromDate:[NSDate date]];
////    }else if ([self.day isEqualToString:@"明天"]){
////        [formatter setDateFormat:@"yyyy-MM-dd"];
////        NSString *str = [NSString stringWithFormat:@"%@ 00:00:00",[formatter stringFromDate:[NSDate date]]];
////        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
////        NSDate *baseDate = [formatter dateFromString:str];
////        [formatter setDateFormat:@"MM月dd日EE"];
////        self.day = [formatter stringFromDate:[NSDate dateWithTimeInterval:24*60*60 sinceDate:baseDate]];
////    }
////    [formatter setDateFormat:@"yyyy年MM月dd日EE HH时mm分"];
////    NSDate *date = [formatter dateFromString:dateStr];
////    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
////    NSLog(@"H@%@",[formatter stringFromDate:date]);
//    if(self.delegateDiy && [self.delegateDiy respondsToSelector:@selector(currentSelectedDate:)]){
//        [self.delegateDiy currentSelectedDate:date];
//    }
//}
//
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_W*0.8;
//    switch (component) {
//        case 0:
//            return [UIScreen mainScreen].bounds.size.width*0.4;
//            break;
//        case 1:
//            return [UIScreen mainScreen].bounds.size.width*0.25;
//            break;
//        case 2:
//            return [UIScreen mainScreen].bounds.size.width*0.25;
//            break;
//        default:
//            return [UIScreen mainScreen].bounds.size.width*0.25;
//            break;
//    }
}

#pragma mark 自定义字体
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        //pickerLabel.minimumFontSize = 8;
       // pickerLabel setFont:[UIFont syste]
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
