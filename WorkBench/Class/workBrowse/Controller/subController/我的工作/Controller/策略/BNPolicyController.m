//
//  BNPolicyController.m
//  WorkBench
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNPolicyController.h"
#import "MyHeadView.h"
#import "BNPolicyModel.h"
#import "BNPolicyViewCell.h"
#import "BNOrderDetailModel.h"
#import "BNOrderDetailController.h"
#import "BNGrabOrderDetailController.h"
#import "BNMyOrderDetailController.h"

@interface BNPolicyController ()
@property (nonatomic, strong) NSMutableArray *arrClwx;
@property (nonatomic, strong) NSMutableArray  *arrJzts;
@property (nonatomic, strong) NSMutableArray *arrModel;


@end

static NSString *cellIdentifier =@"cellsss";

@implementation BNPolicyController

- (void)viewWillAppear:(BOOL)animated
{
    if([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||[[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"])
    {
        [self cancelInterface];
    }
}

-(void)requestData:(NSString*)strUrl
{
    
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData = ^(id requestDate){
        NSLog(@"requestDate==%@",requestDate);
        [self setArrPolcy:(NSMutableArray*)[BNPolicyModel objectArrayWithKeyValuesArray:requestDate[@"RESULT"]]];
        
//        [UIView performWithoutAnimation:^{
//            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
//        }];
//        [UIView performWithoutAnimation:^{
//            [self.collectionView reloadData];
//        }];
        if(_PolicyIndexPath){
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadItemsAtIndexPaths:@[_PolicyIndexPath]];
            }];
        }

    };
    
}

-(void)cancelInterface
{
    if(_paramsPlus)
    {
        //调用注销接口
        NSString* strUrl = [GrabOnlineOrDownlineURL stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@",_paramsPlus[@"serviceType"],_paramsPlus[@"taskId"],_paramsPlus[@"policyId"],[LoginModel shareLoginModel].USER_ID,_paramsPlus[@"userType"],_paramsPlus[@"orgId"],@"1"];
        
        NSLog(@"strUrl890==%@", strUrl);
        //    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
        [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData = ^(id requestDate){
            NSLog(@"requestDate111==%@", requestDate);
            
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *GRABNUMURL = [userDefaultes stringForKey:@"GRABNUMURL"];
            
            [self requestData:GRABNUMURL];
        };
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _PolicyIndexPath = nil;
    _paramsPlus = nil;

//    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
//    
//    [userDefaultes setObject:@"" forKey:@"PolicyIndexPath"];
    if(!_flowLayout){
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _flowLayout.itemSize = CGSizeMake((self.view.frame.size.width - 40 ) / 2 ,90);
    
    _flowLayout.sectionInset = UIEdgeInsetsMake(0,8,5,8);//设置每个cell的上左下右距离
    _flowLayout.minimumLineSpacing = 5;
    }
    
    if(!self.collectionView)
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:self.flowLayout];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"BNPolicyViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
        [self.collectionView registerClass:[MyHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader"];
        [self.view addSubview:_collectionView];
    }
  
}

- (NSMutableArray *)arrClwx{
    if (!_arrClwx) {
        _arrClwx = [NSMutableArray array];
    }
    
    return  _arrClwx;
}

- (NSMutableArray *)arrJzts{
    if (!_arrJzts) {
        _arrJzts = [NSMutableArray array];
    }
    return _arrJzts;
}

- (NSMutableArray *)arrModel{
    if (!_arrModel) {
        _arrModel = [NSMutableArray array];
    }
    return _arrModel;
}

- (void)setArrPolcy:(NSMutableArray *)arrPolcy{
    _arrPolcy = arrPolcy;

    for (BNPolicyModel *model in _arrPolcy) {
        if ([model.TASK_NAME isEqualToString:@"存量维系"]) {
            self.arrClwx = nil;
            [self.arrClwx addObject:model];
        } else {
            self.arrJzts = nil;
            [self.arrJzts addObject:model];
        }
    }
    self.arrModel = nil;
    [self.arrModel addObject:self.arrClwx];
    [self.arrModel addObject:self.arrJzts];
    
    NSLog(@"self.arrModel---%@",self.arrModel);

}

- (void)setArrPolcyR:(NSMutableArray *)arrPolcy{
    _arrPolcy = arrPolcy;
    
    for (BNPolicyModel *model in _arrPolcy) {
        if ([model.TASK_NAME isEqualToString:@"存量维系"]) {
            [self.arrClwx addObject:model];
        } else {
            [self.arrJzts addObject:model];
        }
    }
    
    [self.arrModel addObject:self.arrClwx];
    [self.arrModel addObject:self.arrJzts];
    
    if([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||[[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"])
    {
        [_collectionView reloadData];
    }
}


- (void)setSanFlag:(NSString *)sanFlag andPolicy:(NSString *)policy{
    
    
    NSString *str = [NSString stringWithFormat:@"< %@-%@",[self judgeServiceType:policy], sanFlag ?[self judgeSanFlag:sanFlag]:@"三心用户"];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0,self.view.frame.size.width / 2, 40)];
    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [back setTitle:str forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
}

#pragma  mark -UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return section == 0 ? self.arrClwx.count : self.arrJzts.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
      BNPolicyViewCell *cell = (BNPolicyViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier: cellIdentifier forIndexPath:indexPath];
    
        if (!cell) {
            cell = [[BNPolicyViewCell alloc] init];//WithFrame:CGRectMake(0, 0, 100, 50)
        }
    

        //    NSLog(@"org====%@", [LoginModel shareLoginModel].ORG_MANAGER_TYPE);
        if([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||[[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"])
        {
            cell.flagHXWG = 1;
        }
        else
        {
            cell.flagHXWG = 1;
//            cell.flag = self.flag;
        }
    
        cell.model = self.arrModel[indexPath.section][indexPath.row];
    
    return cell;

}

//设置headview和FootView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    WS;
    if (kind==UICollectionElementKindSectionHeader) {
        
        MyHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];
        if(indexPath.section == 0){
            headView.lab.text = @"存量维系360";
        }else if (indexPath.section == 1){
            headView.lab.text = @"价值提升360";
        }
        headView.getmore = ^{
            if (indexPath.section == 0) {
                if (weakSelf.arrClwx.count > 4 && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"getmore1"] isEqualToString:@"1"]) {
                    [weakSelf.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:0]];
                }else{
                    [weakSelf.view makeToast:@"没有更多数据" duration:0.5 position:CSToastPositionCenter];
                }
            }else{
                if (weakSelf.arrJzts.count>4 && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"getmore2"] isEqualToString:@"2"]) {
                    //_moreFlag2 = YES;
                    [weakSelf.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:1]] ;
                }else{
                    [weakSelf.view makeToast:@"没有更多数据" duration:0.5 position:CSToastPositionCenter];
                }
            }
        };
        return headView;
        
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (!self.isDevelopFlag) {
        CGSize size = {320, 40};
        return size;
    }
    return CGSizeMake(0,0);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int size = self.view.height  / 36;
    
    //保存indexPath刷新
    _PolicyIndexPath = indexPath;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:PolicyIndexPath forKey:@"PolicyIndexPath"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:[LoginModel shareLoginModel].ORG_MANAGER_TYPE forKey:@"userType"];
    [params setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgId"];
    BNPolicyViewCell *cell = (BNPolicyViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [params setValue:cell.model.SERVICE_TYPE forKey:@"serviceType"];
    [params setValue:cell.model.TASK_ID forKey:@"taskId"];
    [params setValue:cell.model.POLICY_ID forKey:@"policyId"];
    if ([cell.model.SAN_FALG length])
    {
        [params setValue:cell.model.SAN_FALG forKey:@"sanFlag"];
    }
    
    NSLog(@"SAN_FALG888==%@", cell.model.SAN_FALG);
//    else
//    {
//        [params setValue:@"sanFlag" forKey:@"sanFlag"];
//    }
    
    [params setValue:@"1"forKey:@"pageNum"];
    
    //如果是化小和网格行数要小 size-3
    if([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||[[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"])
    {
        [params setValue:[NSString stringWithFormat:@"%d",size-3] forKey:@"pageSize"];
        [[NSUserDefaults standardUserDefaults] setInteger:size-3 forKey:@"pagesize"];
    }
    else
    {
        [params setValue:[NSString stringWithFormat:@"%d",size] forKey:@"pageSize"];
        [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"pagesize"];
    }

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];              //CRM参数
    [dic setValue:cell.model.POLICY_ID forKey:@"policyId"];                   //策略ID
    [dic setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgIdCode"];   //地域编码
    
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"QQ"]) {
        [dic setValue:@"1" forKey:@"orgIdNum"];    //地域等级
    }else if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"DS"]){
        [dic setValue:@"2" forKey:@"orgIdNum"];    //地域等级
    }else if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"QX"]){
        [dic setValue:@"3" forKey:@"orgIdNum"];    //地域等级
    }else if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]){
        [dic setValue:@"4" forKey:@"orgIdNum"];    //地域等级
    }else if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]){
        [dic setValue:@"5" forKey:@"orgIdNum"];    //地域等级
    }
    [dic setValue:cell.model.START_DATE forKey:@"startDate"];   //工单创建时间
    [dic setValue:@"" forKey:@"resultHs"];    //返回参数

    
    if([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"] ||
       [[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]){

        MBProgressHUD *hud = [MBProgressHUD showMessage:@"数据同步中..." toView:self.view.window];
        [BNNetworkTool initWitUrl:HXdataupdatewithCRM andParameters:dic andStyle:YES].requestData =
        ^(id requestDate){
            [hud setHidden:YES];
            [self EnterOrderList:params andCell:cell];

        };
       
    } else {
          [self EnterOrderList:params andCell:cell];
    }

    
}

- (void)EnterOrderList:(NSMutableDictionary *)params andCell:(BNPolicyViewCell *)cell {
    
    
    [params setValue:@"-1," forKey:@"executeState"];
    [params setValue:@"-1" forKey:@"forwordSend"];
    [params setValue:@"-1" forKey:@"orgIdIndex"];
    [params setValue:@"-1" forKey:@"sxOrgManagerType"];
    
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
    
    NSString* strUrl = @"";
    
     if (![params objectForKey:@"sanFlag"])
     {
         
         //判断是HX和WG 去做 我的数据的获取
         
         if([[params objectForKey:@"userType"] isEqualToString:@"HX"]||[[params objectForKey:@"userType"] isEqualToString:@"WG"])
         {
            strUrl = [GetThreeHeartUserOwnGrabListURL stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[LoginModel shareLoginModel].USER_ID,[params objectForKey:@"serviceType"], [params objectForKey:@"taskId"], [params objectForKey:@"policyId"], [params objectForKey:@"userType"], [params objectForKey:@"orgId"], [params objectForKey:@"pageNum"], [params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
         }
         else
         {
            strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[params objectForKey:@"serviceType"], [params objectForKey:@"taskId"], [params objectForKey:@"policyId"], [params objectForKey:@"userType"], [params objectForKey:@"orgId"], [params objectForKey:@"pageNum"], [params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
         }

     }
     else
     {
         
         if([[params objectForKey:@"userType"] isEqualToString:@"HX"]||[[params objectForKey:@"userType"] isEqualToString:@"WG"])
         {
             strUrl = [GetThreeHeartUserOwnGrabListURL stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[LoginModel shareLoginModel].USER_ID,[params objectForKey:@"serviceType"], [params objectForKey:@"taskId"], [params objectForKey:@"policyId"], [params objectForKey:@"userType"], [params objectForKey:@"orgId"], [params objectForKey:@"pageNum"], [params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
         }
         else
         {
             strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[params objectForKey:@"serviceType"], [params objectForKey:@"sanFlag"], [params objectForKey:@"taskId"], [params objectForKey:@"policyId"], [params objectForKey:@"userType"], [params objectForKey:@"orgId"], [params objectForKey:@"pageNum"], [params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
         }
     }
    _paramsPlus = params;
//    NSString* strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[params objectForKey:@"serviceType"], [params objectForKey:@"taskId"], [params objectForKey:@"policyId"], [params objectForKey:@"userType"], [params objectForKey:@"orgId"], [params objectForKey:@"pageNum"], [params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    
    NSLog(@"strUrl111==%@", strUrl);
    
    NSLog(@"params99==%@---%@", [params objectForKey:@"orgId"],params);

//    _cplus = 0;
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData =
    ^(id requestData){
        [hud setHidden:YES];
        
//        for (id obj in requestData[@"RESULT"])
//        {
//            if([[obj objectForKey:@"ORDER_STATE"] intValue]==0)
//                _cplus++;
//        }
        
        if([[params objectForKey:@"userType"] isEqualToString:@"HX"]||[[params objectForKey:@"userType"] isEqualToString:@"WG"])
        {
            //在此添加新方法判断是否进入房间
            
            NSString* onlineUrl = [GrabOnlineOrDownlineURL stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@",params[@"serviceType"],params[@"taskId"],params[@"policyId"],[LoginModel shareLoginModel].USER_ID,params[@"userType"],params[@"orgId"],@"0"];
            NSString* onlingUrl = [GrabOnlineOrDownlineURL stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@",params[@"serviceType"],params[@"taskId"],params[@"policyId"],[LoginModel shareLoginModel].USER_ID,params[@"userType"],params[@"orgId"],@"2"];
            
            NSLog(@"strUrl890==%@", onlineUrl);
            //    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
            [BNNetworkTool initWitUrl:onlineUrl andParameters:nil andStyle:NO].requestData = ^(id requestDate){
                NSLog(@"requestDate555==%@", requestDate);
                NSString *strNum = [NSString stringWithFormat:@"%@",requestDate[@"MSGISOK"]];
                //        NSString* strNum = [NSString stringWithFormat:@"%@",requestDate[@"MSGISOK"]];
                NSLog(@"strNum---%d",[strNum intValue]);
                if([strNum intValue]==1)
                {
                    NSLog(@"可以进入抢单");
            BNGrabOrderDetailController *vc = [[BNGrabOrderDetailController alloc] init];
            vc.mymaxCout = [cell.model.GRABEXCUTE intValue]+[cell.model.GRABEXCUTENOT intValue];
            vc.maxCout = [cell.model.GRABNUM intValue];//[cell.model.USER_NUM intValue]
                    //            NSLog(@"intvalu==%d----%d", [cell.model.GRABNUM intValue],[cell.model.UNGRABNUM intValue]);
            vc.params = params;
            vc.url = strUrl;
            vc.onlineUrl = onlingUrl;
//            vc.titleLabLeftStr = [NSString stringWithFormat:@"  %d/%@户", _cplus,requestData[@"SIZE"]];
            [vc setNavLeftTitle:cell.model.POLICY_NAME];
            vc.myarrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
                                [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    NSLog(@"只能进入我的");
                    BNMyOrderDetailController *vc = [[BNMyOrderDetailController alloc] init];
                    vc.mymaxCout = [cell.model.GRABEXCUTE intValue]+[cell.model.GRABEXCUTENOT intValue];
                    vc.maxCout = [cell.model.GRABNUM intValue];//[cell.model.USER_NUM intValue]
                    //            NSLog(@"intvalu==%d----%d", [cell.model.GRABNUM intValue],[cell.model.UNGRABNUM intValue]);
                    vc.params = params;
                    vc.url = strUrl;
//                    vc.titleLabLeftStr = [NSString stringWithFormat:@"  %d/%@户", _cplus,requestData[@"SIZE"]];
                    [vc setNavLeftTitle:cell.model.POLICY_NAME];
                    vc.myarrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            };

        }
        else
        {
            BNOrderDetailController *vc = [[BNOrderDetailController alloc] init];
            vc.maxCout = [cell.model.USER_NUM intValue];
            vc.params = params;
            vc.url = strUrl;
            [vc setNavLeftTitle:cell.model.POLICY_NAME];
            vc.arrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
            [self.navigationController pushViewController:vc animated:YES];
        }

        NSLog(@"%@",requestData);
    
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
#pragma mark - 设置导航标题
- (NSString *)judgeSanFlag:(NSString *)sanFlag{
    
    switch (sanFlag.integerValue) {
        case 1:
            return  @"操心用户";
            break;
        case 2:
            return @"关心用户";
            break;
        case 3:
            return @"放心用户";
            break;
        default:
            return @"潜在发展用户";
            break;
    }

    return nil;
}

- (NSString *)judgeServiceType:(NSString *)policy{
    switch (policy.integerValue) {
        case 1001:
            return  @"移动";
            break;
        case 1002:
            return @"宽带";
            break;
        case 1003:
            return @"ITV";
            break;
        default:
            break;
    }
    
    return nil;

}


- (void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    NSLog(@"策略--dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
