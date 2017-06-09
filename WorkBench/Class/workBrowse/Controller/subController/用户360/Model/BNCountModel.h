//
//  BNCountModel.h
//  WorkBench
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *
 "ACC_NBR" = 13309518886;
 "CALLING_UP_1" = "****,****,****";
 "CALL_OBJ_NUM" = "0\U6237/\U6708";
 "CUST_ID" = 11908464;
 "CUST_NAME" = "\U97e9\U534e";
 "H_FLAG" = "[\U9ad8,\U65e0\U6b20\U8d39,\U65e0\U5408\U7ea6]";
 "INNET_MONTH" = 56;
 "IS_FPCARD" = "\U5426";
 "OWE_FEE" = 0;
 "RH_INFO" = "\U878d\U5408[\U67092\U4e2a\U5bbd\U5e26]";
 SEX = "\U7537";
 "TERM_AGE" = 32;
 "TREATY_FLAG" = "\U5426";
 */
@interface BNCountModel : NSObject

@property (nonatomic, strong) NSString *ACC_NBR;
@property (nonatomic, strong) NSString *CALLING_UP_1;
@property (nonatomic, strong) NSString *CALL_OBJ_NUM;

@property (nonatomic, strong) NSString *CUST_ID;
@property (nonatomic, strong) NSString *CUST_NAME;
@property (nonatomic, strong) NSString *H_FLAG;

@property (nonatomic, strong) NSString *INNET_MONTH;
@property (nonatomic, strong) NSString *IS_FPCARD;
@property (nonatomic, strong) NSString *OWE_FEE;

@property (nonatomic, strong) NSString *SEX;
@property (nonatomic, strong) NSString *RH_INFO;
@property (nonatomic, strong) NSString *TERM_AGE;
@property (nonatomic, strong) NSString *TREATY_FLAG;

@end
