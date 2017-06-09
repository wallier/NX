//
//  BNPolicyViewCell.m
//  WorkBench
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNPolicyViewCell.h"

@implementation BNPolicyViewCell

- (void)awakeFromNib {
}

- (void)layoutSubviews{
    NSLog(@"qq===%@",[LoginModel shareLoginModel].ORG_MANAGER_TYPE);
    self.policyName.width = self.width ;
    self.policyNum.width = self.width;
    
    if([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||[[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"])
    {
        self.policySc.hidden = NO;
        self.policySc.width = self.width;
    }
    else
    {
        self.policySc.hidden = YES;
        self.policyName.frame = CGRectMake(self.policyName.frame.origin.x, self.policyName.frame.origin.y-8, self.policyName.frame.size.width, self.policyName.frame.size.height);

    }

}

- (void)setModel:(BNPolicyModel *)model{
    _model = model;
    
    //    self.policyNum.text = _model.USER_NUM;
    
    if (self.flagHXWG)
    {
        self.policySc.text = [NSString stringWithFormat:@"%@/%@(人)",_model.ONLINE_USER_NUM,_model.TOP_USER_LIMIT];
        self.policyName.text = _model.POLICY_NAME;
        self.policyNum.text = @"";
    }
    else if(self.flag)
    {
        self.policySc.text = @"";
        self.policyName.text = _model.POLICY_NAME;
        self.policyNum.text = _model.USER_NUM;
        self.policyNum.frame = CGRectMake(self.policyNum.frame.origin.x, self.policyNum.frame.origin.y-18, self.policyNum.frame.size.width, self.policyNum.frame.size.height);
    }
    
    CGFloat W = self.width / 3;
    
    if (self.flag) {
        for (int i = 0; i < 3; i ++) {
            BNPolicyBtn *btn = [BNPolicyBtn buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(i*W+5, CGRectGetMaxY(self.policyNum.frame), W, 25)];
            [btn setImage:[self judgewithSxFlag:i] forState:UIControlStateNormal];
            [btn setTitle:i == 0 ? _model.CX_NUM : i == 1 ? _model.GX_NUM :_model.FX_NUM forState:UIControlStateNormal];
            [self addSubview:btn];
        }
        
    }
    
    if(self.flagHXWG)
    {
//        for (int i = 0; i < 2; i ++) {
//            BNPolicyBtn *btn = [BNPolicyBtn buttonWithType:UIButtonTypeCustom];
//            [btn setFrame:CGRectMake(i*W, CGRectGetMaxY(self.policyNum.frame), W, 25)];
//            [btn setImage:[self judgewithMOFlag:i] forState:UIControlStateNormal];
//            [btn setTitle:i == 0 ? _model.GRABNUM : _model.UNGRABNUM forState:UIControlStateNormal];
//            
//            [self addSubview:btn];
//        }
        

        
        for (int i = 0; i < 3; i ++) {
            
            _btnImg = [BNPolicyBtn buttonWithType:UIButtonTypeCustom];
            [_btnImg setFrame:CGRectMake(i*W+8, CGRectGetMaxY(self.policyNum.frame)-22, W, 25)];
            [_btnImg setImage:[self judgewithPoolFlag:i] forState:UIControlStateNormal];
            [self addSubview:_btnImg];

            
            if(!_btnGRABEXCUTE&&i==0){
            _btnGRABEXCUTE = [BNPolicyBtn buttonWithType:UIButtonTypeCustom];
            [_btnGRABEXCUTE setFrame:CGRectMake(i*W+12, CGRectGetMaxY(self.policyNum.frame)-10, W, 25)];
            [self addSubview:_btnGRABEXCUTE];
            }
            
            if(!_btnGRABEXCUTENOT&&i==1){
            _btnGRABEXCUTENOT = [BNPolicyBtn buttonWithType:UIButtonTypeCustom];
            [_btnGRABEXCUTENOT setFrame:CGRectMake(i*W+12, CGRectGetMaxY(self.policyNum.frame)-10, W, 25)];
            [self addSubview:_btnGRABEXCUTENOT];
            }
            
            if(!_btnGRABNUM&&i==2){
            _btnGRABNUM = [BNPolicyBtn buttonWithType:UIButtonTypeCustom];
            [_btnGRABNUM setFrame:CGRectMake(i*W+12, CGRectGetMaxY(self.policyNum.frame)-10, W, 25)];
            [self addSubview:_btnGRABNUM];
            }
            
            _btn = [BNPolicyBtn buttonWithType:UIButtonTypeCustom];
            [_btn setFrame:CGRectMake(i*W+11, CGRectGetMaxY(self.policyNum.frame)-40, W, 25)];
            [_btn setTitle:i == 0 ? @"已执行" : i == 1 ? @"未执行" :@"公共单池" forState:UIControlStateNormal];
            [self addSubview:_btn];
        }
        
        
        [_btnGRABEXCUTE setTitle:_model.GRABEXCUTE forState:UIControlStateNormal];
        [_btnGRABEXCUTENOT setTitle:_model.GRABEXCUTENOT forState:UIControlStateNormal];
        [_btnGRABNUM setTitle:_model.GRABNUM forState:UIControlStateNormal];

    }
}

- (UIImage *)judgewithSxFlag:(int)flag{
    switch (flag) {
        case 0:
            return [UIImage imageNamed:@"dp_workorder_worry_icon"];
            break;
        case 1:
            return [UIImage imageNamed:@"dp_workorder_carefor_icon"];
            break;
        case 2:
            return [UIImage imageNamed:@"dp_workorder_reassure_icon"];
            break;
     
        
            
        default:
            break;
    }
    return nil;
}

- (UIImage *)judgewithMOFlag:(int)flag{
    switch (flag) {
        case 0:
            return [UIImage imageNamed:@"dp_workorder_worry_icon"];
            break;
        case 1:
            return [UIImage imageNamed:@"dp_workorder_carefor_icon"];
            break;
        
        default:
            break;
    }
    return nil;
}


- (UIImage *)judgewithPoolFlag:(int)flag{
    switch (flag) {
        case 0:
            return [UIImage imageNamed:@"ico_n_03"];
            break;
        case 1:
            return [UIImage imageNamed:@"ico_n_02"];
            break;
        case 2:
            return [UIImage imageNamed:@"ico_n_01"];
            break;
            
        default:
            break;
    }
    return nil;
}
@end
