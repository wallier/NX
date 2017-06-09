//
//  BNMyNewsTableViewCell.h
//  WorkBench
//
//  Created by wanwan on 16/10/19.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNMyNewsTableViewCell : UITableViewCell
// 消息图片
@property (weak, nonatomic) IBOutlet UIImageView *news_Image;
// 消息标题
@property (weak, nonatomic) IBOutlet UILabel *news_Title;
// 即将过期人数
@property (weak, nonatomic) IBOutlet UILabel *news_deadlineNums;
// 消息推送时间
@property (weak, nonatomic) IBOutlet UILabel *news_Times;
// 红点
@property (weak, nonatomic) IBOutlet UILabel *redPointLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView andNums:(NSInteger)nums andTime:(NSString *)time andNewsTitle:(NSString *)newsTitle andSownRedPoint:(BOOL)isShowRedPoint;
@end
