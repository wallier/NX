//
//  BNCommunityCell.m
//  WorkBench
//
//  Created by wanwan on 16/8/15.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNCommunityCell.h"
#import "BNAllCommunityModel.h"
#import <AFNetworking.h>
@interface BNCommunityCell()
@property (weak, nonatomic) IBOutlet UILabel *communityName;
@property (weak, nonatomic) IBOutlet UILabel *communityAddress;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
// 记录传过来的数组
@property (strong, nonatomic) NSArray *communityArr;
- (IBAction)addBtnAction:(UIButton *)sender;



@end
@implementation BNCommunityCell


+ (instancetype)cellWithTableView:(UITableView *)tableView andCommunityModel:(BNAllCommunityModel *)communityModel cellForRowAtIndexPath:(NSIndexPath *)indexPath andArray:(NSArray *)array {
    [[BNCommunityCell new]setArray:array];
    static NSString *identifier = @"CommunityCell";
    BNCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BNCommunityCell" owner:nil options:nil]firstObject];
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 77.5, SCREEN_W , 0.5)];
        lineview.backgroundColor = RGB(255, 146, 50);
        [cell addSubview:lineview];
    }
    //赋值
    cell.communityName.text = communityModel.REDION_NAME;
    cell.communityAddress.text = communityModel.REDION_ADDRESS;
    // 设置tag
    [cell.addBtn setTag:80000+indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setArray:(NSArray*)array {
    _communityArr = array;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)addBtnAction:(UIButton *)sender{
  
     [[NSNotificationCenter defaultCenter] postNotificationName:@"addCommunityBtn"object:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
}


@end
