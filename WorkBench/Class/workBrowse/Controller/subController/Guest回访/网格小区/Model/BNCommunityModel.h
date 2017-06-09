//
//  BNCommunityModel.h
//  WorkBench
//
//  Created by wanwan on 16/8/23.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNCommunityModel : NSObject
/** 小区ID */
@property (nonatomic, strong) NSString *REGION_ID;
/** 本网用户 */
@property (nonatomic, strong) NSString *SELF_WLAN;
/** 小区名字 */
@property (nonatomic, strong) NSString *REDION_NAME;
/** 异网用户 */
@property (nonatomic, strong) NSString *OTHER_WLAN;

/** 化小ID */
@property (nonatomic, strong) NSString *HX_ID;
@property (nonatomic, strong) NSString *OTHER_WLAN_ITV;
@property (nonatomic, strong) NSString *OTHER_WLAN_KD;
@property (nonatomic, strong) NSString *SELF_WLAN_ITV;
@property (nonatomic, strong) NSString *SELF_WLAN_KD;
/** 网格ID */
@property (nonatomic, strong) NSString *WG_ID;

@end
