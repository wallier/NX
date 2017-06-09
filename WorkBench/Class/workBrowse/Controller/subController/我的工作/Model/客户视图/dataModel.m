//
//  dataModel.m
//  WorkBench
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "dataModel.h"

@implementation dataModel
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    dataModel *model = [[dataModel  alloc] init];
    [model setValuesForKeysWithDictionary:dictionary];
    return model;

}
@end
