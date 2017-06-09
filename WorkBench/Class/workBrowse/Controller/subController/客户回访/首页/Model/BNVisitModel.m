//
//  BNVisitModel.m
//  WorkBench
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNVisitModel.h"

@implementation BNVisitModel
- (NSArray *)getValues{
    if(self.ADSL_USER && self.M_USER) {
        return @[self.XIAOQU_NAME,
                 self.M_USER,
                 self.ADSL_USER,
                 self.GH_USER,
                 self.ITV_USER,self.OTHER_USER];
    } else if (self.BRD_CNT){
        return @[self.DESCS,
                 self.BRD_CNT,
                 self.BRD_CNT_ZGD,
                 self.MBL_CNT,
                 self.MBL_CNT_ZGD];
    } else {
        return @[self.DESCS,
                 @"",
                 @"",
                 @"",
                 @"",];
    }
}

@end
