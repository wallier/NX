//
//  BNProOneModel.h
//  WorkBench
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNReportCellModel.h"

@interface BNProOneModel : BNReportCellModel
/*
 "DEV_NUMBER" = 9511000398394;
 "END_TIME" = 20150625;
 "HF_NO" = 76144521;
 "HF_RESULT" = pps;
 OPERATORS = 40;
 "OPERATORS_DESC" = "\U4e2d\U56fd\U7535\U4fe1";
 "TELE_TYPE" = 5;
 "TELE_TYPE_DESC" = "\U5176\U4ed6";
 */

@property (nonatomic, strong) NSString *DEV_NUMBER;     ///< 业务号码
@property (nonatomic, strong) NSString *END_TIME;       ///< 协议到期时间
@property (nonatomic, strong) NSString *HF_NO;          ///< 回访号
@property (nonatomic, strong) NSString *HF_RESULT;      ///< 回访结果
@property (nonatomic, strong) NSString *OPERATORS;      ///< 运营商
@property (nonatomic, strong) NSString *OPERATORS_DESC; ///< 运营商描述
@property (nonatomic, strong) NSString *TELE_TYPE;      ///<
@property (nonatomic, strong) NSString *TELE_TYPE_DESC; ///<

@end
