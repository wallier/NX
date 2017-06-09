//
//  BNOrdeDetailTableCell.m
//  WorkBench
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNMyGrabOrdeDetailTableCell.h"

@implementation BNMyGrabOrdeDetailTableCell

- (void)awakeFromNib {
    
}

- (void)layoutSubviews{
    CGFloat W = (self.width - 2 ) / 3;
    self.labAccr.width = W;
    self.labAccr.x = self.x;
    self.labPolicyId.x = W + 1;
    self.labPolicyId.width= W;
    self.imgOrderState.x = self.x;
    self.labBack.x = 2 * (W + 1);
    self.labBack.width = W;
    
    CGFloat distance =  W / 3 - 25;
    
    self.imgSxFlag.x = self.labBack.x + 3;
    self.btnDate.x = CGRectGetMaxX(self.imgSxFlag.frame) + distance;
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"] || [[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]) {
        self.btnChoseOrder.cell = self;
        self.btnChoseOrder.x = CGRectGetMaxX(self.btnDate.frame) + distance;
    } else {
        [self.btnChoseOrder setHidden:YES];
    }
}

- (void)setModel:(BNOrderDetailModel *)model{
    _model = model;
    self.labAccr.text = _model.USER_ACCR;
    self.labPolicyId.text  = _model.USER_NAME;
    self.imgOrderState.image = nil;
//    self.imgOrderState.image = [self judgeOrderStateImage:_model.ORDER_STATE];
    self.imgSxFlag.image = [self judgetImage:_model.SAN_FALG];
    [self.btnDate setTitle:_model.OVER_DATE forState:UIControlStateNormal];
}

- (UIImage *)judgetImage:(NSString *)sanFlag{
    
    switch ([sanFlag intValue]) {
        case 1:
            return [UIImage imageNamed:@"dp_workorder_worry_icon"];
            break;
        case 2:
            return [UIImage imageNamed:@"dp_workorder_carefor_icon"];
            break;
        case 3:
            return [UIImage imageNamed:@"dp_workorder_reassure_icon"];
            break;
            
        default:
            break;
    }
    return nil;
}
/**
 *
 *  @param state 0 未执行 1 已执行 2执行中
 *
 */
- (UIImage *)judgeOrderStateImage:(NSString *)state{
    switch ([state intValue]) {
        case 0:{//未执行 ->是否转派 是：显示转派 按钮不能选 ；否：隐藏转派 按钮可以选
            if ([self.model.IS_FORWARD_SEND isEqualToString:@"1"]) {
                [self.imgOrderState setHidden:NO];
                self.btnChoseOrder.hidden = YES;
                return [UIImage imageNamed:@"zhuanpai"];
            } else {
                [self.imgOrderState setHidden:YES];
                self.btnChoseOrder.hidden = NO;
                return nil;
            }
        }
            break;
        case 1:
            [self.imgOrderState setHidden:NO];
            self.btnChoseOrder.hidden = YES;
            
            return [UIImage imageNamed:@"zhixing"];
            break;
        case 2:
            [self.imgOrderState setHidden:NO];
            self.btnChoseOrder.hidden = YES;
            return [UIImage imageNamed:@"zhixinging"];
            break;
            
        default:
            break;
    }
    
    return nil;
}

@end
