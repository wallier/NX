//
//  BNOrderBaseModel.h
//  WorkBench
//
//  Created by mac on 16/2/2.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "END_DATE" = "";
 "OFFER_NAME" = "\U65e0";
 "ORDER_PROD_LINK" = 18995060180;
 "ORDER_STATE" = 1;
 "POLICY_TEXT" = "\U6682\U672a\U914d\U7f6e\U76f8\U5173\U6a21\U677f\U3002";
 "SAN_FALG" = 03;
 "START_DATE" = "";
 "USER_ACCR" = 18995060180;
 "USER_ID" = 60063352;
 "USER_NAME" = "\U5f20\U54f2\U5b9c";
 "USER_TERMINAL" = "\U534e\U4e3a-HW-HUAWEI NXT AL10";
 */
@interface BNOrderBaseModel : NSObject
@property (nonatomic, strong) NSString *END_DATE;
@property (nonatomic, strong) NSString *OFFER_NAME;
@property (nonatomic, strong) NSString *ORDER_PROD_LINK;
@property (nonatomic, strong) NSString *ORDER_STATE;
@property (nonatomic, strong) NSString *POLICY_TEXT;
@property (nonatomic, strong) NSString *SAN_FALG;
@property (nonatomic, strong) NSString *START_DATE;
@property (nonatomic, strong) NSString *USER_ACCR;
@property (nonatomic, strong) NSString *USER_ID;
@property (nonatomic, strong) NSString *USER_NAME;
@property (nonatomic, strong) NSString *USER_TERMINAL;
@property (nonatomic, strong) NSString *USER_INTEREST;      ///<用户介绍
@property (nonatomic, strong) NSString *IS_FORWARD_SEND;      ///<用户介绍

@end
