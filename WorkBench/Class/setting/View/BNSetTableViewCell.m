//
//  BNSetTableViewCell.m
//  WorkBench
//
//  Created by mac on 16/2/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNSetTableViewCell.h"

@implementation BNSetTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView andIdentifier:(NSString *)Indentify{
    static NSString *cellId = @"cell";
    BNSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BNSetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellId];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, SCREEN_W , 0.5)];
    lineview.backgroundColor = RGB(255, 146, 50);
    [cell addSubview:lineview];

    return cell;

}

- (void)setModel:(BNBaseSetCellModel *)model{
    self.textLabel.text =  model.title;
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    self.imageView.image = [UIImage imageNamed:model.ImgName];

    switch (model.type) {
        case 0:
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 1:
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
}

@end
