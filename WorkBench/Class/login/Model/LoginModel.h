//
//  LoginModel.h
//  text_pch
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNOrderDetailModel.h"
#import "BNLDModel.h"
@interface LoginModel : NSObject

@property (nonatomic,strong) NSString *CALL_CODE;
@property (nonatomic,strong) NSString *MOBILE;
@property (nonatomic,strong) NSString *MSGCODE;
@property (nonatomic,strong) NSString *NAME;
@property (nonatomic,strong) NSString *PARENT_ID;
@property (nonatomic,strong) NSString *PHONE_ID;
@property (nonatomic,strong) NSString *PROVINCE_ID;
@property (nonatomic,strong) NSString *ROLE_CODE;

@property (nonatomic,strong) NSString *USER_NAME;
@property (nonatomic,strong) NSString *USER_ID;
@property (nonatomic,strong) NSString *GENDER;
@property (nonatomic,strong) NSString *ORG_ID;
@property (nonatomic,strong) NSString *ORG_MANAGER_TYPE;
@property (nonatomic,strong) NSString *LOGIN_ID;
@property (nonatomic,strong) NSString *LATEST_ACC_DAY;
@property (nonatomic,strong) NSString *LATEST_ACC_MON;
@property (nonatomic,strong) NSString *MAIN_DEV_TERMINAL_DAY;//我的发展
@property (nonatomic,strong) NSString *MAIN_DEV_TERMINAL_MONTH;
@property (nonatomic,strong) NSString *MAIN_DEV_BROADBAND_DAY;
@property (nonatomic,strong) NSString *MAIN_DEV_BROADBAND_MONTH;

@property (nonatomic,strong) NSString *MAIN_FEE_TERMINAL_MONTH;//我的欠费
@property (nonatomic,strong) NSString *MAIN_FEE_BROADBAND_MONTH;

@property (nonatomic,strong) NSString *MAIN_IN_TERMINAL_MONTH;//我的收入
@property (nonatomic,strong) NSString *MAIN_IN_BROADBAND_MONTH;

@property (nonatomic,strong) NSString *MAIN_PAI_MING;//我的排名
@property (nonatomic,strong) NSString *MAIN_PAI_SHANG_SHEN;

@property (nonatomic, strong) NSArray *CONTRACTS_MAN; //网格信息
@property (nonatomic, strong) NSArray *CONTRACTS_CEO; //CEO信息
@property (nonatomic, strong) BNOrderDetailModel *orderDetail;
@property (nonatomic, strong) BNLDModel *LDModel;

+ (instancetype)shareLoginModel;
- (NSString *)judjeParams;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
