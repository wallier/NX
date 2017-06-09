//
//  BNOrderBaseController.m
//  WorkBench
//
//  Created by mac on 16/2/2.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "BNLDViewController.h"
#import "BNOrderBaseController.h"
#import "BNCustomerController.h"
#import <MessageUI/MessageUI.h>
#import "BNLDModel.h"
@interface BNOrderBaseController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation BNOrderBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.msg addTarget:self action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
    [self.tele addTarget:self action:@selector(sengTele:) forControlEvents:UIControlEventTouchUpInside];

    [self judgeImages];
    [self addTelePhoneEvent];
    
}

- (void)viewWillAppear:(BOOL)animated{

}

- (void)resigBackActive{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addTelePhoneEvent{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goCustomerView:)];
    gesture.numberOfTouchesRequired = 1;
    gesture.numberOfTapsRequired = 1;
    self.accr.userInteractionEnabled=YES;
    [self.accr addGestureRecognizer:gesture];
}

- (void)judgeImages{
    if ([_model.ORDER_STATE isEqualToString:@"2"]) {
        [self.msg setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
        [self.tele setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    } else if ([_model.ORDER_STATE isEqualToString:@"1"]){
        //已经执行
        [self.msg setHidden:YES];
        [self.tele setHidden:YES];
    } else {
        [self.msg setImage:[UIImage imageNamed:@"datapoolp_sms_icon"] forState:UIControlStateNormal];
        [self.tele setImage:[UIImage imageNamed:@"datapoolp_call_icon"] forState:UIControlStateNormal];
    }
    
    if([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||[[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"])
    {
        //HX、WG显示短信、电话按钮
        [self.msg setHidden:NO];
        [self.tele setHidden:NO];
    }
    else
    {
        //其他不显示短信、电话按钮
        [self.msg setHidden:YES];
        [self.tele setHidden:YES];
    }
}

- (void)goCustomerView:(UITapGestureRecognizer *)gesture{
    BNCustomerController *vc = [[BNCustomerController alloc] init];
    [BNNetworkTool initWitUrl:DataPoolThreeHeartClientViewURL andParameters:self.params andStyle:YES].requestData = ^(id requestData){
        vc.model = [BNLDModel objectWithKeyValues:requestData[@"RESULT"][0]];
        vc.params = self.params;
        [self.navigationController pushViewController:vc animated:YES];
        
    };
}

- (void)viewBecomeActive{
    BNLDViewController *vc = [[BNLDViewController alloc] init];
    [BNNetworkTool initWitUrl:DataPoolThreeHeartClientViewURL andParameters:self.params andStyle:YES].requestData = ^(id requestData){
        vc.params = self.params;
        vc.model = [BNLDModel objectWithKeyValues:requestData[@"RESULT"][0]];
        [self.navigationController pushViewController:vc animated:YES];
        
    };
}
- (void)setModel:(BNOrderBaseModel *)model{

    _model = model;
    
}

- (void)viewWillLayoutSubviews{
    self.introduce.height = self.view.height - 60 - self.introduce.y;
    self.introduce.width = self.view.width - self.introduce.x;
    
    self.msg.y = CGRectGetMaxY(self.introduce.frame);
    self.tele.y = self.msg.y;
    self.tele.x = self.view.width - self.msg.x - self.tele.width;
    
    self.accr.text = _model.USER_ACCR;
    self.userName.text = _model.USER_NAME;
    self.userHy.text = _model.OFFER_NAME;
    self.endTime.text = _model.END_DATE;
    self.statrTime.text = _model.START_DATE;
    self.userDevice.text = _model.USER_TERMINAL;
    self.introduce.text = _model.POLICY_TEXT;
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0,self.view.frame.size.width / 2, 40)];
    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [back setTitle:self.navTitle
          forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(0, 0,25, 25)];
    [right setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [right setBackgroundImage:[UIImage imageNamed:[self judgeImage]] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
}

- (void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)judgeImage{
    switch ([_model.SAN_FALG intValue]) {
        case 1:
            return @"dp_workorder_worry_icon";
            break;
        case 2:
            return @"dp_workorder_carefor_icon";
            break;
        case 3:
            return @"dp_workorder_reassure_icon";
            break;
        default:
            break;
    }
    return nil;
}

- (void)sendMsg:(UIButton *)sender {
    [self CRM:(int)sender.tag];
}

- (void)sengTele:(UIButton *)sender {
    [self CRM:(int)sender.tag];
}

#pragma mark - CRM工单同步
- (void)CRM:(int)tag{
    
    [self resigBackActive];
    
    //打电话、发短信 前调用工单同步
    if ([_model.ORDER_STATE isEqualToString:@"0"]) {
        NSMutableDictionary *dics = [NSMutableDictionary dictionary];
        [dics setValue:[self.params valueForKey:@"orderNo"] forKey:@"orderNo"];    //工单流水
        [dics setValue:@"" forKey:@"orderBody"];    //回单内容，传入是为空字符串
        [dics setValue:_model.USER_ID forKey:@"userId"];    //用户实例id
        [dics setValue:[self.params valueForKey:@"ploicyId"] forKey:@"policyId"];  //策略ID
        [dics setValue:[LoginModel shareLoginModel].LOGIN_ID forKey:@"staffId"];    //登录工号 （staff_id）
        [dics setValue:_model.START_DATE  forKey:@"startDate"];   //工单创建时间
        [dics setValue:_model.ORDER_STATE forKey:@"orderstate"];    //工单状态
        [dics setValue:@"" forKey:@"resultHs"];    //返回参数，传入是为空字符串
        //参数和url
        /* NSString *Strs = [NSString stringWithFormat:@"%@?",HXdatacoordinationwithCRM];
         for (int i = 0; i <[dics count]; i++) {
         Strs = [Strs stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",[[dics allKeys] objectAtIndex:i],[[dics allValues] objectAtIndex:i]]];
         }
         NSLog(@"参数和url－－－－－－－%@\n－－－－－－－－",Strs);
         */
        [BNNetworkTool initWitUrl:HXdatacoordinationwithCRM andParameters:dics andStyle:YES].requestData =
        ^(id requestData){
            
            if ([[requestData valueForKey:@"MSGCODE"] isEqualToString:@"0"]) {
                
            }else{
                if (tag == 100) {
                    [self judgeOrder];
                } else {
                    [self callTele];
                }
                
            }
        };
    }
    else {
        if (tag == 100) {
            [self judgeOrder];
        } else {
            [self callTele];
        }
        
        
        
    }
}

#pragma mark - 打电话

- (void)callTele{
    if ([_model.ORDER_STATE isEqualToString:@"2"]) {
        //取消工单状态
        [self chaneGdStatues];
    }else{
        if ([[LoginModel shareLoginModel].PHONE_ID length] &&[[LoginModel shareLoginModel].CALL_CODE length]) {
            //调用外呼接口 Forwordrequesturltoheli
            int actionID =  (arc4random() % 1000000);
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"Dialout" forKey:@"action"];
            [dic setValue:[NSString stringWithFormat:@"%d",actionID] forKey:@"actionID"];   //随机码
            [dic setValue:@"P000000002450" forKey:@"account"];    //账户号码
            [dic setValue:_model.ORDER_PROD_LINK forKey:@"exten"];      //外呼号码
            [dic setValue:[LoginModel shareLoginModel].CALL_CODE forKey:@"formExtern"]; //坐席的工号
            
            [dic setValue:[LoginModel shareLoginModel].PHONE_ID forKey:@"vailable"];   //外显号码
            [dic setValue:[self.params valueForKey:@"policyId"] forKey:@"policyId"];    //策略ID
            [BNNetworkTool initWitUrl:Forwordrequesturltoheli andParameters:dic andStyle:YES].requestData
            = ^(id requestData){
                if (!requestData) {
                    [self.view makeToast:@"外呼接口调用失败" duration:1 position:CSToastPositionCenter];
                }
            };
            
        } else {
            NSString *str = [NSString stringWithFormat:@"tel://%@", _model.ORDER_PROD_LINK];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        //修改工单状态为执行中
        
        [BNNetworkTool initWitUrl:DataPoolGDStautsURL andParameters:self.params andStyle:YES].requestData
        = ^(id requestData){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
        };
        
        
    }
}

- (void)chaneGdStatues{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:_params];
    [params setValue:[LoginModel shareLoginModel].USER_ID forKey:@"stateExecutePerson"];
    [params setValue:[[LoginModel shareLoginModel] judjeParams] forKey:@"workOrderType"];
    NSLog(@"params===%@", params);
    [BNNetworkTool initWitUrl:DataPoolGDStautsNotURL andParameters:params andStyle:YES].requestData = ^(id requestData){
        if (!requestData) {
            [self.view makeToast:@"工单回退失败" duration:0.5 position:CSToastPositionCenter];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reload" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    };
}

#pragma mark - 发短信
- (void)judgeOrder{
    if ([_model.ORDER_STATE isEqualToString:@"2"]) {
        BNLDViewController *vc = [[BNLDViewController alloc] init];
        [BNNetworkTool initWitUrl:DataPoolThreeHeartClientViewURL andParameters:self.params andStyle:YES].requestData = ^(id requestData){
            vc.params = self.params;
            vc.model = [BNLDModel objectWithKeyValues:requestData[@"RESULT"][0]];
            [self.navigationController pushViewController:vc animated:YES];

        };
    } else {
        [self showMessageView:[NSArray arrayWithObjects:_model.ORDER_PROD_LINK , nil] title:@"提醒" body:_model.POLICY_TEXT];
        
    }
    //修改工单状态为执行中
    
    [BNNetworkTool initWitUrl:DataPoolGDStautsURL andParameters:self.params andStyle:YES].requestData
    = ^(id requestData){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
    };
    
}

#pragma mark - MsgDelegate

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:{
            [self.view makeToast:@"短信发送成功" duration:0.5f position:@"center"];
            //            BackGongDanInFoViewController *backInfo = [[BackGongDanInFoViewController alloc] init];
            //            [backInfo setNagView:@"工单回访"];
            //            backInfo.arr_data = [RAPPLICATION arr_userInfo];
            //            backInfo.params = [RAPPLICATION dic_params];
            //            [self.navigationController pushViewController:backInfo animated:YES];
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



@end
