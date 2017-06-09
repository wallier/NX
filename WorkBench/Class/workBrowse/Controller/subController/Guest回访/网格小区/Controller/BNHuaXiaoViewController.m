//
//  BNHuaXiaoViewController.m
//  WorkBench
//
//  Created by wanwan on 16/9/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNHuaXiaoViewController.h"
#import "BNGridCell.h"
#import <MJRefresh.h>
#import "BNGridRoleModel.h"
#import <AFNetworking.h>
#import "BNMetaDataTools.h"
//#import "BNWangGeViewController.h"
#import "BNXiaoQuViewController.h"
#import "BNOneTimeIncreseProductViewController.h"
#import "BNWaterMark.h"

@interface BNHuaXiaoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
// 装网格模型数据的
@property (strong,nonatomic)NSMutableArray *gridArray;
//记录当前请求的page的值
@property (nonatomic, assign) int page;
// 请求返回的数据
@property (strong,nonatomic)id responseObject;
// 悬浮按钮
@property(strong,nonatomic)UIButton *flowButton;
@end
// 常量
static int buttonY;

@implementation BNHuaXiaoViewController

// 懒加载数组
- (NSMutableArray *)gridArray {
    if (!_gridArray) {
        _gridArray = [NSMutableArray arrayWithCapacity:30];
    }
    return _gridArray;
}

- (void)viewWillAppear:(BOOL)animated {
    // 返回时刷新
    [self.tableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    // Title
    self.title = [LoginModel shareLoginModel].NAME;
    [self initTableView];
    [self.tableView.header beginRefreshing];
    // 请求数据
    [self getRequest];
    NSLog(@"--------%@",[LoginModel shareLoginModel].ORG_MANAGER_TYPE);
    // 判断是否添加一次性添加按钮（根据权限）
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]) {
        //  添加悬浮按钮
        _flowButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W-36, SCREEN_H-106, 30, 30)];
        [_flowButton setImage:[UIImage imageNamed:@"add_06"] forState:UIControlStateNormal];
        [_flowButton addTarget:self action:@selector(oneTimeIncreaseData) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:_flowButton];
        [self.tableView bringSubviewToFront:_flowButton];
        buttonY=(int)_flowButton.frame.origin.y;

    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%d",(int)_flowButton.frame.origin.y);
    _flowButton.frame = CGRectMake(_flowButton.frame.origin.x, buttonY+self.tableView.contentOffset.y , _flowButton.frame.size.width, _flowButton.frame.size.height);
}

// 一次性添加按钮
- (void)oneTimeIncreaseData {
    BNOneTimeIncreseProductViewController *addOnceVC = [[BNOneTimeIncreseProductViewController alloc]init];
       // 传递url
      addOnceVC.all_WG_URL = [self getUrl];
    [self.navigationController pushViewController:addOnceVC animated:YES];

}

#pragma mark -- 界面部分

- (void)initTableView{
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
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
    
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]) {
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
    
//    BNWangGeViewController *wangGeVC = [[BNWangGeViewController alloc]init];
//    wangGeVC.org_id= gridRoleModel.ID;
//    wangGeVC.org_manger_type = gridRoleModel.ORG_MANAGER_TYPE;
//    wangGeVC.name = gridRoleModel.NAME;
    
    BNXiaoQuViewController *wangGeVC = [[BNXiaoQuViewController alloc]init];
    wangGeVC.org_id= gridRoleModel.ID;
    wangGeVC.org_manger_type = gridRoleModel.ORG_MANAGER_TYPE;
    wangGeVC.name = gridRoleModel.NAME;

    [self.navigationController pushViewController:wangGeVC animated:YES];
    
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
