//
//  BNChoseStateView.h
//  WorkBench
//
//  Created by mac on 16/2/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SENDSTATE)(NSString *state,NSString *name);

@interface BNChoseStateView : UIView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SENDSTATE sendData;

@end
