//
//  BNEveryVisitModel.h
//  WorkBench
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNReportCellModel.h"

@interface BNEveryVisitModel : BNReportCellModel
/*
 DANYUAN = "8\U5355\U5143";
FANGHAO = "501\U5ba4";
"HF_TIME" = "--";
"IS_HUIFANG" = "\U5426";
LOUHAO = "9\U53f7\U697c";
"PROD_COUNT" = 2;
*/

@property (nonatomic, strong) NSString *DANYUAN;    ///<单元
@property (nonatomic, strong) NSString *FANGHAO;    ///<房号
@property (nonatomic, strong) NSString *HF_TIME;    ///<回访时间
@property (nonatomic, strong) NSString *IS_HUIFANG; ///<回访标志
@property (nonatomic, strong) NSString *LOUHAO;     ///<楼号
@property (nonatomic, strong) NSString *PROD_COUNT; ///<产品数量

@end
