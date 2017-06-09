//
//  BNVisitModel.h
//  WorkBench
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BNReportCellModel.h"
@interface BNVisitModel : BNReportCellModel
/*
 {
 "ADSL_USER" = 2;
 "GH_USER" = 3;
 "GRID_NO" = WG8640001000424;
 "ITV_USER" = 1;
 "M_USER" = 0;
 "OTHER_USER" = 1;
 "XIAOQU_ID" = 883;
 "XIAOQU_NAME" = "\U6c34\U5382\U5bb6\U5c5e\U697c";
 */

@property (nonatomic, strong) NSString *ADSL_USER;  ///< 宽带
@property (nonatomic, strong) NSString *GH_USER;    ///< 固话
@property (nonatomic, strong) NSString *GRID_NO;    ///< 网格号
@property (nonatomic, strong) NSString *ITV_USER;   ///< ITV
@property (nonatomic, strong) NSString *M_USER;     ///< 移动
@property (nonatomic, strong) NSString *OTHER_USER; ///< 其他
@property (nonatomic, strong) NSString *XIAOQU_ID;  ///< 小区ID
@property (nonatomic, strong) NSString *XIAOQU_NAME;///< 小区名称

@end
