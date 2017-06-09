//
//  BNReportTableCell.h
//  WorkBench
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNReportCellModel.h"
@interface BNReportTableCell : UITableViewCell
@property (nonatomic, assign) int number ; ///< 表格分割数目
@property (nonatomic, strong) BNReportCellModel *model;
- (void)setlableColor:(UIColor *)color;
- (void)layoutSubviews;
@end
