//
//  BNAddRecordModel.m
//  WorkBench
//
//  Created by mac on 16/3/1.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNAddRecordModel.h"
static BNAddRecordModel *model ;
@implementation BNAddRecordModel
+ (instancetype)shareInstance{
    if (!model) {
        model = [[BNAddRecordModel alloc] init];
        return model;
    }
    return model;
}
@end
