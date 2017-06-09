//
//  BNMyWorkController.m
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNMyWorkController.h"
#import "BNPoolItemModel.h"
#import "BNPoolTableViewCell.h"
#import "BNPolicyController.h"
#import "BNPolicyModel.h"
@interface BNMyWorkController ()<UITableViewDelegate,UITableViewDataSource,BNPoolTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *arrPoolItems;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BNMyWorkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的工作";
    [self loadDate];
}


- (void)loadDate{


    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"数据加载中...";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setValue:[LoginModel shareLoginModel].ORG_MANAGER_TYPE forKey:@"userType"];
    [params setObject:[LoginModel shareLoginModel].ORG_ID forKey:@"orgId"];
    [BNNetworkTool initWitUrl:DataPoolURL andParameters:params andStyle:YES].requestData =
    ^(id requestDate){
        self.arrPoolItems = (NSMutableArray *)[BNPoolItemModel objectArrayWithKeyValuesArray:requestDate[@"RESULT"]];
//        NSLog(@"requestDateRESULT==%@", requestDate[@"RESULT"]);
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    };
    NSLog(@"DataPoolURL==%@",DataPoolURL);
}

- (NSMutableArray *)arrPoolItems{
    if (!_arrPoolItems) {
        _arrPoolItems = [NSMutableArray array];
    }
    
    return _arrPoolItems;
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrPoolItems.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    BNPoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BNPoolTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.delegate = self;
    cell.model = self.arrPoolItems[indexPath.section];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:  (NSIndexPath *)indexPath{
    return 150;
}

#pragma mark - BNPoolCellDelegate

- (void)finishedClick:(NSString *)typeFlag andServiceType:(NSString *)serviceType{

    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"model"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setValue:[LoginModel shareLoginModel].ORG_MANAGER_TYPE forKey:@"userType"];
    [params setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgId"];
    [params setValue:serviceType forKey:@"serviceType"];
    [params setValue:typeFlag forKey:@"sanFlag"];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
    
    NSString* strUrl = [DataPoolThreeHeartAnyOneURL stringByAppendingFormat:@"%@/%@/%@/%@/%@",serviceType, typeFlag, [LoginModel shareLoginModel].ORG_MANAGER_TYPE, [LoginModel shareLoginModel].ORG_ID, [LoginModel shareLoginModel].USER_ID];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:strUrl forKey:@"GRABNUMURL"];
    
    NSLog(@"strUrl8==%@", strUrl);
    
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData = ^(id requestDate){
        NSLog(@"params==%@", params);
        [hud setHidden:YES];
        BNPolicyController *policyVc = [[BNPolicyController alloc] init];
        policyVc.arrPolcy = (NSMutableArray *)[BNPolicyModel objectArrayWithKeyValuesArray:requestDate[@"RESULT"]];
        NSLog(@"requestDateRES1===%@", requestDate);
        policyVc.flag = YES;//全区修改
        [policyVc setSanFlag:typeFlag andPolicy:serviceType];
        [self.navigationController pushViewController:policyVc animated:YES];
    };
}

- (void)finishedClickGetAllOrder:(NSString *)serviceType{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"model"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setValue:[LoginModel shareLoginModel].ORG_MANAGER_TYPE forKey:@"userType"];
    [params setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgId"];
    [params setValue:serviceType forKey:@"serviceType"];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
    
    NSString* strUrl = [DataPoolThreeHeartURL stringByAppendingFormat:@"%@/%@/%@/%@",serviceType, [LoginModel shareLoginModel].ORG_MANAGER_TYPE, [LoginModel shareLoginModel].ORG_ID,[LoginModel shareLoginModel].USER_ID];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:strUrl forKey:@"GRABNUMURL"];
    
    NSLog(@"strUrl333==%@", strUrl);
    
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData = ^(id requestDate){
        [hud setHidden:YES];

        BNPolicyController *policyVc = [[BNPolicyController alloc] init];
        policyVc.arrPolcy = (NSMutableArray *)[BNPolicyModel objectArrayWithKeyValuesArray:requestDate[@"RESULT"]];
        NSLog(@"requestDateRES2===%@", requestDate);
        [policyVc setSanFlag:nil andPolicy:serviceType];
        policyVc.flag = YES;
        [self.navigationController pushViewController:policyVc animated:YES];    };
}

- (void)finishedClickGetDevelopOrder:(NSString *)serviceType{
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"model"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setValue:[LoginModel shareLoginModel].ORG_MANAGER_TYPE forKey:@"userType"];
    [params setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgId"];
    [params setValue:serviceType forKey:@"serviceType"];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];

    [BNNetworkTool initWitUrl:DataPoolDevelopURL andParameters:params andStyle:YES].requestData = ^(id requestDate){
        [hud setHidden:YES];

        BNPolicyController *policyVc = [[BNPolicyController alloc] init];
        policyVc.arrPolcy = (NSMutableArray *)[BNPolicyModel objectArrayWithKeyValuesArray:requestDate[@"RESULT"]];
        [policyVc setSanFlag:@"qzfa" andPolicy:serviceType];
        policyVc.flag = YES;
        policyVc.isDevelopFlag = YES;
        [self.navigationController pushViewController:policyVc animated:YES];
    };

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
