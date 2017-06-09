//
//  BNNewsModel.m
//  WorkBench
//
//  Created by wanwan on 16/10/19.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNNewsModel.h"

@implementation BNNewsModel

+ (NSArray *)getPackageArray:(NSArray *)dicArr {
    NSMutableArray *mutArr = [NSMutableArray array];
    for (NSDictionary *dic in dicArr ) {
        BNNewsModel *newsModel = [BNNewsModel new];
        [newsModel setValuesForKeysWithDictionary:dic];
        [mutArr addObject:newsModel];
    }
    return [mutArr copy];
}

@end
