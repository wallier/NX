//
//  zpChoseCell.m
//  WorkBench
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "zpChoseCell.h"
@interface zpChoseCell()
@property (nonatomic,strong) UIButton *btnSave;
@property (nonatomic,strong) NSMutableArray *arrState;
@end
@implementation zpChoseCell



+ (instancetype)initWithTabelView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
    
static NSString *cellID = @"cell";
    zpChoseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[zpChoseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}


- (void)setModel:(choseModel *)model{
    
    _model = model;
    self.textLabel.text = model.cellName;
    self.accessoryView = self.selectBtn;
    if (_model.flag) {
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"s1"] forState:UIControlStateNormal];
    } else {
           [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"s0"] forState:UIControlStateNormal];
    }
}


- (UIButton *)selectBtn{
    if (!_selectBtn) {
    
     _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setFrame:CGRectMake(0, 0, 30, 30)];
        [_selectBtn addTarget:self action:@selector(clicks:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (NSMutableArray *)arrState{

    if (!_arrState) {
        _arrState = [NSMutableArray array];
    }
    return _arrState;
}

- (void)clicks:(UIButton*)sender{
    WS;
    __weak UIButton *btn = sender;
    if (self.senbtn) {
        self.senbtn(btn,weakSelf.model);
    }
    
}

- (void)dealloc{
    NSLog(@"cellDealloc");
}
@end
