//
//  BNProductModel.m
//  WorkBench
//
//  Created by wouenlone on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNProductModel.h"
#import "MBProgressHUD+Extend.h"

@implementation BNProductModel
+ (NSArray *)getProductModelFromDic:(NSDictionary *)dic
{
    NSMutableArray *muArray = [NSMutableArray array];
    NSArray *array = [NSArray array];
    array = dic[@"RESULT"];
    if (array.count == 0) {
        [MBProgressHUD showError:@"无数据"];
        return nil;
    }
    for (NSDictionary *dict in dic[@"RESULT"]) {
        BNProductModel *mode = [[BNProductModel alloc]init];
        mode.PRODUCT_ID = dict[@"PRODUCT_ID"];
        mode.PRODUCT_TYPE = dict[@"PRODUCT_TYPE"];
        mode.OPERATOR_TYPE = dict[@"OPERATOR_TYPE"];
        mode.USER_NUMBER = dict[@"USER_NUMBER"];
        mode.PACKAGE_MEAL = dict[@"PACKAGE_MEAL"];
        mode.EXPIRE = dict[@"EXPIRE"];
        mode.PRODUCT_RATE = dict[@"PRODUCT_RATE"];
        mode.IS_OCCUPY = dict[@"IS_OCCUPY"];
        mode.note = dict[@"REMARKS"];
        [muArray addObject:mode];
    }
    return [muArray copy];
}
@end
