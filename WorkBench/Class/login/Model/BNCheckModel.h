//
//  BNCheckModel.h
//  WorkBench
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNCheckModel : NSObject
/*
 调用结果	code                    字符串	        0000 调用成功。
 结果说明	msg                     字符串	        调用结果说明
 虚拟节点	data                    JSONObject	虚拟节点
 认证结果	valid_result            字符串	AT00    验证成功  AT01 验证失败
 认证结果说明	valid_result_msg    字符串
 用户标识	user_id                 字符串
 用户姓名	user_name               字符串
 登录帐号	login_code              字符串
 本地网标识	latn_id             字符串
 手机号码	acc_nbr	字符串
 邮件地址	email_addr              字符串
 票据生效日期	eff_date            字符串	验证成功时反馈  格式： YYYY-MM-DD HH24:MI:SS
 票据失效日期	exp_date            字符串	登录成功时反馈  格式： YYYY-MM-DD HH24:MI:SS
 */

@property (nonatomic,strong)NSString *department_name;
@property (nonatomic,strong)NSString *department_id;
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *user_name;
@property (nonatomic,strong)NSString *login_code;
@property (nonatomic,strong)NSString *latn_id;
@property (nonatomic,strong)NSString *latn_name;
@property (nonatomic,strong)NSString *identity_no;
@property (nonatomic,strong)NSString *acc_nbr;
@property (nonatomic,strong)NSString *email_addr;
@property (nonatomic,strong)NSString *eff_date;
@property (nonatomic,strong)NSString *exp_date;
@property (nonatomic,strong)NSString *staff_code;
@property (nonatomic,strong)NSString *sex;

+(instancetype)initWitchDicitionary:(NSDictionary *)dictionary;

@end
