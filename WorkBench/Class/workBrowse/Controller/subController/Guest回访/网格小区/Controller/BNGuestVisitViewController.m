//
//  BNGuestVisitViewController.m
//  WorkBench
//
//  Created by wanwan on 16/8/12.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNGuestVisitViewController.h"
#import "BNGridCell.h"
#import <MJRefresh.h>
#import "BNCommunityController.h"
#import "BNGridMedol.h"
#import <AFNetworking.h>
#import "BNMetaDataTools.h"
#import "BNAddCommunityController.h"
#import "BNCommunityContentViewController.h"


@interface BNGuestVisitViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
// 装网格模型数据的
@property (strong,nonatomic)NSMutableArray *gridArray;
//记录当前请求的page的值
@property (nonatomic, assign) int page;
// 请求返回的数据
@property (strong,nonatomic)id responseObject;
// 记录返回当前组织机构编码
@property (strong, nonatomic) NSString *org_id;
// 记录当前机构的类型
@property (strong, nonatomic) NSString *org_manger_type;
@end

@implementation BNGuestVisitViewController

// 懒加载数组
- (NSMutableArray *)gridArray {
    if (!_gridArray) {
        _gridArray = [NSMutableArray arrayWithCapacity:30];
    }
    return _gridArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Title
    self.title=[LoginModel shareLoginModel].NAME;
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
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]]];
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
        NSLog(@"---URL---%@",[[[GRIDURL stringByAppendingString:[LoginModel shareLoginModel].ORG_MANAGER_TYPE]stringByAppendingString:@"/"]stringByAppendingString:[LoginModel shareLoginModel].ORG_ID]);
    
    return [GRIDURL stringByAppendingString:[LoginModel shareLoginModel].ORG_ID];
    

//    _org_manger_type = [LoginModel shareLoginModel].ORG_MANAGER_TYPE;
//    _org_id = [LoginModel shareLoginModel].ORG_ID;
//    
//    
//    return [[[GRIDURL stringByAppendingString:_org_manger_type]stringByAppendingString:@"/"]stringByAppendingString:_org_id];
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
   
     AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[self getUrl] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [self endRefresh];
        [self.gridArray removeAllObjects];

        NSArray * responseArray = [BNMetaDataTools getGridModelArray:responseObject[@"RESULT"]];
        
        [self.gridArray addObjectsFromArray: responseArray];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
        [self endRefresh];
        
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
    BNGridMedol *gridModel = self.gridArray[indexPath.row];
    NSLog(@"----WG_ID---%@",gridModel.WG_ID);
    BNGridCell *cell = [BNGridCell cellWithTableView:tableView AndGridModel:gridModel];
    cell.backgroundColor = [UIColor clearColor];
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BNGridMedol *gridModel = self.gridArray[indexPath.row];
    BNCommunityController *communityVC = [[BNCommunityController alloc]init];
  //  BNAddCommunityController *addCommunityVC = [BNAddCommunityController new];
   // addCommunityVC.WG_ID = gridModel.WG_ID;
    communityVC.WG_ID = gridModel.WG_ID;
    communityVC.WG_DESC = gridModel.WG_DESC;
    [self.navigationController pushViewController:communityVC animated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
