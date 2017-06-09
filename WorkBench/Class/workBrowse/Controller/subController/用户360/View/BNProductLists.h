//
//  BNProductLists.h
//  WorkBench
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sendDates)(NSString *);

@interface BNProductLists : UIView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) sendDates senddata;

@end
