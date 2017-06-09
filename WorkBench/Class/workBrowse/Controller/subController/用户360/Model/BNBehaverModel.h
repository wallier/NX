//
//  BNBehaverModel.h
//  WorkBench
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  {
 "ACTIVE_INFO" = "\U884c\U4e3a:[\U6c89\U9ed8]\U65e5\U5747\U901a\U8bdd0\U5206,\U65e5\U5747\U6d41\U91cf0M]";
 "ACTIVE_INFO_PREFER" = "\U884c\U4e3a\U504f\U597d:[--]";
 "CALLING_DURA" = "\U8bed\U97f3\U9971\U548c\U5ea6:0%[\U5957\U9910\U5185960\U5206\U949f,\U4f7f\U75280\U5206\U949f,\U5269\U4f59960\U5206\U949f]";
 "CALL_DOWN_HB" = "\U901a\U8bdd\U65f6\U957f\U73af\U6bd4:0";
 "CUST_ID" = 11908464;
 "CUST_NAME" = "\U97e9\U534e";
 "FLOW_DOWN_HB" = "\U4e0a\U7f51\U6d41\U91cf\U73af\U6bd4:0";
 "FLOW_FLUX_1" = "\U6d41\U91cf\U9971\U548c\U5ea6:0%[\U5957\U9910\U5185120M,\U4f7f\U75280M,\U5269\U4f59120M]";
 "LOC_CALL_ZB" = "\U672c\U5730\U901a\U8bdd\U5360\U6bd4:0%";
 SEX = "\U7537";
 SMS = "\U77ed\U4fe1\U9971\U548c\U5ea6:0%[\U6708\U4f7f\U75280\U6761]";
 }

 */
@interface BNBehaverModel : NSObject
@property (nonatomic, strong) NSString *ACTIVE_INFO;
@property (nonatomic, strong) NSString *ACTIVE_INFO_PREFER;
@property (nonatomic, strong) NSString *CALLING_DURA;

@property (nonatomic, strong) NSString *CALL_DOWN_HB;
@property (nonatomic, strong) NSString *CUST_NAME;
@property (nonatomic, strong) NSString *CUST_ID;

@property (nonatomic, strong) NSString *FLOW_DOWN_HB;
@property (nonatomic, strong) NSString *FLOW_FLUX_1;
@property (nonatomic, strong) NSString *LOC_CALL_ZB;

@property (nonatomic, strong) NSString *SEX;
@property (nonatomic, strong) NSString *SMS;

@end
