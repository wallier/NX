//
//  BNSetTableViewCell.h
//  WorkBench
//
//  Created by mac on 16/2/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNBaseSetCellModel.h"

@interface BNSetTableViewCell : UITableViewCell

@property (nonatomic, strong) BNBaseSetCellModel *model;

+ (instancetype)initWithTableView:(UITableView *)tableView andIdentifier:(NSString *)Indentify;
@end
