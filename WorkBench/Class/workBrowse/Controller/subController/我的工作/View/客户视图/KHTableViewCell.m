//
//  KHTableViewCell.m
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//
#import "ThreeKHModel.h"
#import "KHTableViewCell.h"
#import "FourKHModel.h"
@implementation KHTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{

        static NSString *ID = @"cell";
        tableView.bounces = NO;
        KHTableViewCell *cell = (KHTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ID ];
    
        if (cell == nil) {
            cell = [[KHTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, 70);
            cell.lab_left = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-100,15, 70, 40)];
            cell.lab_left.font = [UIFont systemFontOfSize:13];
            [cell addSubview:cell.lab_left];
            cell.lab_left.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
  
    return cell;
}

-(void)setCellModel:(KHCellModel *)cellModel{

    self.textLabel.text = cellModel.text_top;
    self.textLabel.numberOfLines = 2;
    if ([cellModel isMemberOfClass:[KHCellModel class]]) {
        self.detailTextLabel.text = [NSString stringWithFormat:@"包含:%@  已使用:%@%@",cellModel.text_bottom,cellModel.isused,cellModel.unit]; // cellModel.text_bottom;
        if ([self.detailTextLabel.text length] >22) {
            NSString *str = [self.detailTextLabel.text substringToIndex:22];
            NSString *str2 = [self.detailTextLabel.text substringFromIndex:22];
            self.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",str,str2];
            self.detailTextLabel.numberOfLines = 3;
            self.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
            self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        }
        self.lab_left.text = [NSString stringWithFormat:@"已使用%@",cellModel.text_right];
        [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell2"]]];
        
    } else if ([cellModel isMemberOfClass:[ThreeKHModel class]]) {
        
        self.lab_left.text = cellModel.text_right;
        [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell2"]]];
        
    } else if ([cellModel isMemberOfClass:[FourKHModel class]]) {
        self.detailTextLabel.text = cellModel.text_bottom;
        self.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.detailTextLabel.numberOfLines = 3;
        
        [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell"]]];
        
    }
    
    
}

@end
