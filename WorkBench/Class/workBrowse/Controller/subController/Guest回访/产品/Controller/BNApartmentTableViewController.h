//
//  BNApartmentTableViewController.h
//  WorkBench
//
//  Created by wouenlone on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNApartmentTableViewController : UITableViewController
//楼宇唯一标示
@property (nonatomic,copy) NSString *building_id;
//用户所属单元编号
@property (nonatomic,copy) NSString *unit_no;
//用户门牌号
@property (nonatomic,copy) NSString *root_no;
//地址
@property (nonatomic,copy) NSString *address;
@end
