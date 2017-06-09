//
//  BNCommunityContentModel.h
//  WorkBench
//
//  Created by wouenlone on 16/8/14.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "BNBuildingModel.h"
#import <Foundation/Foundation.h>

@interface BNCommunityContentModel : NSObject
@property (nonatomic, copy) NSString *name;
//端口总数
@property (nonatomic,copy) NSString *allPortsAmount;
//已用端口数
@property (nonatomic,strong) NSString *usedPorts;

@property (nonatomic, strong) NSString *GRID_NO;    ///< 网格号

@property (nonatomic, strong) NSString *OTHER_USER; ///< 其他
@property (nonatomic, copy) NSString *community_ID;  ///< 小区ID
@property (nonatomic,copy) NSString *usageRate_ofPorts;//端口使用率
@property (nonatomic,copy) NSString *userAmount_ofThisNet;//本网用户数
@property (nonatomic,copy) NSString *userAmount_ofOtherNet;//异网用户数
@property (nonatomic,assign) NSInteger otherNetAmount;//它网占用



////初始化得到小区对象
//- (instancetype)initWithCommunityName:(NSString *)name;
////根据小区名称得到所有的住宅楼的信息
//- (NSArray *)getAllBuildingUseCommunityName:(NSString*)communityName;
////根据小区名称得到 总端口数 已用端口 和使用率
//- (NSDictionary *)getPortsAndUsedPortsAndUsageRateByCommunityName:(NSString *)communityName;

@end
