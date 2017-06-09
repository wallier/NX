//
//  BNPolicyViewCell.h
//  WorkBench
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BNPolicyBtn.h"

#import "BNPolicyModel.h"

@interface BNPolicyViewCell : UICollectionViewCell
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, assign) int flagHXWG;
@property (nonatomic, strong) BNPolicyModel *model;
@property (nonatomic, strong) BNPolicyBtn *btnImg;
@property (nonatomic, strong) BNPolicyBtn *btn;
@property (nonatomic, strong) BNPolicyBtn *btnGRABEXCUTE;
@property (nonatomic, strong) BNPolicyBtn *btnGRABEXCUTENOT;
@property (nonatomic, strong) BNPolicyBtn *btnGRABNUM;
@property (weak, nonatomic) IBOutlet UILabel *policyName;
@property (weak, nonatomic) IBOutlet UILabel *policyNum;
@property (weak, nonatomic) IBOutlet UILabel *policySc;

@end
