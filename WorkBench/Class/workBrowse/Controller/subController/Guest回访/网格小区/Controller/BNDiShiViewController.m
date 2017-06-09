//
//  BNDiShiViewController.m
//  WorkBench
//
//  Created by wanwan on 16/9/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNDiShiViewController.h"
#import "BNGridCell.h"
#import <MJRefresh.h>
#import "BNGridRoleModel.h"
#import <AFNetworking.h>
#import "BNMetaDataTools.h"
#import "BNQuXianViewController.h"
#import "BNWaterMark.h"

@interface BNDiShiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
// 装网格模型数据的
@property (strong,nonatomic)NSMutableArray *gridArray;
//记录当前请求的page的值
@property (nonatomic, assign) int page;
// 请求返回的数据
@property (strong,nonatomic)id responseObject;

@end

@implementation BNDiShiViewController
// 懒加载数组
- (NSMutableArray *)gridArray {
    if (!_gridArray) {
        _gridArray = [NSMutableArray arrayWithCapacity:30];
    }
    return _gridArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    // Title
    self.title = self.name;
    [self initTableView];
    [self.tableView.header beginRefreshing];
    // 请求数据
    [self getRequest];
    
}

#pragma mark -- 界面部分

- (void)initTableView{
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        // 风格
        self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
        self.tableView.backgroundColor= [UIColor clearColor];
        // 水印背景
        UIImage *img = [BNWaterMark getwatermarkImage];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:img]];
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            
            [self getRequest];
        }];
        
        _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getRequest];
        }];
        
    }
    [self.view addSubview:self.tableView];
    
    
}

/**
 *  停止刷新
 */
-(void)endRefresh{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

#pragma mark - 请求地址

- (NSString *)getUrl{
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"DS"]) {
         return [[[ROLEURL stringByAppendingString:[LoginModel shareLoginModel].ORG_MANAGER_TYPE]stringByAppendingString:@"/"]stringByAppendingString:[LoginModel shareLoginModel].ORG_ID];
    }else {
    
         return [[[ROLEURL stringByAppendingString:self.org_manger_type]stringByAppendingString:@"/"]stringByAppendingString:self.org_id];
    
    }

}

#pragma mark - 传递请求参数

//- (NSDictionary *)getParams{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgid"];
//    NSLog(@"++++%@",[LoginModel shareLoginModel].ORG_ID);
//    return dic;
//}

#pragma mark -- 请求数据
- (void)getRequest{
    WS
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[self getUrl] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf endRefresh];
        [weakSelf.gridArray removeAllObjects];
        
        
        NSArray * responseArray = [BNMetaDataTools getGridRoleModelArray:responseObject[@"RESULT"]];
        [weakSelf.gridArray addObjectsFromArray: responseArray];
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
        [weakSelf endRefresh];
        
    }];
}

#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.gridArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNGridRoleModel *gridRoleModel = self.gridArray[indexPath.row];
    
    BNGridCell *cell = [BNGridCell cellWithTableView:tableView AndGridRoleModel:gridRoleModel];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BNGridRoleModel *gridRoleModel = self.gridArray[indexPath.row];
    
    BNQuXianViewController *quXianVC = [[BNQuXianViewController alloc]init];
    quXianVC.org_id= gridRoleModel.ID;
    quXianVC.org_manger_type = gridRoleModel.ORG_MANAGER_TYPE;
    quXianVC.name = gridRoleModel.NAME;
    [self.navigationController pushViewController:quXianVC animated:YES];
    
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
