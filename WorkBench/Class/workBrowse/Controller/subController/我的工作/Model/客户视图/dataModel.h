//
//  dataModel.h
//  WorkBench
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "ACC_NAME" = "\U56fd\U5185\U77ed\U4fe1\U6761\U6570";
 "BILLING_CYCLE_ID" = 201510;
 "OFFER_AMOUNT" = "30.0";
 "OFFER_NAME" = "\U5bb6\U5ead\U8ba1\U5212";
 UNIT = "(\U6761)";
 USELV = "7%";
 VALUE = "2.0";

 */
@interface dataModel : NSObject
@property (strong,nonatomic) NSString *ACC_NAME;
@property (strong,nonatomic) NSString *BILLING_CYCLE_ID;
@property (strong,nonatomic) NSString *OFFER_AMOUNT;
@property (strong,nonatomic) NSString *OFFER_NAME;
@property (strong,nonatomic) NSString *UNIT;
@property (strong,nonatomic) NSString *USELV;
@property (strong,nonatomic) NSString *VALUE;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
