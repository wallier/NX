//
//  BNMetaDataTools.m
//  WorkBench
//
//  Created by wanwan on 16/8/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNMetaDataTools.h"
//#import "BNAllGridModel.h"
#import "BNGridRoleModel.h"
#import "BNCommunityModel.h"
#import "BNAllCommunityModel.h"
#import "BNUnitSummaryModel.h"
#import "BNUnitDetailModel.h"

@implementation BNMetaDataTools
+ (NSArray *)getGridRoleModelArray:(NSArray *)dicArr{
    NSMutableArray *mutArr = [NSMutableArray array];
    for (NSDictionary *dic in dicArr ) {
        BNGridRoleModel *gridRoleModel = [BNGridRoleModel new];
        [gridRoleModel setValuesForKeysWithDictionary:dic];
        [mutArr addObject:gridRoleModel];
    }
    return [mutArr copy];
    
}

//+ (NSArray *)getAllGridModelArray:(NSArray *)dicArr {
//    NSMutableArray *mutArr = [NSMutableArray array];
//    for (NSDictionary *dic in dicArr ) {
//        BNAllGridModel *gridModel = [BNAllGridModel new];
//        [gridModel setValuesForKeysWithDictionary:dic];
//        [mutArr addObject:gridModel];
//    }
//    return [mutArr copy];
//
//}

+ (NSArray *)getCommunityModelArray:(NSArray *)dicArr {
    NSMutableArray *mutArr = [NSMutableArray array];
    for (NSDictionary *dic in dicArr ) {
        NSLog(@"dic---%@",dic);
        BNCommunityModel *communityModel = [BNCommunityModel new];
        [communityModel setValuesForKeysWithDictionary:dic];
        [mutArr addObject:communityModel];
    }
    return [mutArr copy];
    
}

+ (NSArray *)getAllCommunityModelArray:(NSArray *)dicArr {
    NSMutableArray *mutArr = [NSMutableArray array];
    for (NSDictionary *dic in dicArr ) {
        BNAllCommunityModel *allCommunityModel = [BNAllCommunityModel new];
        [allCommunityModel setValuesForKeysWithDictionary:dic];
        [mutArr addObject:allCommunityModel];
    }
    return [mutArr copy];
    
}

+ (NSArray *)getUnitSummaryModelArray:(NSArray *)dicArr {
    NSMutableArray *mutArr = [NSMutableArray array];
    for (NSDictionary *dic in dicArr ) {
        BNUnitSummaryModel *unitModel = [BNUnitSummaryModel new];
        [unitModel setValuesForKeysWithDictionary:dic];
        [mutArr addObject:unitModel];
    }
    return [mutArr copy];
    
}

+ (NSArray *)getUnitDetailModelArray:(NSArray *)dicArr {
    NSMutableArray *mutArr = [NSMutableArray array];
    for (NSDictionary *dic in dicArr ) {
        NSLog(@"apptest001--%@",dic);
        BNUnitDetailModel *unitDetailModel = [BNUnitDetailModel new];
        [unitDetailModel setValuesForKeysWithDictionary:dic];
        [mutArr addObject:unitDetailModel];
    }
    return [mutArr copy];
}

@end
