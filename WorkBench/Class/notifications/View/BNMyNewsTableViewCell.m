//
//  BNMyNewsTableViewCell.m
//  WorkBench
//
//  Created by wanwan on 16/10/19.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNMyNewsTableViewCell.h"


@interface BNMyNewsTableViewCell()



@end

@implementation BNMyNewsTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView andNums:(NSInteger)nums andTime:(NSString *)time andNewsTitle:(NSString *)newsTitle andSownRedPoint:(BOOL)isShowRedPoint{
    static NSString *identifier = @"newsCell";
    BNMyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BNMyNewsTableViewCell" owner:nil options:nil]firstObject];
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, SCREEN_W , 0.5)];
        lineview.backgroundColor = RGB(255, 146, 50);
        [cell addSubview:lineview];
    }
    
    cell.news_deadlineNums.text = [NSString stringWithFormat:@"%ld",(long)nums];
    cell.news_Times.text = time;
    cell.news_Title.text = newsTitle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (isShowRedPoint) {
        // 小红点
        cell.redPointLabel.layer.cornerRadius = 4;
        cell.redPointLabel.clipsToBounds = YES;
    
    } else {
        cell.redPointLabel.hidden = YES;
    
    
    }
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
