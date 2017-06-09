//
//  KHCellModel.m
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "KHCellModel.h"

@implementation KHCellModel

+(instancetype)initKHCellModel:(NSDictionary *)dic{
    /*
     "ACC_NAME" = "\U56fd\U5185\U77ed\U4fe1\U6761\U6570";
     "BILLING_CYCLE_ID" = 201510;
     "OFFER_AMOUNT" = "30.0";
     "OFFER_NAME" = "\U5bb6\U5ead\U8ba1\U5212";
     UNIT = "(\U6761)";
     USELV = "7%";
     VALUE = "2.0";
     */
    KHCellModel *cellModel = [[self alloc] init];
    cellModel.unit = dic[@"UNIT"];
    cellModel.isused = dic[@"VALUE"];
    cellModel.text_head = dic[@"OFFER_NAME"];
    cellModel.text_top = dic[@"ACC_NAME"];
    cellModel.text_bottom = dic[@"OFFER_AMOUNT"];
    cellModel.text_right = dic[@"USELV"];
    return cellModel;
}

-(void)setFootView:(UIView *)footView{
    _footView = footView;

}

-(void)setHeadView:(UIView *)headView{
    _headView = headView;
}
@end
