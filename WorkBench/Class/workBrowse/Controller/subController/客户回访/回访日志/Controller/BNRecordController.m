//
//  BNRecordController.m
//  WorkBench
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNRecordController.h"
#import "BNRecordModel.h"
@interface BNRecordController ()

@end

@implementation BNRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回访日志";
    //设置表头
    self.reprotView.headArray = (NSMutableArray *)@[@"小区名称",@"楼号",@"单元",@"房号",@"回访时间"];
    
}

#pragma mark - rightBarButtonItem

- (void)setRigthItem{

}

#pragma mark - 模型数据请求

- (NSArray *)getArrFromDic:(id)requestData{
    return [BNRecordModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
}

#pragma mark - 请求地址

- (NSString *)getUrl{
    return KHHFRZURL;
}

#pragma mark - 报表Frame

- (CGRect)getCGRect{
    
    return self.view.frame;
}
#pragma mark - 底部按钮

- (void)setBtn{

}

#pragma mark - 请求参数

- (NSDictionary *)getParams{
    return self.params;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
