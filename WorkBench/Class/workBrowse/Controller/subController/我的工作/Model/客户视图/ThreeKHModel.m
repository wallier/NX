//
//  ThreeKHModel.m
//  WorkBench
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "ThreeKHModel.h"

@implementation ThreeKHModel
/*
 "ACCOUNT_TYPE" = "C\U7f51_\U4e3b\U4ea7\U54c1\U5957\U9910\U8d39_\U53d1\U751f";
 "ACCT_MONTH" = 201510;
 "COST_TYPE" = 2;
 "INVOICE_ITEMS" = "\U6708\U4f7f\U7528\U8d39";
 STATE = "\U5df2\U9500\U5e10";
 */
+(instancetype)initKHCellModel:(NSDictionary *)dic{
    
    ThreeKHModel *mid = [[self alloc] init];
    mid.text_right = dic[@"STATE"];
    if([dic[@"ACCOUNT_TYPE"] length] > 12){
        NSString *str = [dic[@"ACCOUNT_TYPE"] substringToIndex:12];
        NSString *str2 = [dic[@"ACCOUNT_TYPE"] substringFromIndex:12];
        mid.text_top = [NSString stringWithFormat:@"%@\n%@ %@",str,str2,dic[@"COST_TYPE"]];
    } else {
    mid.text_top = [NSString stringWithFormat:@"%@ %@",dic[@"ACCOUNT_TYPE"],dic[@"COST_TYPE"]];
    }
    return mid;
}
@end
