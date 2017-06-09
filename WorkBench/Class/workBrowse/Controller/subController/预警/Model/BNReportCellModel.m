//
//  BNReportCellModel.m
//  WorkBench
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNReportCellModel.h"

@implementation BNReportCellModel
- (NSArray *)getValues{
    if(self.SERV_CNT_20) {
        return @[self.DESCS,
             self.SERV_CNT_20,
             self.SERV_CNT_20_ZGD,
                 self.SERV_CNT_50,
                 self.SERV_CNT_50_ZGD];
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
