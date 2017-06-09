//
//  BNPoolItemModel.h
//  WorkBench
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
/*
 CX = 65;
 "CX_PER" = "4.02%";
 "DEV_CHANCE_NUM" = 0;
 FX = 835;
 "FX_PER" = "51.67%";
 GX = 672;
 "GX_PER" = "41.58%";
 "SERVICE_TYPE" = 1001;
 "USER_NUM" = 1616;
 */
#import <Foundation/Foundation.h>

@interface BNPoolItemModel : NSObject
@property (nonatomic, strong) NSString *CX;             ///<操心
@property (nonatomic, strong) NSString *CX_PER;         ///<操心百分百
@property (nonatomic, strong) NSString *DEV_CHANCE_NUM; ///<发展数
@property (nonatomic, strong) NSString *FX;             ///<放心
@property (nonatomic, strong) NSString *FX_PER;         ///<放心百分百
@property (nonatomic, strong) NSString *GX;             ///<关心
@property (nonatomic, strong) NSString *GX_PER;         ///<关心百分百
@property (nonatomic, strong) NSString *SERVICE_TYPE;   ///<服务类型 1001 移动 1002宽带  1003ITV
@property (nonatomic, strong) NSString *USER_NUM;       ///<工单总数

@end
