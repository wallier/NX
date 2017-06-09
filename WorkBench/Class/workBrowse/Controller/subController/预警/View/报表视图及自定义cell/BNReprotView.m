//
//  BNReprotView.m
//  WorkBench
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "BNVisitModel.h"
#import "BNReprotView.h"
#import "BNReportTableCell.h"
#define LEFTWIDTH self.frame.size.width
#define RIGHTWIDTH self.frame.size.width * 4/ 5

@interface BNReprotView()

@end

@implementation BNReprotView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.tableView];
        self.hud = [MBProgressHUD showMessage:@"请稍后..." toView:self];
    }
    return self;
}


- (void)setCellArray:(NSMutableArray *)cellArray{
    [self.hud setHidden:YES];
    _cellArray = cellArray;
    BNReportCellModel *model = [[BNReportCellModel alloc] init];
    model.DESCS = @"地域";
    model.SERV_CNT_20 = @"用户数";
    model.SERV_CNT_20_ZGD = @"中高端用户数";
    model.SERV_CNT_50 = @"用户数";
    model.SERV_CNT_50_ZGD = @"中高端用户数";
    [_cellArray insertObject:model atIndex:0];
    [self.tableView reloadData];
}



- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:
                          CGRectMake(0, 0, LEFTWIDTH, self.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (void)setHeadArray:(NSMutableArray *)headArray{
    _headArray = headArray;
}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    BNReportTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BNReportTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellId];
    }
    BNReportCellModel *model = _cellArray[indexPath.row];
    cell.model = model;
    cell.number = 5;
    return cell;


}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [view setBackgroundColor:Colros(242, 242, 242)];
    
    UILabel *lab = nil;
    CGFloat w = (self.frame.size.width - 8) / 5;
    CGFloat w2 =  (self.frame.size.width - w - 4) / 2;
    for (int i = 0 ; i < self.headArray.count; i ++) {
        lab = [[UILabel alloc] init];
        if ( i == 0 ) {
            [lab setFrame:CGRectMake(0, 0, w, 44)];
        } else if (i == 1) {
            lab.frame = CGRectMake(w + 2, 0 , w2 , 44);
        } else {
            lab.frame = CGRectMake(w2 + w + 4, 0, w2, 44);
        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
        
    [cell setBackgroundColor:Colros(250, 250, 250)];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    BNReportTableCell *cells = (BNReportTableCell*)cell;

    if (indexPath.row % 2 == 0) {
        [cells setlableColor:Colros(242, 242, 242)];
    } else {
        [cells setlableColor:[UIColor whiteColor]];
    }
}


@end
