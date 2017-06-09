//
//  MyDatePickerView.h
//  BIBuilderApp
//
//  Created by GuoYongming on 15/5/12.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDatePickerViewDelegate <NSObject>
-(void)didFinishSelectedDate:(NSString *)date;

@end

@interface MyDatePickerView : UIView
- (instancetype)initWithFrame:(CGRect)frame andSelectMonth:(NSString *)str;
@property (nonatomic,weak) id <MyDatePickerViewDelegate> delegate;

@end
