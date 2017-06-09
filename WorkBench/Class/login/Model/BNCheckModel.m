//
//  BNCheckModel.m
//  WorkBench
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNCheckModel.h"

@implementation BNCheckModel

+(instancetype)initWitchDicitionary:(NSDictionary *)dictionary{
    BNCheckModel *login = [[BNCheckModel alloc] init];
    [login setValuesForKeysWithDictionary:dictionary];
    return login;
}

@end
