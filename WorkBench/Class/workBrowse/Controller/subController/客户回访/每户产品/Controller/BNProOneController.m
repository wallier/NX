//
//  BNProOneController.m
//  WorkBench
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNProOneController.h"
#import "BNProOneModel.h"
#import "BNAddRecordController.h"
@interface BNProOneController()
@property (nonatomic, strong) BNProOneModel *model;
@property (nonatomic, strong) UIButton *btnChoseDate;
@property (nonatomic, strong) UIButton *btnChoseState;

@end

@implementation BNProOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"每户产品";
    self.reprotView.headArray = (NSMutableArray *)@[@"产品",@"业务号码",@"运营商",@"协议到期时间",@"是回访结果"];
    
    
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

#pragma mark - 点击cell控制器跳转

- (void)goNextController:(NSDictionary *)dic{
    BNProOneModel *model = (BNProOneModel *)dic;
    if ([model.HF_NO isEqualToString:self.model.HF_NO]) {
        self.model = nil;
        [self.reprotView.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
    } else {
        self.model = (BNProOneModel *)dic;
    }
}
#pragma mark - 添加回访日志

- (void)addRecord{
    BNAddRecordController *vc = [[BNAddRecordController alloc] init];
    vc.model = [[BNAddRecordModel alloc] init];
    vc.model.model3 = [BNAddRecordModel shareInstance].model3;
    vc.model.model2 = nil;
    vc.model.model1 = [BNAddRecordModel shareInstance].model1;
    [self.navigationController pushViewController:vc animated:YES];}

#pragma mark - 菜单栏

- (void)goMove{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

#pragma mark - 底部按钮

- (void)setBtn{
    self.btnChoseDate = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnChoseDate.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    [self.btnChoseDate addTarget:self action:@selector(ChangeData) forControlEvents:UIControlEventTouchUpInside];
    [self.btnChoseDate setTitle:@"修改" forState:UIControlStateNormal];
    [self.btnChoseDate setBackgroundColor:[UIColor colorWithRed:71.0/255 green:123.0/255 blue:242.0/255 alpha:1]];
    [self.btnChoseDate setFrame:CGRectMake(0, CGRectGetMaxY(self.reprotView.frame), self.view.frame.size.width / 2 - 1, 40)];
    [self.view addSubview:self.btnChoseDate];
    
    self.btnChoseState = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnChoseState.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    [self.btnChoseState addTarget:self action:@selector(delectData) forControlEvents:UIControlEventTouchUpInside];
    [self.btnChoseState setTitle:@"删除" forState:UIControlStateNormal];
    [self.btnChoseState setBackgroundColor:[UIColor colorWithRed:71.0/255 green:123.0/255 blue:242.0/255 alpha:1]];
    [self.btnChoseState setFrame:CGRectMake(CGRectGetMaxX(self.btnChoseDate.frame) + 2, CGRectGetMaxY(self.reprotView.frame), self.view.frame.size.width / 2 - 1, 40)];
    [self.view addSubview:self.btnChoseState];

}

- (void)ChangeData{
    if (!self.model) {
        [self.view makeToast:@"请选择数据" duration:0.5 position:CSToastPositionCenter];
        return;
    }
    BNAddRecordController *vc = [[BNAddRecordController alloc] init];
    vc.flag = YES;
    vc.model = [[BNAddRecordModel alloc] init];
    vc.model.model3 = [BNAddRecordModel shareInstance].model3;
    vc.model.model2 = [BNAddRecordModel shareInstance].model2;
    vc.model.model1 = [BNAddRecordModel shareInstance].model1;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)delectData{
    
    if (!self.model) {
        [self.view makeToast:@"请选择数据" duration:0.5 position:CSToastPositionCenter];
        return;
    }
    NSDictionary *params = @{@"hfNo":self.model.HF_NO};
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在删除..." toView:self.view];
    [BNNetworkTool initWitUrl:DELECTJL andParameters:params andStyle:YES].requestData =
    ^(id requestData){
        self.model = nil;
        [hud setHidden:YES];
        [super getRequest:self.params];
    };

}

- (void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 模型数据请求

- (NSArray *)getArrFromDic:(id)requestData{
    return [BNProOneModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
}

#pragma mark - 请求地址

- (NSString *)getUrl{
    return KHHFDETAILURL2;
}

#pragma mark - 请求参数

- (NSDictionary *)getParams{
    return self.params;
}

#pragma mark - 传递请求参数

- (void)setParams:(NSDictionary *)params{
    _params = params;
}

@end
