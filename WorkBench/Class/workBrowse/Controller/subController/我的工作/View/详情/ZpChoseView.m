//
//  ZpChoseView.m
//  WorkBench
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 com.bonc. All rights reserved.
//
#import "zpChoseCell.h"
#import "ZpChoseView.h"
#import "choseModel.h"
static NSString *strWG = @"";
static NSString *strState= @"";
static  NSString *str = @"";

@interface ZpChoseView()
@end

@implementation ZpChoseView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.headView];
        [self addSubview:self.tableView];
        [self addSubview:self.buttonView];
    }
    return self;
}

- (void)setParameters:(NSMutableDictionary *)parameters{
    
    _parameters = parameters;
    [_parameters setValue:@"-1" forKey:@"executeState"];
    [_parameters setValue:@"-1" forKey:@"forwordSend"];
    [_parameters setValue:@"-1" forKey:@"orgIdIndex"];
    [_parameters setValue:@"-1" forKey:@"sxOrgManagerType"];

    
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
        UILabel *lab = [[UILabel alloc] initWithFrame:_headView.frame];
        lab.text = @"选择工单状态";
        lab.textAlignment = NSTextAlignmentCenter;
        [lab setBackgroundColor:[UIColor whiteColor]];
        lab.textColor = [UIColor colorWithRed:58/255.0f green:163/255.0f blue:210/255.0f alpha:1];
        [_headView addSubview:lab];
    }
    return _headView;
}


- (NSMutableDictionary *)dictState{
    
    if (!_dictState) {
        _dictState = [NSMutableDictionary dictionary];
        for (choseModel *obj in self.arrModel) {
            [_dictState setValue:obj forKey:obj.cellName];
        }
    }
    return _dictState;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, self.arrData.count > 7 ? 7 *44:self.arrData.count*44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame) + 1, self.frame.size.width, 40)];
        CGFloat X = 0;
        CGFloat Y = 0;
        CGFloat space = 1;
        CGFloat W = (self.frame.size.width - space) / 2;
        CGFloat H = 40;
        for (int i = 0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            X = i* (W + space);
            [btn setFrame: CGRectMake(X, Y, W, H)];
            btn.tag  = i;
            
            if (i == 0) {
                [btn setTitle:@"取消" forState:UIControlStateNormal];
            } else {
                [btn setTitle:@"确定" forState:UIControlStateNormal];
            }
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonView addSubview:btn];
        }
    }
    return _buttonView;
}

- (NSMutableArray *)arrData{
    //@[@"全部(执行状态)",@"已执行",@"未执行",@"执行中",@"已转派"]
    if (!_arrData) {
        _arrData = [NSMutableArray arrayWithArray:@[@"全部(执行状态)",@"已执行",@"未执行",@"执行中",@"已转派"]];
        NSLog(@"man88===%@",[LoginModel shareLoginModel].CONTRACTS_MAN);
        [_arrData addObjectsFromArray:[LoginModel shareLoginModel].CONTRACTS_MAN];
        
        for (NSObject *obj in _arrData) {
            choseModel *model = [choseModel initWithObject:obj];
            [self.arrModel addObject:model];
        }
    }
    return _arrData;
}

- (void)resetting{
    [self.tableView reloadData];
}

- (NSMutableArray *)arrModel{
    if (!_arrModel) {
        _arrModel = [NSMutableArray array];
    }
    return _arrModel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 //刷新列表、修改最大页码
 //工单状态显示不同btn
 //状态为执行中 2
 //已经执行 1
 //未执行 0
 case 0:
 [dic setValue:@"1" forKey:@"executeState"];
 break;
 case 1:
 [dic setValue:@"0" forKey:@"executeState"];
 break;
 case 2:
 [dic setValue:@"2" forKey:@"executeState"];
 break;
 case 3:
 [dic setValue:@"1" forKey:@"forwordSend"];
 
 break;
 case 4:
 [dic setValue:[self.params valueForKey:@"orgId"] forKey:@"orgIdIndex"];
 [dic setValue:@"WG" forKey:@"sxOrgManagerType"];                break;
 default:
 break;
 }
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    choseModel *model = self.arrModel[indexPath.row];
    zpChoseCell *cell = [zpChoseCell initWithTabelView:tableView andIndexPath:indexPath];
    cell.model = model;

    WS;
    cell.senbtn = ^(UIButton *btn,choseModel *models){
        NSLog(@"%d",models.flag);
        
        if (models.flag) {
            [weakSelf ChangeState:models];
            [btn setBackgroundImage:[UIImage imageNamed:@"s0"] forState:UIControlStateNormal];
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:@"s1"] forState:UIControlStateNormal];
            weakSelf.model.flag = YES;
            [weakSelf resizeArrModel:models andIndexPath:indexPath];
            
        }
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    zpChoseCell *cells = (zpChoseCell *)cell;
    [cells.selectBtn setBackgroundImage:[UIImage imageNamed:@"s0"] forState:UIControlStateNormal];
}

- (void)ChangeState:(choseModel *)cellmodel{
    for (choseModel *obj in self.arrModel) {
        if ([obj.cellName isEqualToString:cellmodel.cellName]) {
            obj.flag = NO;
            if ([obj.cellName isEqualToString:@"全部(执行状态)"]) {
                str = @"";
            } else if ([obj.cellName isEqualToString:@"已执行"]){
                NSMutableString *str_temp = [NSMutableString stringWithString:strState];
                NSRange range = [str_temp rangeOfString:@"1,"];
               [str_temp deleteCharactersInRange:range];
                strState = str_temp;
                NSLog(@"%@",str_temp);
            }else if ([obj.cellName isEqualToString:@"未执行"]){
                NSMutableString *str_temp = [NSMutableString stringWithString:strState];
                NSRange range = [str_temp rangeOfString:@"0,"];
                [str_temp deleteCharactersInRange:range];
                strState = str_temp;
                NSLog(@"%@",str_temp);
            }else if ([obj.cellName isEqualToString:@"执行中"]){
                NSMutableString *str_temp = [NSMutableString stringWithString:strState];
                NSRange range = [str_temp rangeOfString:@"2,"];
                [str_temp deleteCharactersInRange:range];
                strState = str_temp;
                NSLog(@"%@",str_temp);
            }
            else if ([obj.cellName isEqualToString:@"已转派"]){
                [self.parameters setValue:@"-1" forKey:@"forwordSend"];

            } else {
                NSMutableString *str_temp = [NSMutableString stringWithString:strWG];
                NSRange range = [str_temp rangeOfString:[NSString stringWithFormat:@"%@,",obj.cellID]];
                [str_temp deleteCharactersInRange:range];
                strWG = str_temp;
                if (![strWG length]) {
                    [self.parameters setValue:@"-1" forKey:@"sxOrgManagerType"];
                    [self.parameters setValue:@"-1" forKey:@"orgIdIndex"];

                }
            }


            
        }
    }
}
- (void)resizeArrModel:(choseModel *)cellModel andIndexPath:(NSIndexPath *)indexPath{
    
        for (int i = 0; i < self.arrData.count; i++) {
            choseModel *temp = self.arrModel[i];
            if ([temp.cellName isEqualToString: cellModel.cellName]) {
                if ([temp.cellName isEqualToString:@"已转派"]) {
                    [self.parameters setValue:@"1" forKey:@"forwordSend"];
                } else if ([temp.cellName isEqualToString:@"全部(执行状态)"]) {
                    [self.parameters setValue:@"-1" forKey:@"forwordSend"];
                    str = [str stringByAppendingString:@"-1,"];
                }else if ([temp.cellName isEqualToString:@"已执行"]){
                    strState = [strState stringByAppendingString:@"1,"];
                    
                }else if ([temp.cellName isEqualToString:@"未执行"]){
                    strState = [strState stringByAppendingString:@"0,"];
                    
                }else if ([temp.cellName isEqualToString:@"执行中"]){
                    strState = [strState stringByAppendingString:@"2,"];
                    
                } else {
                    strWG = [strWG stringByAppendingString:[NSString stringWithFormat:@"%@,",temp.cellID]];
                }
                temp.flag = YES;
                [self.arrModel replaceObjectAtIndex:i withObject:cellModel];
            }
        
        }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lab = [[UILabel alloc] init];
    [lab setBackgroundColor:[UIColor colorWithRed:58/255.0f green:163/255.0f blue:210/255.0f alpha:1]];
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

- (void)Click:(UIButton *)sender{
    if (sender.tag == 1) {
        if (self.getChoseData) {
            NSLog(@"%ld",(unsigned long)[[strWG componentsSeparatedByString:@","] count]);
            if([[strWG componentsSeparatedByString:@","] count]>5){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网格最多不超过4个，请重新选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
                [alert show];
                return;
            }
            if ([str length] && [strState length]) {
                str =  [str stringByAppendingString:strState];
                [self.parameters setValue:str forKey:@"executeState"];
            } else if ([str length]){
                [self.parameters setValue:str  forKey:@"executeState"];
                
            } else {
                [self.parameters setValue:strState  forKey:@"executeState"];
            }
            [self.parameters setValue:[strWG length]>0?strWG:@"-1" forKey:@"orgIdIndex"];
            [self.parameters setValue:[strWG length] >0?@"WG":@"-1" forKey:@"sxOrgManagerType"];
            self.getChoseData(self.parameters);
        }
        
    } else {
        if (self.getChoseData) {
            self.getChoseData(nil);
        }
        
    }
    [self cleanData];
    [self removeFromSuperview];
    
}

- (void)cleanData {
    strWG = @"";
    strState = @"";
    str = @"";
    for (choseModel *obj in self.arrModel) {
        obj.flag = NO;
    }
}

- (void)dealloc{
    NSLog(@"转派视图销毁");
}
@end
