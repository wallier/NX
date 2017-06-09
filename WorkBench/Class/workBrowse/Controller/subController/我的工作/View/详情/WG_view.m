//
//  WG_view.m
//  BIBuilderApp
//
//  Created by mac on 15/7/14.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import "WG_view.h"
@implementation WG_view

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _arr_orgid = [[NSMutableArray alloc] initWithCapacity:1];
        [self setBackgroundColor:[UIColor blackColor]];
        _arr_data = [LoginModel shareLoginModel].CONTRACTS_MAN;

        _view_top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        UILabel *lab  = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, frame.size.width, 40)];
        [_view_top addSubview:lab];
        lab.textColor = [UIColor whiteColor];
        lab.text = @"网格列表";
        [self addSubview:_view_top];
        
        _table_mid = [[UITableView alloc] initWithFrame:CGRectMake(0,40, frame.size.width, 200) style:UITableViewStylePlain];
        _table_mid.delegate = self;
        _table_mid.dataSource = self;
       
        if ([_table_mid respondsToSelector:@selector(setLayoutMargins:)]) {
            [_table_mid setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([_table_mid respondsToSelector:@selector(setSeparatorInset:)]) {
            [_table_mid setSeparatorInset:UIEdgeInsetsZero];
        }
        [self addSubview:_table_mid];
        
        
        _view_down = [[UIView alloc] initWithFrame:CGRectMake(0, 240, frame.size.width, frame.size.height-240)];
        [_view_down setBackgroundColor:[UIColor lightGrayColor]];
        UIButton *btn_close = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_close setFrame:CGRectMake(5, 5, 90, 30)];
        btn_close.layer.cornerRadius = 3.f;
        [btn_close setTitle:@"关闭" forState:UIControlStateNormal];
        [btn_close setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn_close.titleLabel.font = [UIFont systemFontOfSize:12];
        btn_close.center= CGPointMake(frame.size.width/2, (frame.size.height -240)/2);
        [_view_down addSubview:btn_close];
        [btn_close addTarget:self action:@selector(sendColsed) forControlEvents:UIControlEventTouchUpInside];
        [btn_close setBackgroundColor:[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1]];
        [self addSubview:_view_down];
        self.layer.cornerRadius = 5.f;
        
    }
    return self;
}

- (void)sendColsed{
    if (_closed) {
        _closed();
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arr_data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_sendorgid) {
        NSString *str = [_arr_orgid objectAtIndex:indexPath.row];
        _sendorgid(str);
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }else{
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[_arr_data objectAtIndex:indexPath.row] valueForKey:@"NAME"];
    [_arr_orgid addObject:[[_arr_data objectAtIndex:indexPath.row] valueForKey:@"GRID_ID"]] ;;
    return cell;
}


@end
