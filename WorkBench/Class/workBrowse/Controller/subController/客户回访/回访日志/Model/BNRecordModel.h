//
//  BNRecordModel.h
//  WorkBench
//
//  Created by mac on 16/2/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNReportCellModel.h"
@interface BNRecordModel : BNReportCellModel
/*
 DANYUAN = "1\U5355\U5143";
 FANGHAO = "501\U5ba4";
 "HF_NO" = 76396254;
 "HF_RESULT" = "";
 "HF_TIME" = "20160226 15:33";
 LOUHAO = "10\U53f7\U697c";
 "XIAOQU_NAME" = "\U7261\U4e39\U56ed";
 */

@property (nonatomic, strong) NSString *DANYUAN;    ///< 单元
@property (nonatomic, strong) NSString *FANGHAO;    ///< 房号
@property (nonatomic, strong) NSString *HF_NO;      ///< 回访号
@property (nonatomic, strong) NSString *HF_RESULT;  ///< 回访结果
@property (nonatomic, strong) NSString *HF_TIME;    ///< 回访时间
@property (nonatomic, strong) NSString *LOUHAO;     ///< 楼号
@property (nonatomic, strong) NSString *XIAOQU_NAME;///< 小区名称
@end
