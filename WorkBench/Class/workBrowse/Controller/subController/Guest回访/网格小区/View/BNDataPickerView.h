//
//  BNDataPickerView.h
//  WorkBench
//
//  Created by wanwan on 16/9/23.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
//代理
@protocol BNDataPickViewDelegate <NSObject>

- (void)currentSelectedData:(NSString *)data;

@end


@interface BNDataPickerView : UIPickerView
//已选择数据
@property (strong, nonatomic) NSString *selectedData;
@property (nonatomic, strong) id<BNDataPickViewDelegate> pickerDelegate;
@end
