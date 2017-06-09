//
//  BNValueModel.h
//  WorkBench
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "ACCT_ARPU" = "51.25";
 "ACCT_FEE" = "63.02";
 "ACC_NBR" = 13309518886;
 "CUST_ID" = 11908464;
 "CUST_NAME" = "\U97e9\U534e";
 FEE = "22.94";
 "FLOW_FLUX" = 0;
 "MAIN_OFFER_NAME" = "201306\U4e50\U4eab3G\U5957\U9910\U804a\U5929\U7248129\U5143";
 "PHONE_MODEL" = "\U6469\U6258\U7f57\U62c9-MOT-XT800";
 SEX = "\U7537";
 "UNION_ORG_NAME" = "\U91d1\U51e4-\U6c11\U751f\U82b1\U56ed\U7f51\U683c";
 "USER_ID" = 61073225;
 "VALUE_LEVEL_FLAG" = "\U4e2d";
 
 */
@interface BNValueModel : NSObject


@property (nonatomic, strong) NSString *ACCT_ARPU;
@property (nonatomic, strong) NSString *ACCT_FEE;
@property (nonatomic, strong) NSString *ACC_NBR;

@property (nonatomic, strong) NSString *CUST_ID;
@property (nonatomic, strong) NSString *CUST_NAME;
@property (nonatomic, strong) NSString *FEE;

@property (nonatomic, strong) NSString *FLOW_FLUX;
@property (nonatomic, strong) NSString *MAIN_OFFER_NAME;
@property (nonatomic, strong) NSString *PHONE_MODEL;

@property (nonatomic, strong) NSString *SEX;
@property (nonatomic, strong) NSString *UNION_ORG_NAME;
@property (nonatomic, strong) NSString *USER_ID;
@property (nonatomic, strong) NSString *VALUE_LEVEL_FLAG;

@end
