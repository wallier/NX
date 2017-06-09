//
//  BNOrdeDetailTableCell.h
//  WorkBench
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customBtn.h"
#import "BNOrderDetailModel.h"

@interface BNOrdeDetailTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgOrderState;
@property (weak, nonatomic) IBOutlet UILabel *labAccr;
@property (weak, nonatomic) IBOutlet UILabel *labPolicyId;
@property (weak, nonatomic) IBOutlet UIImageView *imgSxFlag;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet customBtn *btnChoseOrder;

@property (nonatomic, strong) BNOrderDetailModel *model;
//@property (nonatomic, strong) UIButton *btnKillOrder;
//@property (nonatomic, strong) UIButton *btnStatus;


@end
