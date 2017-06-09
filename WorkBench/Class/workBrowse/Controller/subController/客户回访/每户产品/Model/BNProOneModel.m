//
//  BNProOneModel.m
//  WorkBench
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNProOneModel.h"

@implementation BNProOneModel
- (NSArray *)getValues{
    if(self.HF_NO && self.TELE_TYPE_DESC) {
        return @[[self judge:self.TELE_TYPE],
                 self.DEV_NUMBER,
                 self.OPERATORS_DESC,
                 self.END_TIME,
                 self.HF_RESULT];
    } else {
        return @[self.DESCS,
                 @"",
                 @"",
                 @"",
                 @"",];
    }
}

- (NSString *)judge:(NSString *)type{
    if ([type isEqualToString:@"1"]) {
        return @"移动手机";
    } else if ([type isEqualToString:@"2"]){
        return @"无线宽带";
    }else if ([type isEqualToString:@"3"]){
        return @"固话";
    }else if ([type isEqualToString:@"4"]){
        return @"宽带";
    }else if ([type isEqualToString:@"4.5"]){
        return @"ITV";
    }else if ([type isEqualToString:@"4.6"]){
        return @"光纤、电路";
    }else if ([type isEqualToString:@"5"]){
        return @"其他";
    }else {
        return @"";
    }
}
@end
