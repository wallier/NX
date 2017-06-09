//
//  BNOrdeDetailTableCell.h
//  WorkBench
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customMyBtn.h"
#import "BNOrderDetailModel.h"

@interface BNMyGrabOrdeDetailTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgOrderState;
@property (weak, nonatomic) IBOutlet UILabel *labAccr;
@property (weak, nonatomic) IBOutlet UILabel *labPolicyId;
@property (weak, nonatomic) IBOutlet UIImageView *imgSxFlag;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet customMyBtn *btnChoseOrder;

@property (nonatomic, strong) BNOrderDetailModel *model;


@end
