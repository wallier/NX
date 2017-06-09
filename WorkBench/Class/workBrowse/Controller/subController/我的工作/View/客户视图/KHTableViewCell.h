//
//  KHTableViewCell.h
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHCellModel.h"
@interface KHTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *lab_left;
@property (nonatomic,strong)UILabel *subTitle;
@property (nonatomic,strong)KHCellModel *cellModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
