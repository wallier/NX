//
//  BNPoolTableViewCell.m
//  WorkBench
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNPoolTableViewCell.h"

@implementation BNPoolTableViewCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = [UIColor blueColor].CGColor;
}

- (void)setModel:(BNPoolItemModel *)model{
    _model = model;
    [self setValue];
}

- (void)setValue{
    [self.deveBtn setTitle:[NSString stringWithFormat:@"发展机会\n%@个",self.model.DEV_CHANCE_NUM] forState:UIControlStateNormal];
    self.deveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.lab_cx setText:self.model.CX];
    self.lab_cx.width = [self.model.CX_PER floatValue] * 0.01 *self.lab_cx.width ;
    [self.cx_per setText:self.model.CX_PER];
    self.cx_per.x = CGRectGetMaxX(self.lab_cx.frame) + 2;
    
    [self.lab_gx setText:self.model.GX];
    self.lab_gx.width = [self.model.GX_PER floatValue] * 0.01  * self.lab_gx.width ;
    [self.gx_per setText:self.model.GX_PER];
    self.gx_per.x = CGRectGetMaxX(self.lab_gx.frame) + 2;

    
    [self.lab_fx setText:self.model.FX];
    self.lab_fx.width = [self.model.FX_PER floatValue] * 0.01  * self.lab_fx.width ;
    [self.fx_per setText:self.model.FX_PER];
    self.fx_per.x = CGRectGetMaxX(self.lab_fx.frame) + 2;
    

    
    [self.lab_oderNum setText:self.model.USER_NUM];
    [self.typeNum setText:self.model.USER_NUM];
    switch ([self.model.SERVICE_TYPE intValue]) {
        case 1001:
            self.img.image = [UIImage imageNamed:@"ico_mobile"];
            [self.type setText:@"移动"];
            break;
        case 1002:
            self.img.image = [UIImage imageNamed:@"ico_board"];
            [self.type setText:@"宽带"];
            break;
        case 1003:
            self.img.image = [UIImage imageNamed:@"ico_tv"];
            [self.type setText:@"ITV"];

        default:
            self.img.image = [UIImage imageNamed:@"dp_workorder_carefor_icon"];
            [self.type setText:@"未知类型"];
            [self.type setFont:[UIFont systemFontOfSize:10]];
            break;
    }

};

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)getCxOrder:(id)sender {
    if ([self.delegate respondsToSelector:@selector(finishedClick:andServiceType:)]) {
        [self.delegate finishedClick:@"01" andServiceType:self.model.SERVICE_TYPE];
    }
}
- (IBAction)getGxOrider:(id)sender {
    if ([self.delegate respondsToSelector:@selector(finishedClick:andServiceType:)]) {
        [self.delegate finishedClick:@"02" andServiceType:self.model.SERVICE_TYPE];
    }

}
- (IBAction)getFxOrder:(id)sender {
    if ([self.delegate respondsToSelector:@selector(finishedClick:andServiceType:)]) {
        [self.delegate finishedClick:@"03" andServiceType:self.model.SERVICE_TYPE];
    }

}
- (IBAction)getAllOrder:(id)sender {
    if ([self.delegate respondsToSelector:@selector(finishedClickGetAllOrder:)]) {
        [self.delegate finishedClickGetAllOrder:self.model.SERVICE_TYPE];
    }
}

- (IBAction)getDevelopOrder:(id)sender {
    if ([self.delegate respondsToSelector:@selector(finishedClickGetDevelopOrder:)]) {
        [self.delegate finishedClickGetDevelopOrder:self.model.SERVICE_TYPE];
    }
}
@end
