//
//  BNAddCommunityController.m
//  WorkBench
//
//  Created by wanwan on 16/8/15.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNAddCommunityController.h"
#import "BNCommunityCell.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "BNAllCommunityModel.h"
#import "BNMetaDataTools.h"
#import "BNWaterMark.h"

//#import "BNAddProductOnceViewController.h"

@interface BNAddCommunityController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic)NSArray *communityArray;
@property (nonatomic, assign) int page;
@property (strong, nonatomic)id responseObject;
// CITY_NO
@property (nonatomic, strong) NSString *city_ON;
// 判断是否为模糊查询
@property (nonatomic, assign) BOOL isSearch;
// 搜索的小区的关键字
@property (nonatomic, strong) NSString *communityName;
// srearch文本
@property (nonatomic, strong) UITextField *textField;
@end

@implementation BNAddCommunityController

//// 懒加载数组
//- (NSMutableArray *)gridArray {
//    if (!_communityArray) {
//        _communityArray = [NSMutableArray arrayWithCapacity:30];
//    }
//    return _communityArray;
//
//}
// 懒加载
//- (NSMutableArray *)communityArray {
//    if (!_communityArray) {
//        _communityArray = [NSMutableArray array];
//    }
//    return _communityArray;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
  // BNAddProductOnceViewController *cv = [[BNAddProductOnceViewController alloc]init];
    //[self.navigationController pushViewController:cv animated:YES];
    
    // 注册添加小区的通知
    [self registerNotification];
    self.title = @"我的小区";
    // 第一次不是搜索
    _isSearch = NO;
    [self initTableView];
    [self.tableView.header beginRefreshing];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    headerView.backgroundColor = RGB(255, 250, 232);
    
    // 搜索框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(25,5, SCREEN_W-130, 30)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.delegate = self;
    _textField.layer.borderWidth = 1;
    _textField.layer.cornerRadius = 5;
    _textField.tintColor = RGB(255, 143, 12);
    // 注册通知观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldAction) name:UITextFieldTextDidChangeNotification object:nil];
    // 搜索按钮
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W-90, 5, 60, 30)];
    [searchButton setTitle:@"搜索" forState: UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [searchButton setTitleColor:RGB(255, 143, 12) forState:UIControlStateNormal];
    
    // 设置button的边框颜色和圆角
    CALayer *searchButtonLayer = [searchButton layer];
    [searchButtonLayer setMasksToBounds:YES];
    [searchButtonLayer setCornerRadius:5];
    [searchButtonLayer setBorderWidth:1.0];
    [searchButtonLayer setBorderColor:RGB(255, 143, 12).CGColor];
    
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchButton];
    [headerView addSubview:_textField];
    [self.view addSubview:headerView];
    [self getCity_NO];
  //  [self getRequest];
    
}
// 点击return 隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self searchButtonClick];
    return true;
}

// 监听输入框
- (void)textFieldAction {
    // 设置搜索为YES
    _isSearch = YES;
    // 提交关键字
    self.communityName = _textField.text;
    [self getRequest];

}

- (void)initTableView {
    if (!_tableView) {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-105) style:UITableViewStylePlain];
    

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 风格
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
//    self.tableView.separatorColor = RGB(255, 146, 50);
//    self.tableView.separatorInset = UIEdgeInsetsMake(0,80, 0, 80);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // 背景
        self.tableView.backgroundColor = [UIColor clearColor];
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
   
    return ALLREGI_ON_URL;
}

#pragma mark - 传递请求参数

- (NSDictionary *)getParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // 如果用户属性有划小，"ORG_MANAGER_TYPE" = HX;就用PARENT_ID,否则调用 根据网格编码获取区县编码：GRID_ID -->CITY_ID http://ip:port/scm/userback/city/{grid_no}
    
        NSLog(@"---self.city_ON--%@",self.city_ON);
        [dic setValue:self.city_ON forKey:@"CITY_NO"];
    if (!_isSearch) {
        [dic setValue:@""forKey:@"REDION_NAME"];
    }else {
        [dic setValue:self.communityName forKey:@"REDION_NAME"];
    
    }
    
    return dic;
}

- (void)getCity_NO {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 拼接网格编码http://bonc.ittun.com/scm/userback/city/WG8640001000180
    NSLog(@"--CITY_ON_URL---%@",[CITY_ON_URL stringByAppendingString:self.WG_ID]);
    [mgr GET:[CITY_ON_URL stringByAppendingString:self.WG_ID]  parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self endRefresh];
         NSArray * responseArray = responseObject[@"RESULT"];
        self.city_ON = [NSString stringWithFormat:@"%@", responseArray.firstObject[@"CITY_NO"]];
        NSLog(@"---self.City_No---%@",self.city_ON);
       
        [self getRequest];
       // [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"---获取CITY_NO失败-%@",error);
    }];

}

#pragma mark -- 请求数据
- (void)getRequest{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:[self getUrl] parameters:[self getParams] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self endRefresh];
        NSArray *responseArray = [BNMetaDataTools getAllCommunityModelArray:responseObject[@"RESULT"]];
        self.communityArray = responseArray;
        NSLog(@"---数组个数----%lu",(unsigned long)responseArray.count);
        [self.tableView reloadData];
        // 加载完设置为NO
        _isSearch = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
        [self endRefresh];
        // 加载完设置为NO
        _isSearch = NO;

    }];
}


#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.communityArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNAllCommunityModel *communityModel = _communityArray[indexPath.row];
    BNCommunityCell *cell = [BNCommunityCell cellWithTableView:tableView andCommunityModel:communityModel cellForRowAtIndexPath:indexPath andArray:_communityArray];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}


#pragma mark -- searchClickAction

- (void)searchButtonClick{
    // 设置搜索为YES
    _isSearch = YES;
    // 提交关键字
    self.communityName = _textField.text;
    [self getRequest];
    // 退键盘
    [_textField endEditing:YES];
}

# pragma mark -- 监测通知

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(addCommunityAction:) name:@"addCommunityBtn" object:nil];
    
}

- (void)addCommunityAction:(NSNotification*) notification{
    id obj = [notification object];//获取到传递的对象
    // 将字符串转回long类型
    long BtnTag = [obj intValue]-80000;
    NSLog(@"---BtnTag---%ld",BtnTag);
    WS
    AFHTTPSessionManager *mag = [AFHTTPSessionManager manager];
    [mag POST:[self getSendToserverURL] parameters:[self getSendToServerParamsWithBtnTag:BtnTag] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
            [MBProgressHUD showError:@"系统异常"];
        }else if ([responseObject[@"MSGCODE"] isEqualToString:@"606"]){
            [MBProgressHUD showError:@"插入成功"];
        }else{
            [MBProgressHUD showSuccess:@"插入失败"];
                    }
        [weakSelf.navigationController popViewControllerAnimated:YES];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"---添加小区失败----%@",error);

    }];
}

#pragma mark -- 提交服务器的参数
// Param:{"WG_ID":value,"REGION_ID":value,"REDION_NAME":value,"REDION_ADDRESS":value}
- (NSDictionary *)getSendToServerParamsWithBtnTag:(long)btnTag{
    BNAllCommunityModel *allCommunityModel = [BNAllCommunityModel new];
    allCommunityModel = _communityArray[btnTag];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.WG_ID forKey:@"WG_ID"];
    [dic setValue:allCommunityModel.REGION_ID forKey:@"REGION_ID"];
    [dic setValue:[LoginModel shareLoginModel].USER_NAME forKey:@"MODIFIED_BY"];
//    [dic setValue:allCommunityModel.REDION_NAME forKey:@"REDION_NAME"];
//    [dic setValue:allCommunityModel.REDION_ADDRESS forKey:@"REDION_ADDRESS"];
    return dic;
}
- (NSString *)getSendToserverURL{
    return ADDREGION_URL;
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
