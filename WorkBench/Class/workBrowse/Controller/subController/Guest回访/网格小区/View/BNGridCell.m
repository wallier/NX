//
//  BNGridCell.m
//  WorkBench
//
//  Created by wanwan on 16/8/12.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNGridCell.h"

@interface BNGridCell()

//@property (weak, nonatomic) IBOutlet UIImageView *gridImgView;
@property (weak, nonatomic) IBOutlet UILabel *gridName;
@property (weak, nonatomic) IBOutlet UILabel *gridManagerName;
@property (weak, nonatomic) IBOutlet UILabel *gridQuantity;

@end
@implementation BNGridCell


+ (instancetype)cellWithTableView:(UITableView *)tableView AndGridRoleModel:(BNGridRoleModel*)gridRoleModel{
    static NSString *identifier = @"GridCell";
    BNGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BNGridCell" owner:nil options:nil]firstObject];
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, SCREEN_W , 0.5)];
        lineview.backgroundColor = RGB(255, 146, 50);
        [cell addSubview:lineview];
    }
    cell.gridName.text = gridRoleModel.NAME;
    cell.gridManagerName.text = gridRoleModel.USER_NAME;
    cell.gridQuantity.text = [NSString stringWithFormat:@"%@", gridRoleModel.REGION_NUM];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
