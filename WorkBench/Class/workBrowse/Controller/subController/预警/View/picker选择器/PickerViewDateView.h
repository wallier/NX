//
//  PickerViewDateView.h
//  BIBuilderApp
//
//  Created by mac on 15/6/18.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^sendTag) (int tag);
typedef void(^sendDate) (NSString *dates,NSString *date2);
typedef void(^sendString) (NSString *string);
@interface PickerViewDateView : UIView
@property(nonatomic,strong) UIDatePicker *pickerView;
@property(nonatomic,strong) UIView *customPickerView;
@property(nonatomic,strong) sendTag send;
@property(nonatomic,strong) sendDate dates;
@property(nonatomic,strong) sendString sendstring;

@end
