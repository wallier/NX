//
//  BNAddAndChangeBaseViewController.h
//  WorkBench
//
//  Created by wouenlone on 16/8/18.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNAddProductViewController : UIViewController
//需传进参数 1.小区楼唯一标识 2.用户所属单元编号 3.用户门牌号
//BUILDING_ID --> 小区楼唯一标识，
//UNIT_NO --> 用户所属单元编号，
//ROOT_NO --> 用户门牌号，
@property (nonatomic, copy) NSString *BUILDING_ID;
@property (nonatomic, copy) NSString *UNIT_NO;
@property (nonatomic, copy) NSString *ROOT_NO;

- (instancetype)initWithHouseAddress:(NSString *)address;


@end
