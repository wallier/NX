//
//  BNUnitSummaryModel.h
//  WorkBench
//
//  Created by wanwan on 16/8/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNUnitSummaryModel : NSObject
//UNIT_NUM --> 单元数
@property (nonatomic, strong) NSString *UNIT_NUM;
//FLOOR_NUM --> 楼层数
@property (nonatomic, strong) NSString *FLOOR_NUM;
//ONE_FLOOR_HOUSES --> 每层户数
@property (nonatomic, strong) NSString *ONE_FLOOR_HOUSES;
//BUILDING_ID -->小区楼宇唯一标识
@property (nonatomic, strong) NSString *BUILDING_ID;
@end
