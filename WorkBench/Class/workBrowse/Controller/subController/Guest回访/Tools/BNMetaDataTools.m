//
//  BNMetaDataTools.m
//  WorkBench
//
//  Created by wanwan on 16/8/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNMetaDataTools.h"
#import "BNGridMedol.h"
@implementation BNMetaDataTools

+ (NSArray *)getGridModelArray:(NSArray *)dicArr {
    NSMutableArray *mutArr = [NSMutableArray array];
    for (NSDictionary *dic in dicArr ) {
        BNGridMedol *gridModel = [BNGridMedol new];
        [gridModel setValuesForKeysWithDictionary:dic];
        [mutArr addObject:gridModel];
        NSLog(@"****%@",gridModel);
    }
    return [mutArr copy];

}
@end
