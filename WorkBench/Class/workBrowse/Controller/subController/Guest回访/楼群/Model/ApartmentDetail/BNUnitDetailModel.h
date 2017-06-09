//
//  BNUnitDetailModel.h
//  WorkBench
//
//  Created by wanwan on 16/8/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNUnitDetailModel : NSObject
// BUILDING_ID --> 小区楼宇唯一标识
@property (nonatomic, strong) NSString *BUILDING_ID;
//ROOT_NO --> 门牌号
@property (nonatomic, strong) NSString *ROOT_NO;
//OPERATOR_TYPE --> 运营商类型（电信：1，移动：2，联通：3，未知：4）
@property (nonatomic, strong) NSString *OPERATOR_TYPE;
//USER_NUM --> 用户数
@property (nonatomic, strong) NSString *USER_NUM;
//PRO_NUM --> 产品数（如果大于1就为混合产品，等于1则为单产品）
@property (nonatomic, strong) NSString *PRO_NUM;
@property (nonatomic, strong) NSString *BUILDING_NO;
@property (nonatomic, strong) NSString *GD_WLAN_ITV;
@property (nonatomic, strong) NSString *GD_WLAN_KD;
@property (nonatomic, strong) NSString *GD_WLAN_SJ;
@property (nonatomic, strong) NSString *LT_WLAN_ITV;
@property (nonatomic, strong) NSString *LT_WLAN_KD;
@property (nonatomic, strong) NSString *LT_WLAN_SJ;
@property (nonatomic, strong) NSString *QT_WLAN_ITV;
@property (nonatomic, strong) NSString *QT_WLAN_KD;
@property (nonatomic, strong) NSString *QT_WLAN_SJ;
@property (nonatomic, strong) NSString *SELF_WLAN_ITV;
@property (nonatomic, strong) NSString *SELF_WLAN_KD;
@property (nonatomic, strong) NSString *SELF_WLAN_SJ;
@property (nonatomic, strong) NSString *YD_WLAN_ITV;
@property (nonatomic, strong) NSString *YD_WLAN_KD;
@property (nonatomic, strong) NSString *YD_WLAN_SJ;
@end
