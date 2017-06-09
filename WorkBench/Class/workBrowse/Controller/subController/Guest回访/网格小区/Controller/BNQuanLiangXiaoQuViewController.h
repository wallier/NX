//
//  BNHuaXiaoViewController.h
//  WorkBench
//
//  Created by wanwan on 16/9/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNBsaeViewController.h"

@interface BNQuanLiangXiaoQuViewController : BNBsaeViewController
// 角色编码
@property (nonatomic, strong) NSString *org_id;
// 角色类型
@property (nonatomic, strong) NSString *org_manger_type;
// 角色名称
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) UILabel* lab00;
@property (nonatomic, strong) UILabel* lab10;
@property (nonatomic, strong) UILabel* lab20;

@property (nonatomic, strong) UILabel *titleView0;
@property (nonatomic, strong) UILabel *titleView1;


@property (nonatomic, strong) UILabel* persent00;
@property (nonatomic, strong) UILabel* persent10;
@property (nonatomic, strong) UILabel* persent20;
@property (nonatomic, strong) UILabel* persent30;


@property (nonatomic, strong) UILabel* persent02;
@property (nonatomic, strong) UILabel* persent12;
@property (nonatomic, strong) UILabel* persent22;
@property (nonatomic, strong) UILabel* persent32;



@end
