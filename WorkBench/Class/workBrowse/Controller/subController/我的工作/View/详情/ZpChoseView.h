//
//  ZpChoseView.h
//  WorkBench
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "choseModel.h"

typedef void (^GetChoseData) (NSDictionary *);
@interface ZpChoseView : UIView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) choseModel *model;
@property (nonatomic,strong) choseModel *modelSave;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary *dictState;
@property (nonatomic,strong) UIView *buttonView;
@property (nonatomic,strong) NSMutableArray *arrData;
@property (nonatomic,strong) NSMutableArray *arrModel;
@property (nonatomic,strong) GetChoseData getChoseData;
@property (nonatomic,strong) NSMutableDictionary *parameters;
@property (nonatomic,strong) NSString *url;
- (void)resetting;
@end
