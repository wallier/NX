//
//  BNApartmentTableViewCell.h
//  WorkBench
//
//  Created by wouenlone on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNProductModel.h"

@interface BNApartmentTableViewCell : UITableViewCell
+(instancetype)getTableViewCellWithTableView:(UITableView *)tableView andProduct:(BNProductModel *)product;

@end
