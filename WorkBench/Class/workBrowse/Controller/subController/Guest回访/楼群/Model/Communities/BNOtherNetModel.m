//
//  BNOtherNetModel.m
//  WorkBench
//
//  Created by wouenlone on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNOtherNetModel.h"

@implementation BNOtherNetModel
- (instancetype) initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    self.REDION_NAME = dic[@"REDION_NAME"];
    self.BUILDING_NO = dic[@"BUILDING_NO"];
    self.UNIT_NO = dic[@"UNIT_NO"];
    self.ROOT_NO = dic[@"ROOT_NO"];
    self.FIND_TIME = dic[@"FIND_TIME"];
    self.FIND_PERSON = dic[@"FIND_PERSON"];
    return self;
}

@end
