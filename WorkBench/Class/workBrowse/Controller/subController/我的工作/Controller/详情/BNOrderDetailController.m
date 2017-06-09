//
//  BNOrderDetailController.m
//  WorkBench
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNOrderDetailController.h"
#import "BNOrdeDetailTableCell.h"
#import "PageSelectView.h"
#import "WG_view.h"
#import "ZpChoseView.h"
#import "BNOrderBaseController.h"
#import "BNOrderBaseModel.h"

@interface BNOrderDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PageSelectView *selectView;
@property (nonatomic, strong) NSMutableArray *arrZpCell;
@property (nonatomic, strong) WG_view *view_wg;
@property(nonatomic,strong) UIView *view_block;
@property(nonatomic,strong) ZpChoseView *zpView;
@property (nonatomic, strong) NSString *Navtitle;    ///<标题

@end

@implementation BNOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:@"reload" object:nil];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (PageSelectView *)selectView{
    if (!_selectView) {
        WS;
        _selectView = [[PageSelectView alloc] init];
        _selectView.sendcont = ^(int count){
            [weakSelf.params setValue:[NSString stringWithFormat:@"%d",count] forKey:@"pageNum"];
            [weakSelf getINfoOfPage:count];
        };
        _selectView.currentPage = 1;
        int count = [[[NSUserDefaults standardUserDefaults] valueForKey:@"pagesize"] intValue];
        NSLog(@"count99===%d---%d", count,self.maxCout);
        _selectView.maxPage = self.maxCout <= count ? 1 : self.maxCout/count+1;
        
        [_selectView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _selectView;
}

- (UIView *)view_block{
    if (!_view_block) {
        _view_block = [[UIView alloc] initWithFrame:self.view.bounds];
        [_view_block setBackgroundColor:[UIColor blackColor]];
        [_view_block setAlpha:0];
        
    }
    return _view_block;
}

- (ZpChoseView *)zpView{
    if (!_zpView) {
        WS;
        _zpView = [[ZpChoseView alloc] initWithFrame:
                   self.view.bounds];
        _zpView.y = 40;
        _zpView.parameters = self.params;
        _zpView.getChoseData = ^(NSDictionary *dic){
            if (!dic) {
                [weakSelf.view_block setAlpha:0];
                [weakSelf.view_block removeFromSuperview];
                return ;
            }
            MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView: weakSelf.view.window];
            [BNNetworkTool initWitUrl:weakSelf.url andParameters:dic andStyle:YES].requestData =
            ^(id requestData){
                NSLog(@"%@",requestData);
                [hud setHidden:YES];
                weakSelf.arrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
                [weakSelf.tableView reloadData];
                
            };
            NSLog(@"%@",dic);
        };
    }
    return _zpView;
    
}

- (NSMutableArray *)arrZpCell{
    if (!_arrZpCell) {
        _arrZpCell = [NSMutableArray array];
    }
    return _arrZpCell;
}

- (void)setArrModel:(NSMutableArray *)arrModel{
    
    _arrModel = arrModel;
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.selectView];
}

-(void)getINfoOfPage:(int)count{
    WS;
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
    
//    NSString* strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    
    NSString* strUrl = @"";
    NSLog(@"sanFlag-8-%@", [self.params objectForKey:@"sanFlag"]);
    if([[self judgeUrl] rangeOfString:@"getThreeHeartUserGrabList"].location !=NSNotFound)
    {
        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    }
    else
    {
        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    }
    NSString* pagecount = [NSString stringWithFormat:@"%d",count];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pagecount forKey:@"pagecount"];
    
//    if ([[self.params objectForKey:@"sanFlag"] isEqualToString:@"sanFlag"])
//    {
//        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
//    }
//    else
//    {
//        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
//    }
    
    
    NSLog(@"strUrl222==%@", strUrl);
    
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData
    = ^(id requestData){
        [hud setHidden:YES];
        self.arrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
        [weakSelf.tableView reloadData];
    };
    
}

- (NSString *)judgeUrl{
    
    int flag = [[[NSUserDefaults standardUserDefaults] valueForKey:@"model"] intValue];
    
    switch (flag) {
        case 0:
            return DataPoolThreeHeartUserListURL; //三心
            break;
        case 1:
            return DataPoolDevChanceUserListURL; //发展
            break;
        case 2:
            return DataPoolThreeHeartItemUserListURL; //条目
            break;
        default:
            break;
    }
    return nil;
}

- (void)setNavLeftTitle:(NSString *)title{
    NSString *str = [NSString stringWithFormat:@"< %@",title];
    self.Navtitle = str;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0,self.view.frame.size.width / 2, 40)];
    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [back setTitle:str forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||
          [[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]){
              UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
              rightBtn.layer.borderWidth = 1;
              rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
              [rightBtn setTintColor:[UIColor clearColor]];
              rightBtn.layer.cornerRadius = 6;
              [rightBtn setFrame:CGRectMake(0, 4, 60, 30)];
              rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
              [rightBtn setTitle:@"转派" forState:UIControlStateNormal];
              [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
              [rightBtn addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchUpInside];
              
              UILongPressGestureRecognizer *longPressGR =
              [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(longPress:)];
              longPressGR.minimumPressDuration = 0.5;
              [rightBtn addGestureRecognizer:longPressGR];
              self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
          }
    
}

- (void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    BNOrdeDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BNOrdeDetailTableCell" owner:self options:nil] lastObject];
    }
    cell.model = self.arrModel[indexPath.row];
//    cell.btnChoseOrder.hidden = NO;
    [[LoginModel shareLoginModel] setOrderDetail:cell.model];
    [cell.btnChoseOrder addTarget:self action:@selector(addZpData:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BNOrdeDetailTableCell *cell = (BNOrdeDetailTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [_params setValue:cell.model.USER_ACCR forKey:@"userAccr"];
    NSLog(@"%@",[self.params allKeys]);
    [_params setValue:cell.model.SAN_FALG forKey:@"sanFlag"];
    [_params setValue:[self judgeOrderType] forKey:@"workOrderType"];
    
    
    // 单条工单状态同步 HXdatacoordinationwithCR
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:cell.model.ORDER_NO forKey:@"orderNo"];     //工单流水
    [dic setValue:@"" forKey:@"orderBody"];                   //回单内容，传入是为空字符串
    [dic setValue:cell.model.USER_ID forKey:@"userId"];       //用户实例id
    [dic setValue:cell.model.POLICY_ID forKey:@"policyId"];   //策略ID
    [dic setValue:[LoginModel shareLoginModel].LOGIN_ID forKey:@"staffId"]; //登录工号 （staff_id）
    [dic setValue:cell.model.START_DATE forKey:@"startDate"];  //工单创建时间
    [dic setValue:cell.model.ORDER_STATE forKey:@"orderstate"];  //工单状态
    [dic setValue:@"" forKey:@"resultHs"];    //返回参数，传入是为空字符串
    
    [self.params setValue:dic[@"orderNo"] forKey:@"orderNo"];
    
    if([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||[[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]){
        
        //先判断pool表里的工单state，在判断CRM
        if([cell.model.ORDER_STATE isEqualToString:@"0"]){
            //调用CRM函数
            
            [BNNetworkTool initWitUrl:HXdatacoordinationwithCRM andParameters:dic andStyle:YES].requestData
            = ^(id request){
                //进入工单
                if ([request[@"MSGCODE"] intValue]==0) {
                    
                    //                    [self enterOrder:cell.img_state.image andIndex:indexPath.row andFlag:YES];
                    
                    [BNNetworkTool initWitUrl:DataPoolThreeHeartDefaultOrderURL andParameters:self.params andStyle:YES].requestData = ^(id requestData){
                        [hud setHidden:YES];
                        if([[requestData valueForKey:@"MSGCODE"] isEqualToString:@"300"]){
                            
                            BNOrderBaseController *baseVC = [[BNOrderBaseController alloc] init];
                            baseVC.params = self.params;
                            baseVC.navTitle = self.Navtitle;

                            baseVC.model = [BNOrderBaseModel objectWithKeyValues:requestData[@"RESULT"][0]];
                            
                            [self.navigationController pushViewController:baseVC animated:YES];
                        }
                        
                    };
                }else{
                    [BNNetworkTool initWitUrl:DataPoolThreeHeartDefaultOrderURL andParameters:self.params andStyle:YES].requestData = ^(id requestData){
                        [hud setHidden:YES];
                        if([[requestData valueForKey:@"MSGCODE"] isEqualToString:@"300"]){
                            BNOrderBaseController *baseVC = [[BNOrderBaseController alloc] init];
                            baseVC.params = self.params;
                            baseVC.model = [BNOrderBaseModel objectWithKeyValues:requestData[@"RESULT"][0]];
                            baseVC.navTitle = self.Navtitle;

                            [self.navigationController pushViewController:baseVC animated:YES];
                        }};
                }
            };
        }
        else {
            [BNNetworkTool initWitUrl:DataPoolThreeHeartDefaultOrderURL andParameters:self.params andStyle:YES].requestData = ^(id requestData){
                [hud setHidden:YES];
                if([[requestData valueForKey:@"MSGCODE"] isEqualToString:@"300"]){
                    BNOrderBaseController *baseVC = [[BNOrderBaseController alloc] init];
                    baseVC.params = self.params;
                    
                    baseVC.model = [BNOrderBaseModel objectWithKeyValues:requestData[@"RESULT"][0] ];
                    baseVC.navTitle = self.Navtitle;
                    [self.navigationController pushViewController:baseVC animated:YES];
                    
                }
            };
            
        }
    } else {
        [BNNetworkTool initWitUrl:DataPoolThreeHeartDefaultOrderURL andParameters:self.params andStyle:YES].requestData = ^(id requestData){
            [hud setHidden:YES];
            if([[requestData valueForKey:@"MSGCODE"] isEqualToString:@"300"]){
                BNOrderBaseController *baseVC = [[BNOrderBaseController alloc] init];
                baseVC.params = self.params;
                baseVC.model = [BNOrderBaseModel objectWithKeyValues:requestData[@"RESULT"][0] ];
                baseVC.navTitle = self.Navtitle;
                
                [self.navigationController pushViewController:baseVC animated:YES];
            }
        };
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 33;
}


#pragma mark - UIEVENTSENDER
- (void)addZpData:(customBtn *)sender{
    
    if (!sender.selected) {
        [self.arrZpCell addObject:sender.cell];
        NSLog(@"%@",self.arrZpCell);
        sender.selected = YES;
    }else{
        [self.arrZpCell removeObject:sender.cell];
        NSLog(@"%@",self.arrZpCell);
        sender.selected = NO;
    }
    
}

- (void)longPress:(UIGestureRecognizer*)gesture{
    [self.view addSubview:self.view_block];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view_block setAlpha:0.5];
    }];
    [self.view addSubview:self.zpView];
    [self.zpView resetting];

    
    
}

- (void)sendData{
    if (self.arrZpCell.count == 0) {
        [self.view makeToast:@"请选择数据" duration:0.5 position:CSToastPositionCenter];
        return;
    }
    _view_wg = [[ WG_view alloc] initWithFrame:
                CGRectMake(0, 0, self.view.frame.size.width-20, self.view.frame.size.height-150)];
    
    _view_wg.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    [_view_wg setAlpha:0];
    WS;
    _view_wg.closed = ^(void){
        [weakSelf btnClosed];
    };
    [self.view addSubview:self.view_block];
    [self.view addSubview:_view_wg];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_view_block setAlpha:0.5];
        [_view_wg setAlpha:1];
    }];
    _view_wg.sendorgid = ^(NSString *str_ordid){
        MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在转派..." toView:weakSelf.view.window];
        for (BNOrdeDetailTableCell * cell in weakSelf.arrZpCell) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:cell.model.USER_ACCR forKey:@"userAccr"];
            [dic setValue:cell.model.SERVICE_TYPE forKey:@"serviceType"];
            [dic setValue:cell.model.TASK_ID forKey:@"taskId"];
            [dic setValue:cell.model.POLICY_ID forKey:@"policyId"];
            [dic setValue:str_ordid forKey:@"orgId"];
            [dic setValue:[weakSelf judgeOrderType] forKey:@"workOrderType"];
            
            [BNNetworkTool initWitUrl:DataPoolWGDataThreeURL andParameters:dic andStyle:YES].requestData
            = ^(id requestData){
                [hud setHidden:YES];
                static int count;
                if ([[requestData valueForKey:@"MSGCODE"] containsString:@"700"]) {
                    count ++;
                    if (count == [self.arrZpCell count]) {
                        [weakSelf.view.window makeToast:@"转派成功" duration:0.5 position:CSToastPositionCenter];
                        count = 0;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
                        [weakSelf btnClear];
                    }
                    [weakSelf btnClosed];               
                 }
            };
        }

    };
}

- (void)refreshData{
    
    NSString* strUrl = @"";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* pagecount = [defaults objectForKey:@"pagecount"];
    
    if([[self judgeUrl] rangeOfString:@"getThreeHeartUserGrabList"].location !=NSNotFound)
    {
        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], pagecount, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    }
    else
    {
        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], pagecount, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    }
    
    
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData =
    ^(id requestData){
        self.arrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
        [self.tableView reloadData];
    };
}

- (NSString *)judgeOrderType{
    
    int flag = [[[NSUserDefaults standardUserDefaults] valueForKey:@"model"] intValue];
    
    switch (flag) {
        case 0:
            return @"DP_WORKORDER_TYPE_SAN"; //三心
            break;
        case 1:
            return @"DP_WORKORDER_TYPE_DEVCHANCE"; //发展
            break;
        case 2:
            return @"DP_WORKORDER_TYPE_SAN_ITEM"; //条目
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)btnClear{
    [self.arrZpCell removeAllObjects];
}

- (void)viewWillLayoutSubviews{
    self.tableView.height = self.view.height - 50;
    self.tableView.width = self.view.width;
    self.selectView.y = self.tableView.y + self.tableView.height;
    self.selectView.x = 0;
    self.selectView.height = 49;
    self.selectView.width = self.view.width;
}

-(void)btnClosed{
    [_view_wg removeFromSuperview];
    [_view_block removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"详情--dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
