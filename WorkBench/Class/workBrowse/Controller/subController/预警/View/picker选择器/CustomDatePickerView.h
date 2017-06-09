//
//  CustomDatePickerView.h
//  BIBuilderApp
//
//  Created by GuoYongming on 15/5/12.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerViewDelegate <NSObject>

-(void)didSelectDate:(NSString *)date;

@end

@interface CustomDatePickerView : UIPickerView
@property (nonatomic,assign) BOOL flag;
-(NSString *)currentSelectDate;
- (instancetype)initWithFrame:(CGRect)frame andSelectMonth:(NSString*)str andFlag:(BOOL)flag;
@property (nonatomic,weak) id<CustomDatePickerViewDelegate>customDelegate;
@end
