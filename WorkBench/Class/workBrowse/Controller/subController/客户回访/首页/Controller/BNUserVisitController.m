//
//  BNUserVisitController.m
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "BNUserVisitController.h"
#import "BNRecordController.h"
#import "BNEveryVisiteController.h"
#import "BNVisitModel.h"
#import "selectView.h"

@interface BNUserVisitController ()
@end

@implementation BNUserVisitController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户回访";
    [self setReprotViews];
    [self setRigthItem];
    //http://202.100.110.55:81/scm_ningxia_ios/getAllArea.action?orgId=root
}

- (void)setReprotViews{
     WS;
    
    self.reprotView = [[BNVisitReprotView alloc] initWithFrame:[self getCGRect]];
    [self.view addSubview:self.reprotView];
    
    [self setBtn];
    self.reprotView.headArray = (NSMutableArray *)@[@"小区名称",@"移动",@"宽带",@"固话",@"ITV",@"其他"];
    [self getRequest:nil];
    _reprotView.sendData = ^(NSDictionary *arr,NSIndexPath *indexPath){
        [weakSelf goNextController:arr];
        weakSelf.indexPath = indexPath;
    };

}
#pragma mark - rightBarButtonItem/leftBarButtonItem

- (void)setRigthItem{
  
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:@"small_my_todo"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [btn addTarget:self action:@selector(goToDo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(0, 0, 40, 40)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"head_category_normal"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(goMove) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    NSArray *arr = @[negativeSpacer,negativeSpacer, item1,item,negativeSpacer];
    self.navigationItem.rightBarButtonItems = arr;
}

#pragma mark - 回访日志查看

- (void)goToDo{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYMMdd"];
    NSDate *date = [NSDate date];
    NSString *accday = [formatter stringFromDate:date];
    NSDictionary *params = @{@"loginId":[LoginModel shareLoginModel].LOGIN_ID,@"accDay":accday};
    
    BNRecordController *vc = [[BNRecordController alloc] init];
    vc.params = params;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 菜单栏

- (void)goMove{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];

}


#pragma mark - 点击cell控制器跳转

- (void)goNextController:(NSDictionary *)dic{
    BNEveryVisiteController *vc = [[BNEveryVisiteController alloc] init];
    vc.params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 报表Frame

- (CGRect)getCGRect{
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 40);
}

#pragma mark - 底部按钮

- (void)setBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    [btn addTarget:self action:@selector(selectBlocks:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"小区名称" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:71.0/255 green:123.0/255 blue:242.0/255 alpha:1]];
    [btn setFrame:CGRectMake(0, CGRectGetMaxY(self.reprotView.frame), self.view.frame.size.width, 40)];
    [self.view addSubview:btn];
}

- (void)selectBlocks:(UIButton *)sender{
    selectView *select = [[selectView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width, 80)];
    select.post_name = ^(NSString * name){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:name forKey:@"xiaoQuName"];
        [params setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgid"];
        [self getRequest:params];
    };
    [self.view addSubview:select];
}

#pragma mark - 发出请求

- (void)getRequest:(NSDictionary *)param{
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.reprotView.tableView];
    [BNNetworkTool initWitUrl:[self getUrl] andParameters:param?:[self getParams] andStyle:YES].requestData = ^(id requestData){
        [hud setHidden:YES];
        NSLog(@"%@",requestData);
        NSArray *arr  = [self getArrFromDic:requestData];
        _reprotView.cellVisitArray = (NSMutableArray *)arr;
    };
    
}

#pragma mark - 模型数据请求

- (NSArray *)getArrFromDic:(id)requestData{
    return [BNVisitModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
}

#pragma mark - 请求地址

- (NSString *)getUrl{
    return KHHFURL;
}

#pragma mark - 传递请求参数

- (NSDictionary *)getParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgid"];
    return dic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"客户回访dealloc");
}

@end
