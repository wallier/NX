//
//  BNCommunityCell.h
//  WorkBench
//
//  Created by wanwan on 16/8/15.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNAllCommunityModel.h"

@interface BNCommunityCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView andCommunityModel:(BNAllCommunityModel *)communityModel cellForRowAtIndexPath:(NSIndexPath *)indexPath andArray:(NSArray *)array;
@end
