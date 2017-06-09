//
//  zpChoseCell.h
//  WorkBench
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "choseModel.h"
typedef void (^sendBtn) (UIButton*,choseModel*);
@interface zpChoseCell : UITableViewCell
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) choseModel *model;
@property (nonatomic,strong) sendBtn senbtn;
+ (instancetype)initWithTabelView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
