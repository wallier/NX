//
//  BNProductLists.m
//  WorkBench
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNProductLists.h"

@implementation BNProductLists

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame ]) {
        self.tableView = [[UITableView alloc] initWithFrame:frame];
        self.tableView.layer.borderWidth = 2;
        self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setData:(NSArray *)data{
    _data = data;
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellId];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.data[indexPath.row][@"ACC_NBR"];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.senddata) {
        self.senddata(self.data[indexPath.row][@"ACC_NBR"]);
    }
}
@end
