//
//  BNReprotView.h
//  WorkBench
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNReprotView : UIView <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) BOOL Flag; ///<子类set方法
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *headArray;
@property (nonatomic, strong) NSString *url;


@end
