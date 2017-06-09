//
//  BNPolicyModel.h
//  WorkBench
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "POLICY_ID" = 36244;
 "POLICY_NAME" = "2015-\U4e34\U65f6\U5916\U547c-\U8bed\U97f3";
 "SAN_FALG" = 03;
 "SERVICE_TYPE" = 1001;
 "START_DATE" = 201503;
 "TASK_ID" = 100101;
 "TASK_NAME" = "\U5b58\U91cf\U7ef4\U7cfb";
 "USER_NUM" = 1437;
 }
 
 "CX_NUM" = 65;
 "FX_NUM" = 835;
 "GX_NUM" = 672;
 "POLICY_ID" = 36244;
 "POLICY_NAME" = "2015-\U4e34\U65f6\U5916\U547c-\U8bed\U97f3";
 "SERVICE_TYPE" = 1001;
 "START_DATE" = 201503;
 "TASK_ID" = 100101;
 "TASK_NAME" = "\U5b58\U91cf\U7ef4\U7cfb";
 "USER_NUM" = 2615;


 */
@interface BNPolicyModel : NSObject
@property (nonatomic, strong) NSString *POLICY_ID;      ///<策略ID
@property (nonatomic, strong) NSString *POLICY_NAME;    ///<策略名
@property (nonatomic, strong) NSString *SAN_FALG;       ///<三心标志
@property (nonatomic, strong) NSString *SERVICE_TYPE;   ///<类型
@property (nonatomic, strong) NSString *START_DATE;     ///<开始日期
@property (nonatomic, strong) NSString *TASK_ID;        ///<任务ID
@property (nonatomic, strong) NSString *TASK_NAME;      ///<任务名称
@property (nonatomic, strong) NSString *USER_NUM;       ///<工单总数
@property (nonatomic, strong) NSString *CX_NUM;       ///<操心总数
@property (nonatomic, strong) NSString *FX_NUM;       ///<放心总数
@property (nonatomic, strong) NSString *GX_NUM;       ///<关心总数

@property (nonatomic, strong) NSString *UNGRABNUM;       ///<未抢单


@property (nonatomic, strong) NSString *ONLINE_USER_NUM;   ///<在线人数  此功能未开发完毕 只是 预留字段
@property (nonatomic, strong) NSString *TOP_USER_LIMIT;     ///<上线人数

@property (nonatomic, strong) NSString *GRABEXCUTE;     ///<已执行数
@property (nonatomic, strong) NSString *GRABEXCUTENOT;   ///<未执行数
@property (nonatomic, strong) NSString *GRABNUM;       ///<已抢单 工单池数


@end
