//
//  BNQuanQuViewController.m
//  WorkBench
//
//  Created by wanwan on 16/9/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNQuanQuViewController.h"
#import "BNGridCell.h"
#import <MJRefresh.h>
#import "BNGridRoleModel.h"
#import "BNDiShiViewController.h"
#import <AFNetworking.h>
#import "BNMetaDataTools.h"
#import "BNOneTimeIncreseProductViewController.h"
#import "BNWaterMark.h"
//#import "BNAddCommunityController.h"
//#import "BNCommunityContentViewController.h"


@interface BNQuanQuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
// 装网格模型数据的
@property (strong,nonatomic)NSMutableArray *gridArray;
//记录当前请求的page的值
@property (nonatomic, assign) int page;
// 请求返回的数据
@property (strong,nonatomic)id responseObject;
//// 角色编码
//@property (nonatomic, strong) NSString *org_id;
//// 角色类型
//@property (nonatomic, strong) NSString *org_manger_type;
//// 角色名称
//@property (nonatomic, strong) NSString *name;

@end

@implementation BNQuanQuViewController

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
    self.title = [LoginModel shareLoginModel].NAME;
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
        UIImage *bgImage = [BNWaterMark getwatermarkImage];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            
            [self getRequest];
        }];
        
        _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getRequest];
        }];
        // 添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        // 最小间隔时间
        longPress.minimumPressDuration = 2.0;
        [_tableView addGestureRecognizer:longPress];
    }
    [self.view addSubview:self.tableView];
    
    
}
// 长按Action
- (void)longPressAction:(UILongPressGestureRecognizer*)sender {
    
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        __weak BNQuanQuViewController *weakself = self;
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"一次性添加所有信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"------跳转到一次性添加界面");
            [weakself.navigationController pushViewController:[BNOneTimeIncreseProductViewController new] animated:YES];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];

    }

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
    
    return [[[ROLEURL stringByAppendingString:[LoginModel shareLoginModel].ORG_MANAGER_TYPE]stringByAppendingString:@"/"]stringByAppendingString:[LoginModel shareLoginModel].ORG_ID];
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
    WS
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
    
    BNDiShiViewController *diShiVC = [[BNDiShiViewController alloc]init];
    diShiVC.org_id= gridRoleModel.ID;
    diShiVC.org_manger_type = gridRoleModel.ORG_MANAGER_TYPE;
    diShiVC.name = gridRoleModel.NAME;
    [self.navigationController pushViewController:diShiVC animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

