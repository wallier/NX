//
//  BNOrderDetailModel.h
//  WorkBench
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "IS_FORWARD_SEND" = 0;
 "ORDER_NO" = 6231684;
 "ORDER_STATE" = 1;
 "OVER_DATE" = 51;
 "POLICY_ID" = 36244;
 "SAN_FALG" = 03;
 "SERVICE_TYPE" = 1001;
 "START_DATE" = 201503;
 "STATE_EXECUTE_PERSON" = "";
 "TASK_ID" = 100101;
 "TOTAL_NUM" = 187;
 "USER_ACCR" = 18152488376;
 "USER_ID" = 505158025;
 "USER_NAME" = "\U9648\U6d77\U6d9b";

 */
@interface BNOrderDetailModel : NSObject
@property (nonatomic, strong) NSString *IS_FORWARD_SEND;    ///<是否转派
@property (nonatomic, strong) NSString *ORDER_NO;           ///<工单号
@property (nonatomic, strong) NSString *ORDER_STATE;        ///<工单状态

@property (nonatomic, strong) NSString *OVER_DATE;          ///<过期时间
@property (nonatomic, strong) NSString *POLICY_ID;          ///<策略ID
@property (nonatomic, strong) NSString *SAN_FALG;           ///<三心标识

@property (nonatomic, strong) NSString *SERVICE_TYPE;       ///<服务类型
@property (nonatomic, strong) NSString *START_DATE;         ///<开始日期
@property (nonatomic, strong) NSString *STATE_EXECUTE_PERSON;   ///<

@property (nonatomic, strong) NSString *TASK_ID;            ///<任务ID
@property (nonatomic, strong) NSString *TOTAL_NUM;          ///<总数
@property (nonatomic, strong) NSString *USER_ACCR;          ///<用户号码
@property (nonatomic, strong) NSString *USER_ID;            ///<用户ID
@property (nonatomic, strong) NSString *USER_NAME;          ///<用户名称
@property (nonatomic, strong) NSString *USER_INTEREST;      ///<用户介绍

@end
