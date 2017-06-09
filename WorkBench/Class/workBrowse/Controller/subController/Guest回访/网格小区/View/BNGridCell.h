//
//  BNGridCell.h
//  WorkBench
//
//  Created by wanwan on 16/8/12.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNGridRoleModel.h"

@interface BNGridCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView AndGridRoleModel:(BNGridRoleModel*)gridRoleModel;

@end
