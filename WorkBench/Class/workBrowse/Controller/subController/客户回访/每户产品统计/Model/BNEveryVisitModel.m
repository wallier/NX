//
//  BNEveryVisitModel.m
//  WorkBench
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNEveryVisitModel.h"

@implementation BNEveryVisitModel
- (NSArray *)getValues{
    if(self.DANYUAN && self.HF_TIME) {
        return @[self.LOUHAO,
                 self.DANYUAN,
                 self.FANGHAO,
                 self.PROD_COUNT,
                 self.IS_HUIFANG,
                 self.HF_TIME];
    } else {
        return @[self.DESCS,
                 @"",
                 @"",
                 @"",
                 @"",];
    }
}

@end
