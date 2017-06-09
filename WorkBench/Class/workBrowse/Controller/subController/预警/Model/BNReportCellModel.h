//
//  BNReportCellModel.h
//  WorkBench
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "AREA_NO" = "-1";
 DESCS = "\U5408\U8ba1";
 "SERV_CNT_20" = "";
 "SERV_CNT_20_ZGD" = "";
 "SERV_CNT_50" = "";
 "SERV_CNT_50_ZGD" = "";
 */
@interface BNReportCellModel : NSObject

@property (nonatomic, strong) NSString *DESCS;
@property (nonatomic, strong) NSString *SERV_CNT_20;
@property (nonatomic, strong) NSString *SERV_CNT_20_ZGD;
@property (nonatomic, strong) NSString *SERV_CNT_50;
@property (nonatomic, strong) NSString *SERV_CNT_50_ZGD;

@property (nonatomic, strong) NSString *BRD_CNT;
@property (nonatomic, strong) NSString *BRD_CNT_ZGD;
@property (nonatomic, strong) NSString *MBL_CNT;
@property (nonatomic, strong) NSString *MBL_CNT_ZGD;

- (NSArray *)getValues;

@end
