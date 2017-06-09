//
//  WG_view.h
//  BIBuilderApp
//
//  Created by mac on 15/7/14.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Closed)(void);
typedef void (^sendOrgid)(NSString *);

@interface WG_view : UIView <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UIView *view_top;
@property(nonatomic,strong) UITableView *table_mid;
@property(nonatomic,strong) UIView *view_down;
@property(nonatomic,strong) NSArray *arr_data;
@property(nonatomic,strong) NSMutableArray *arr_orgid;

@property(nonatomic,strong) Closed closed;
@property(nonatomic,strong) sendOrgid sendorgid;
@end
