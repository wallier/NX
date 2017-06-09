//
//  BNVisitReprotView.m
//  WorkBench
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "BNProOneModel.h"
#import "BNVisitReprotView.h"
#import "BNReportTableCell.h"
#import "BNVisitModel.h"
#import "BNAddRecordModel.h"
#import "BNEveryVisitModel.h"
@implementation BNVisitReprotView


- (void)setCellVisitArray:(NSMutableArray *)cellVisitArray{
    
    [self.hud setHidden:YES];
    _cellVisitArray = cellVisitArray;
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cellVisitArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    BNReportTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BNReportTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cellId];
    }

    BNReportCellModel *model = _cellVisitArray[indexPath.row];
    cell.model = model;
    cell.number = (int)self.headArray.count;
    
    if([model isMemberOfClass:[BNProOneModel class]]){
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = Colros(203, 255, 210);
        bgColorView.layer.masksToBounds = YES;
        cell.selectedBackgroundView = bgColorView;
    }
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BNReportCellModel *model = self.cellVisitArray[indexPath.row];
    BNAddRecordModel *addModel = [BNAddRecordModel shareInstance];
    if ([model isMemberOfClass:[BNVisitModel class]]) {
        
        BNVisitModel *model = self.cellVisitArray[indexPath.row];
        addModel.model3 = model;
        [[NSUserDefaults standardUserDefaults] setValue:model.GRID_NO forKey:@"gridID"];
        [[NSUserDefaults standardUserDefaults] setValue:model.XIAOQU_ID forKey:@"xiaoquId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYMMdd"];
        NSDate *date = [NSDate date];
        NSString *accday = [formatter stringFromDate:date];

        NSDictionary *params = @{@"xiaoQuId":model.XIAOQU_ID,
                             @"gridNo":model.GRID_NO,
                             @"accDay":accday,
                             @"visitFlag":@"0"
                             };
        if (self.sendData) {
            self.sendData(params,indexPath);
        }
    } else if([model isMemberOfClass:[BNEveryVisitModel class]]){
        BNEveryVisitModel *model = self.cellVisitArray[indexPath.row];
        addModel.model1 = model;

        NSDictionary *params = @{
                                 @"xiaoQuId":[[NSUserDefaults standardUserDefaults] valueForKey:@"xiaoquId"],
                                 @"gridNo":[[NSUserDefaults standardUserDefaults] valueForKey:@"gridID"],
                                 @"louHao":model.LOUHAO,
                                 @"danYuan":model.DANYUAN,
                                 @"fangHao":model.FANGHAO
                                 };
        if (self.sendData) {
            self.sendData(params,indexPath);
        }

    } else if ([model isMemberOfClass:[BNProOneModel class]]){
        BNProOneModel *model = self.cellVisitArray[indexPath.row];
        addModel.model2 = model;

             if (self.sendData) {
            self.sendData(model,indexPath);
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [view setBackgroundColor:Colros(242, 242, 242)];
    
    UILabel *lab = nil;
    CGFloat w = (self.frame.size.width - (self.headArray.count - 1) * 2 ) / self.headArray.count;
    for (int i = 0 ; i < self.headArray.count; i ++) {
        lab = [[UILabel alloc] init];
        [lab setFrame:CGRectMake(i*(w + 2), 0, w, 44)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines = 0;
        lab.text = self.headArray[i];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:12];
        [lab setBackgroundColor:[UIColor grayColor]];
        [view addSubview:lab];
    }
    return view;
}

@end
