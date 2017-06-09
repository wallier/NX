//
//  BNLDModel.h
//  WorkBench
//
//  Created by mac on 16/2/16.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *   
 "OFFER_BRAND" = "\U4e50\U4eab4G59\U5143-\U4e3b\U5957\U9910";
 "ORDER_PROD_LINK" = 18995195268;
 "ORDER_STATE" = 2;
 "RH_TYPE" = "\U5426";
 "SAN_FALG" = 03;
 "START_DATE" = "2013-03-31 00:03:00";
 "TERMINAL_INTEREST" = "\U4e2d\U9ad8\U7aef";
 "USER_ACCR" = 18995195268;
 "USER_INTEREST" = "\U4ed8\U8d39\U7c7b\U578b\Uff1a\U51c6\U5b9e\U65f6\U9884\U4ed8\U8d39";
 "USER_KIND" = "\U5ba2\U6237\U5206\U7fa4\Uff1a\U4e2a\U4eba";
 "USER_NAME" = "\U7ae5\U5609\U5b81";
 "USER_SEX" = "\U7537";

 */
@interface BNLDModel : NSObject
@property (nonatomic, strong) NSString *OFFER_BRAND;        ///< 套餐
@property (nonatomic, strong) NSString *ORDER_PROD_LINK;    ///< 联系电话
@property (nonatomic, strong) NSString *ORDER_STATE;        ///< 工单状态
@property (nonatomic, strong) NSString *RH_TYPE;            ///< 融合标志
@property (nonatomic, strong) NSString *SAN_FALG;           ///< 三心标志
@property (nonatomic, strong) NSString *START_DATE;         ///< 套餐开始时间
@property (nonatomic, strong) NSString *TERMINAL_INTEREST;  ///< 终端偏好
@property (nonatomic, strong) NSString *USER_ACCR;          ///< 电话号码
@property (nonatomic, strong) NSString *USER_INTEREST;      ///< 人士
@property (nonatomic, strong) NSString *USER_KIND;          ///< 客户类型
@property (nonatomic, strong) NSString *USER_NAME;          ///< 客户姓名
@property (nonatomic, strong) NSString *USER_SEX;           ///< 客户性别


@end
