//
//  BNChoseStateView.m
//  WorkBench
//
//  Created by mac on 16/2/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNChoseStateView.h"

@interface BNChoseStateView()
@property (nonatomic, strong) NSArray *arrName;
@end

@implementation BNChoseStateView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.arrName = @[@"请选择",@"已回访",@"未回访"];
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.layer.borderWidth = 3;
        self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.tableView setBackgroundColor:[UIColor yellowColor]];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellId];
    }
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    cell.textLabel.text = self.arrName[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str =[self judgeState:self.arrName[indexPath.row]];
    if (self.sendData) {
        self.sendData(str,self.arrName[indexPath.row]);
    }
}

- (NSString *)judgeState:(NSString *)name{
    if ([name isEqualToString:@"请选择"]) {
        return @"0";
    } else if ([name isEqualToString:@"已回访"]){
        return @"1";
    } else {
        return @"2";
    }
}

@end
