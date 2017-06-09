//
//  FourKHModel.m
//  WorkBench
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "FourKHModel.h"

@implementation FourKHModel
+ (instancetype)initKHCellModel:(NSDictionary *)dic{
    FourKHModel *model = [[FourKHModel alloc] init];
    model.text_top = dic[@"OFFER_NAME"];
    model.text_bottom = [NSString stringWithFormat:@"%@...  %@ 至 %@",[dic[@"OFFER_DESCRIPTION"] length]
                         > 7 ?[dic[@"OFFER_DESCRIPTION"] substringToIndex:
                        7]:dic[@"OFFER_DESCRIPTION"],dic[@"EFF_DATE"],dic[@"EXP_DATE"]];
    
    return model;
}
@end
