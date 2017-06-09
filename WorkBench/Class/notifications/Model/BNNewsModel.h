//
//  BNNewsModel.h
//  WorkBench
//
//  Created by wanwan on 16/10/19.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNNewsModel : NSObject

/** 运营商（电信：1，移动：2，联通：3，广电：4，未知：5） */
@property (nonatomic, strong) NSString *OPERATOR_TYPE;
/** 套餐名称 */
@property (nonatomic, strong) NSString *PACKAGE_MEAL;
/** 小区名称 */
@property (nonatomic, strong) NSString *REDION_NAME;
/** 小区地址 */
@property (nonatomic, strong) NSString *REDION_ADDRESS;
/** 楼号 */
@property (nonatomic, strong) NSString *BUILDING_NO;
/** 楼类型（住宅、公寓、商业、其他）） */
@property (nonatomic, strong) NSString *BUILDING_TYPE;
/** 用户所属单元编号 */
@property (nonatomic, strong) NSString *UNIT_NO;
/** 用户门牌号 */
@property (nonatomic, strong) NSString *ROOT_NO;
/** 到期时间 */
@property (nonatomic, strong) NSString *EXPIRE;
/** 客户姓名 */
@property (nonatomic, strong) NSString *CUST_NAME;
/** 联系电话 */
@property (nonatomic, strong) NSString *REL_PHONE;

/** 返回套餐到期提醒 */
+ (NSArray *)getPackageArray:(NSArray *)dicArr;
@end
