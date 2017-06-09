//
//  BNCustomerController.m
//  WorkBench
//
//  Created by mac on 16/2/1.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "BNLDModel.h"
#import "BNOrderDetailController.h"
#import "KHScrollView.h"
#import "BNCustomerController.h"
#import "BNLDViewController.h"
#import <AFNetworking.h>

@interface BNCustomerController ()<MFMessageComposeViewControllerDelegate>
@property(nonatomic,assign)BOOL flag;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) KHScrollView *scr;
@end

@implementation BNCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)resigBackActive{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)getWebView{
  
    NSDictionary *param = @{@"userId":[LoginModel shareLoginModel].orderDetail.USER_ID};
    [BNNetworkTool initWitUrl:DataPoolUserInfoTrendURL andParameters:param andStyle:YES].requestData = ^(id requestData){
        NSString *URL = [NSString stringWithFormat:@"%@",[requestData valueForKey:@"URL"]];
        NSURL *urls =[NSURL URLWithString:URL];
        //        NSLog(@"trend url is :%@", URL);
        _repView.scalesPageToFit = YES;
        //        _scr.personView.webView.scalesPageToFit = YES;
        NSLog(@"-----urls------%@",urls);
        NSURLRequest *urlRequest =[NSURLRequest requestWithURL:urls];
        [self.repView loadRequest:urlRequest];
        [_scr.personView.webView loadRequest:urlRequest];
        _scr.personView.webView.navigationDelegate = self;
        _scr.personView.webView.UIDelegate = self;
    };
}

- (void)setParams:(NSMutableDictionary *)params{
    
    [self setNavTitle];
    [self setview];
    _params = params;
    [self getWebView];
    
    
    _lab_tele.text = self.model.USER_ACCR;
    _lab_khmc.text = self.model.USER_NAME;
    _lab_zdah.text = self.model.USER_INTEREST;
    _lab_swrs.text = self.model.USER_KIND;
    _lab_rwsj.text = self.model.START_DATE;
    _lab_tc.text = self.model.OFFER_BRAND;
    
}


- (void)setview{
    
    // test data
    _scr = [[KHScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-80- 64 - 40) ];
    [self.view addSubview:_scr];
    _scr.sendData = ^(NSDictionary *dic){
        
        
    };
    
    _scr.dicPerson = (NSDictionary *)self.model;//[RAPPLICATION arr_userInfo][0];
    UILabel *lab_hm = [[UILabel alloc] initWithFrame:CGRectMake(12, 4, 120, 30)];
    [self.view addSubview:lab_hm];
    lab_hm.text = @"号码 : ";
    lab_hm.font = UIFONT(15);
    
    _lab_tele = [[UILabel alloc] initWithFrame:CGRectMake(64, 4, 180, 30)];
    [self.view addSubview:_lab_tele];
    _lab_tele.font = UIFONT(15);
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lab_tele.frame)-20, 64, 70, 30)];
    lab.font = UIFONT(15);
    
    lab.text = self.stt_rh;
    [self.view addSubview:lab];
    
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame)-15, 4, 30, 30)];
    NSString *imgName = nil;
    if ([_arr_data[0][@"SAN_FALG"] isEqualToString:@"01"] ) {
        imgName = @"dp_workorder_worry_icon";
    }else if ([_arr_data[0][@"SAN_FLAG"] isEqualToString:@"02"]){
        imgName = @"dp_workorder_carefor_icon";
    }else{
        imgName = @"dp_workorder_reassure_icon";
        
    }
    img.image = [UIImage imageNamed:imgName];
    [self.view addSubview:img];
    //电话、短信
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(_scr.frame), self.view.frame.size.width, 80)];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:view];
    if (([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||[[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"])) {
        _btn_msg = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_msg setFrame:CGRectMake(self.view.frame.size.width/2 -100, 20, 50, 50)];
        _btn_msg.tag = 9090;
        [_btn_msg addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_btn_msg];
        
        
        _btn_tele = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_tele setFrame:CGRectMake(self.view.frame.size.width/2+60 , 20, 50, 50)];
        _btn_tele.tag = 8080;
        [_btn_tele addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_btn_tele];
        
        
        if ([self.model.ORDER_STATE isEqualToString:@"2"]) {
            //状态为执行中
            [_btn_msg setBackgroundImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
            [_btn_tele setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        } else if([self.model.ORDER_STATE isEqualToString:@"1"]){
            //已经执行
            [_btn_msg setHidden:YES];
            [_btn_tele setHidden:YES];
        }else{
            [_btn_msg setBackgroundImage:[UIImage imageNamed:@"datapoolp_sms_icon"] forState:UIControlStateNormal];
            [_btn_tele setBackgroundImage:[UIImage imageNamed:@"datapoolp_call_icon"] forState:UIControlStateNormal];
        }
        
    }
    
}

-(void)clicked:(UIButton *)sender{
    
    //打电话、发短信 前调用工单同步
    [self resigBackActive];
    
    if ([self.model.ORDER_STATE isEqualToString:@"0"]) {
        NSMutableDictionary *dics = [NSMutableDictionary dictionary];
        [dics setValue:[LoginModel shareLoginModel].orderDetail.ORDER_NO forKey:@"orderNo"];    //工单流水
        [dics setValue:@"" forKey:@"orderBody"];    //回单内容，传入是为空字符串
        [dics setValue:[LoginModel shareLoginModel].orderDetail.USER_ID forKey:@"userId"];    //用户实例id
        [dics setValue:[self.params valueForKey:@"ploicyId"] forKey:@"policyId"];  //策略ID
        [dics setValue:[LoginModel shareLoginModel].LOGIN_ID forKey:@"staffId"];    //登录工号 （staff_id）
        [dics setValue:[LoginModel shareLoginModel].orderDetail.START_DATE  forKey:@"startDate"];   //工单创建时间
        [dics setValue:[LoginModel shareLoginModel].orderDetail.ORDER_STATE forKey:@"orderstate"];    //工单状态
        [dics setValue:@"" forKey:@"resultHs"];    //返回参数，传入是为空字符串
        
        //参数和url
        NSString *Strs = [NSString stringWithFormat:@"%@?",HXdatacoordinationwithCRM];
        
        for (int i = 0; i <[dics count]; i++) {
            Strs = [Strs stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",[[dics allKeys] objectAtIndex:i],[[dics allValues] objectAtIndex:i]]];
        }
        NSLog(@"参数和url－－－－－－－%@\n－－－－－－－－",Strs);
        [BNNetworkTool initWitUrl:HXdatacoordinationwithCRM andParameters:dics andStyle:YES].requestData = ^(id requestData){
            if ([[requestData valueForKey:@"MSGCODE"] isEqualToString:@"0"]) {
            }else{
                [self judgeFouction:sender];
            }
        };
        
    }else{
        [self judgeFouction:sender];
    }
    
}

- (void)judgeFouction:(UIButton *)sender{
    
    if ([self.model.ORDER_STATE isEqualToString:@"2"]) {
        if (sender.tag == 8080) {
            // 取消工单状态
            [self chaneGdStatues];
        }else{
            BNCustomerController *vc = [[BNCustomerController alloc] init];
            [BNNetworkTool initWitUrl:DataPoolThreeHeartClientViewURL andParameters:self.params andStyle:YES].requestData = ^(id requestData){
                vc.model = [BNLDModel objectWithKeyValues:requestData[@"RESULT"][0] ];
                vc.params = self.params;
                [self.navigationController pushViewController:vc animated:YES];
            };
        }
    }else{
        [BNNetworkTool initWitUrl:[self judjeURLupDate] andParameters:self.params andStyle:YES].requestData = ^(id requestData){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
        };
        _flag = YES;
        
        // NSString *result = [_lab_tele.text substringToIndex:11];
        NSString *result = self.model.ORDER_PROD_LINK;
        if (sender.tag == 8080) {
            if ([[LoginModel shareLoginModel].PHONE_ID length] &&[LoginModel shareLoginModel].CALL_CODE) {
                //调用外呼接口 Forwordrequesturltoheli
                int actionID =  (arc4random() % 1000000);
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:@"Dialout" forKey:@"action"];
                [dic setValue:[NSString stringWithFormat:@"%d",actionID] forKey:@"actionID"];   //随机码
                [dic setValue:@"P000000002450" forKey:@"account"];    //账户号码
                [dic setValue:result forKey:@"exten"];      //外呼号码
                [dic setValue:[LoginModel shareLoginModel].CALL_CODE forKey:@"formExtern"]; //坐席的工号
                [dic setValue:[LoginModel shareLoginModel].PHONE_ID forKey:@"vailable"];   //外显号码
                [dic setValue:[self.params valueForKey:@"policyId"] forKey:@"policyId"];    //策略ID
                
                
                AFHTTPRequestOperationManager *magager1 = [[AFHTTPRequestOperationManager alloc] init];
                [magager1 GET:Forwordrequesturltoheli parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@",responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
                    [self.view makeToast:@"外呼接口调用失败" duration:1 position:@"center"];
                    return ;
                }];
                
            } else {
                
                NSString *str = [NSString stringWithFormat:@"tel://%@", result];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        }else{
            [self showMessageView:[NSArray arrayWithObjects:result, nil] title:@"提醒" body:_str_msg];
            
        }
    }
    
    
    
}
- (void)chaneGdStatues{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:_params];
    [params setValue:[LoginModel shareLoginModel].USER_ID forKey:@"stateExecutePerson"];
    [params setValue:[self judjeParams] forKey:@"workOrderType"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:DataPoolGDStautsNotURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject valueForKey:@"MSGCODE"] isEqualToString:@"700"]){
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reload" object:nil];
            
            NSArray *arr = [NSArray arrayWithArray:self.navigationController.childViewControllers];
            for (UIViewController *vc in arr) {
                if ([[vc class] isSubclassOfClass:[BNOrderDetailController class]]) {
                    [self.navigationController popToViewController:vc animated:NO];
                }
            }
        }    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error.description);
        }];
}

- (NSString *)judjeParams{
    NSString *model = [[NSUserDefaults standardUserDefaults] valueForKey:@"model"];
    if ([model isEqualToString:@"fz"]) {
        return   @"DP_WORKORDER_TYPE_DEVCHANCE";
        
    }else if ([model isEqualToString:@"sx"]){
        
        return  @"DP_WORKORDER_TYPE_SAN";
        
    }else{
        return  @"DP_WORKORDER_TYPE_SAN_ITEM";
    }
    
}

#pragma mark - 发送短信

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:{
            [self.view makeToast:@"短信发送成功" duration:0.5f position:@"center"];
            BNCustomerController *vc = [[BNCustomerController alloc] init];
            [BNNetworkTool initWitUrl:DataPoolThreeHeartClientViewURL andParameters:self.params andStyle:YES].requestData = ^(id requestData){
                vc.model = [BNLDModel objectWithKeyValues:requestData[@"RESULT"][0]];
                vc.params = self.params;
                [self.navigationController pushViewController:vc animated:YES];
            };
        }
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [self.view makeToast:@"短信发送失败" duration:0.5f position:@"center"];
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            [self.view makeToast:@"信息被用户取消传送" duration:0.5f position:@"center"];
            
            break;
        default:
            break;
    }
}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (NSString *)judjeURLupDate{
    
    return DataPoolGDStautsURL;
    
}

#pragma mark -WKWebDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    self.hud = [MBProgressHUD showMessage:@"趋势图加载中..." toView:_scr.personView.webView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.hud setHidden:YES];
   
}

-(void)back{
    [_scr.personView.webView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewBecomeActive{
    BNLDViewController *vc = [[BNLDViewController alloc] init];
    [BNNetworkTool initWitUrl:DataPoolThreeHeartClientViewURL andParameters:self.params andStyle:YES].requestData = ^(id requestData){
        vc.params = self.params;
        vc.model = [BNLDModel objectWithKeyValues:requestData[@"RESULT"][0]];
        [self.navigationController pushViewController:vc animated:YES];
    };
}

- (void)setNavTitle{
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setFrame:CGRectMake(0, 0,self.view.frame.size.width / 2, 40)];
        [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [back setTitle:@"< 客户视图" forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backs) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
}

- (void)backs{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
