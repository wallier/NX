//
//  BNEveryVisiteController.m
//  WorkBench
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNEveryVisiteController.h"
#import "BNProOneController.h"
#import "BNEveryVisitModel.h"
#import "PickerViewDateView.h"
#import "NSString+BNDate__String.h"
#import "BNChoseStateView.h"
#import "BNAddRecordController.h"

@interface BNEveryVisiteController ()
@property (nonatomic, strong) PickerViewDateView *picker;
@property (nonatomic, strong) UIButton *btnChoseDate;
@property (nonatomic, strong) UIButton *btnChoseState;
@property (nonatomic, strong) BNChoseStateView *choseView;
@end

@implementation BNEveryVisiteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"每户产品统计";
    self.reprotView.headArray = (NSMutableArray *)@[@"楼号",@"单元",@"房号",@"产品数量",@"是否回访",@"回访时间"];
}

#pragma mark - rightBarButtonItem/leftBarButtonItem

- (void)setRigthItem{
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0,30, 30)];
    [back setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [back setContentMode:UIViewContentModeCenter];
    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:@"head_more_normal"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [btn addTarget:self action:@selector(addRecord) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(0, 0, 40, 40)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"head_category_normal"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(goMove) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    NSArray *arr = @[negativeSpacer,negativeSpacer, item1,item];
    self.navigationItem.rightBarButtonItems = arr;
}

#pragma mark - 底部按钮

- (void)setBtn{
    self.btnChoseDate = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnChoseDate.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    [self.btnChoseDate addTarget:self action:@selector(choseDate) forControlEvents:UIControlEventTouchUpInside];
    [self.btnChoseDate setTitle:[[LoginModel shareLoginModel].LATEST_ACC_DAY dateJudgeIsDay:YES] forState:UIControlStateNormal];
    [self.btnChoseDate setBackgroundColor:[UIColor colorWithRed:71.0/255 green:123.0/255 blue:242.0/255 alpha:1]];
    [self.btnChoseDate setFrame:CGRectMake(0, CGRectGetMaxY(self.reprotView.frame), self.view.frame.size.width / 2 - 1, 40)];
    [self.view addSubview:self.btnChoseDate];

    self.btnChoseState = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnChoseState.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    [self.btnChoseState addTarget:self action:@selector(choseState) forControlEvents:UIControlEventTouchUpInside];
    [self.btnChoseState setTitle:@"请选择" forState:UIControlStateNormal];
    [self.btnChoseState setBackgroundColor:[UIColor colorWithRed:71.0/255 green:123.0/255 blue:242.0/255 alpha:1]];
    [self.btnChoseState setFrame:CGRectMake(CGRectGetMaxX(self.btnChoseDate.frame) + 2, CGRectGetMaxY(self.reprotView.frame), self.view.frame.size.width / 2 - 1, 40)];
    [self.view addSubview:self.btnChoseState];
}

#pragma mark - 日期查询

- (void)choseDate{
    WS;
    self.picker = [[PickerViewDateView alloc] initWithFrame:
                   CGRectMake(0, self.view.frame.size.height - 256,self.view.frame.size.width, 256)];
    
    [self.picker.pickerView setDate:[NSString ChangeStringToDate:self.btnChoseDate.titleLabel.text
                                                     andFromater:@"yyyy/MM/dd"]];
    [self.view addSubview:self.picker];
    
    
    self.picker.send = ^(int tag){
        [weakSelf.picker removeFromSuperview];
    };
    self.picker.dates = ^(NSString *date1 ,NSString *date2){
        [weakSelf.btnChoseDate setTitle:date1 forState:UIControlStateNormal];
        [weakSelf.params setValue:date2 forKey:@"accDay"];
        [super getRequest:weakSelf.params];
    };

}

#pragma mark - 回访状态查询

- (BNChoseStateView *)choseView{
    if (!_choseView) {
        WS;
        CGRect frames = self.btnChoseState.frame;
        _choseView = [[BNChoseStateView alloc] initWithFrame:CGRectMake(frames.origin.x, self.view.frame.size.height - 44 *3 - 40, frames.size.width, 44 * 3)];
        
        _choseView.sendData = ^(NSString *state,NSString *name){
            [weakSelf.params setValue:state forKey:@"visitFlag"];
            NSLog(@"%@",weakSelf.params);
            [weakSelf.btnChoseState setTitle:name forState:UIControlStateNormal];
            [super getRequest:weakSelf.params];
            [weakSelf.choseView removeFromSuperview];
            weakSelf.choseView = nil;
        };
    }
    return _choseView;
}

- (void)choseState{
    if (_choseView) {
        [self.choseView removeFromSuperview];
        self.choseView = nil;
    } else {
        [self.view addSubview:self.choseView];
    }
}

#pragma mark - 添加回访记录

- (void)addRecord{
    BNAddRecordController *vc = [[BNAddRecordController alloc] init];
    vc.model = [[BNAddRecordModel alloc] init];
    vc.model.model3 = [BNAddRecordModel shareInstance].model3;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 菜单栏

- (void)goMove{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

#pragma mark - 点击cell控制器跳转

- (void)goNextController:(NSDictionary *)dic{
    BNProOneController *vc = [[BNProOneController alloc] init];
    vc.params = dic;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 模型数据请求

- (NSArray *)getArrFromDic:(id)requestData{
    return [BNEveryVisitModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
}

#pragma mark - 请求地址

- (NSString *)getUrl{
    return KHHFDETAILURL1;
}

#pragma mark - 请求参数

- (NSDictionary *)getParams{
    
    return self.params;
}

#pragma mark - 传递请求参数

- (void)setParams:(NSMutableDictionary *)params{
    _params = params;
}
@end
