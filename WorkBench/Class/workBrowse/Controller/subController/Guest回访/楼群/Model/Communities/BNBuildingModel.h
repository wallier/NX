//
//  BNBuildingModel.h
//  WorkBench
//
//  Created by wouenlone on 16/8/14.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
/*某小区的 一栋住宅楼模型*/
#import <Foundation/Foundation.h>

@interface BNBuildingModel : NSObject

@property (nonatomic,copy) NSString *BUILDING_NO;//楼号
@property (nonatomic,copy) NSString *USE_PERSENT;//使用率
@property (nonatomic,copy) NSString *PORT_ALL_NUM;//端口总数
@property (nonatomic,copy) NSString *PORT_OCCUPY_NUM;//已用端口数
@property (nonatomic,copy) NSString *BUILDING_ID;//楼的ID
@property (nonatomic,copy) NSString *OTHER_WLAN_NUM;//他网占用数量
@property (nonatomic,copy) NSString *BUILDING_TYPE;//楼类型-住宅、公寓、商业、其他



@property (nonatomic, copy) NSString *PORT_LAST_NUM;//剩余端口数
@property (nonatomic, copy) NSString *ALL_ROOM_NUM;//房间数  1号楼旁边 括号中数字
@property (nonatomic, copy) NSString *SELF_WLAN_KD;//电信宽带
@property (nonatomic, copy) NSString *SELF_WLAN_ITV;//电信ITV
@property (nonatomic, copy) NSString *SELF_WLAN_SJ;//电信手机
@property (nonatomic, copy) NSString *OTHER_WLAN_KD;//异网宽带
@property (nonatomic, copy) NSString *OTHER_WLAN_ITV;//异网电视
@property (nonatomic, copy) NSString *OTHER_WLAN_SJ;//异网手机

+(NSArray *)getAllBuildingInCommunityWithArray:(NSArray *)array;
@end
