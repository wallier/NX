//
//  BNRecordModel.m
//  WorkBench
//
//  Created by mac on 16/2/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNRecordModel.h"

@implementation BNRecordModel

- (NSArray *)getValues{
    if(self.XIAOQU_NAME && self.HF_TIME) {
        return @[self.XIAOQU_NAME,
                 self.LOUHAO,
                 self.DANYUAN,
                 self.FANGHAO,
                 self.HF_TIME
                 ];
    } else {
        return nil;
    }
}

@end
